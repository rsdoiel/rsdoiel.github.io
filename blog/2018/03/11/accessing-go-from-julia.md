---
title: Accessing Go from Julia
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2018-03-11'
keywords:
  - Golang
  - Julia
  - shared libraries
copyright: 'copyright (c) 2018, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2018
copyrightHolder: R. S. Doiel
abstract: >+
  The problem: I've started exploring Julia and I would like to leverage
  existing

  code I've written in Go. Essentially this is a revisit to the problem in my

  last post [Go based Python
  Modules](https://rsdoiel.github.io/blog/2018/02/24/go-based-python-modules.html) 

  but with the language pairing of Go and Julia.


dateCreated: '2018-03-11'
dateModified: '2025-07-22'
datePublished: '2018-03-11'
---

# Accessing Go from Julia

By R. S. Doiel, 2018-03-11

The problem: I've started exploring Julia and I would like to leverage existing
code I've written in Go. Essentially this is a revisit to the problem in my
last post [Go based Python Modules](https://rsdoiel.github.io/blog/2018/02/24/go-based-python-modules.html) 
but with the language pairing of Go and Julia.


## Example 1, libtwice.go, libtwice.jl and libtwice_test.jl

In out first example we send an integer value from
Julia to Go and back via a C shared library (written in Go). While Julia doesn't
require type declarations I will be using those for clarity. Like in my previous post
I think this implementation this is a good starting point to see how Julia interacts with
C shared libraries. Like before I will present our Go code, an explanation 
followed by the Julia code and commentary.

On the Go side we create a _libtwice.go_ file with an empty `main()` 
function.  Notice that we also import the *C* package and use 
a comment decoration to indicate the function we are exporting
(see https://github.com/golang/go/wiki/cgo and 
https://golang.org/cmd/cgo/
for full story about Go's _C_ package and _cgo_).
Part of the what _cgo_ and the *C* package does is use the 
comment decoration to build the signatures for the function calls
in the shared C library.  The Go toolchain does all the heavy 
lifting in making a *C* shared library based on comment 
directives like "//export". We don't need much for our twice
function.

```Go
    package main
    
    import (
    	"C"
    )
    
    //export twice
    func twice(i int) int {
    	return i * 2
    }
    
    func main() {}
```

Like in our previous Python implementation we need to build the C shared
library before using it from Julia. Here are some example Go build commands
for Linux, Windows and Mac OS X. You only need to run the one that applies
to your operating system.

```shell
    go build -buildmode=c-shared -o libtwice.so libtwice.go
    go build -buildmode=c-shared -o libtwice.dll libtwice.go
    go build -buildmode=c-shared -o libtwice.dynlib libtwice.go
```

Unlike the Python implementation our Julia code will be split into two files. _libtwice.jl_ will
hold our module definition and _libtwice_test.jl_ will hold our test code. In the
case of _libtwice.jl_ we will access the C exported function via a function named *ccall*. 
Julia doesn't require a separate module to be imported in order to access a C shared library.
That makes our module much simpler. We still need to be mindful of type conversion.  Both 
Go and Julia provide for rich data types and structs.  But between Go and Julia we have C 
and C's basic type system.  On the Julia side *ccall* and Julia's type system help us
managing C's limitations.

Here's the Julia module we'll call _libtwice.jl_.

```Julia
    module libtwice
            
    # We write our Julia idiomatic function
    function twice(i::Integer)
        ccall((:twice, "./libtwice"), Int32, (Int32,), i)
    end

    end
```

We're will put the test code in a file named _libtwice\_test.jl_. Since this isn't
an establish "Package" in Julia we will use Julia's *include* statement to get bring the
code in then use an *import* statement to bring the module into our current name space.

```Julia
    include("libtwice.jl")
    import libtwice
    # We run this test code for libtwice.jl
    println("Twice of 2 is ", libtwice.twice(2))
```

Our test code can be run with

```shell
    julia libtwice_test.jl
```

Notice the amount of lifting that Julia's *ccall* does. The Julia code is much more compact
as a result of not having to map values in a variable declaration. We still have the challenges 
that Julia and Go both support richer types than C. In a practical case we should consider 
the over head of running to two runtimes (Go's and Julia's) as well as whether or not 
implementing as a shared library even makes sense. But if you want to leverage existing 
Go based code this approach can be useful.

Example 1 is our base recipe. The next examples focus on handling
other data types but follow the same pattern.


## Example 2, libsayhi.go, libsayhi.jl and libsayhi_test.jl

Like Python, passing strings passing to or from Julia and Go is nuanced. Go is expecting 
UTF-8 strings. Julia also supports UTF-8 but C still looks at strings as a pointer to an
address space that ends in a null value. Fortunately in Julia the *ccall* function combined with
Julia's rich type system gives us straight forward ways to map those value. 
Go code remains unchanged from our Python example in the previous post. 
In this example we use Go's *fmt* package to display the string. In the next example
we will round trip our string message.

```go
    package main
    
    import (
    	"C"
    	"fmt"
    )
    
    //export say_hi
    func say_hi(msg *C.char) {
    	fmt.Println(C.GoString(msg))
    }
    
    func main() { }
```

The Go source is the similar to our first recipe. No change from our
previous posts' Python example. It will need to be compiled to create our
C shared library just as before. Run the go build line that applies to
your operating system (i.e., Linux, Windows and Mac OS X).

```shell
    go build -buildmode=c-shared -o libsayhi.so libsayhi.go
    go build -buildmode=c-shared -o libsayhi.dll libsayhi.go
    go build -buildmode=c-shared -o libsayhi.dylib libsayhi.go
```

Our Julia module looks like this.

```julia
    module libsayhi

    # Now write our Julia idiomatic function using *ccall* to access the shared library
    function say_hi(txt::AbstractString)
        ccall((:say_hi, "./libsayhi"), Int32, (Cstring,), txt)
    end

    end
```

This code is much more compact than our Python implementation.

Our test code looks like

```julia
    include("./libsayhi.jl")
    import libsayhi
    libsayhi.say_hi("Hello again!")
```

We run our tests with

```shell
    julia libsayhi_test.jl
```


## Example 3, libhelloworld.go and librhelloworld.cl and libhelloworld_test.jl

In this example we send a string round trip between Julia and Go. 
Most of the boiler plate we say in Python is gone due to Julia's type system. In
addition to using Julia's *ccall* we'll add a *convert* and *bytestring* function calls
to bring our __Cstring__ back to a __UTF8String__ in Julia.

The Go implementation remains unchanged from our previous Go/Python implementation. 
The heavy lifting is done by the *C* package and the comment 
`//export`. We are using `C.GoString()` and `C.CString()` to flip between 
our native
Go and C datatypes.

```go
    package main
    
    import (
    	"C"
    	"fmt"
    )
    
    //export helloworld
    func helloworld(name *C.char) *C.char {
    	txt := fmt.Sprintf("Hello %s", C.GoString(name))
    	return C.CString(txt)
    }
    
    func main() { }
```

As always we must build our C shared library from the Go code. Below is
the go build commands for Linux, Windows and Mac OS X. Pick the line that
applies to your operating system to build the C shared library.

```shell
    go build -buildmode=c-shared -o libhelloworld.so libhelloworld.go
    go build -buildmode=c-shared -o libhelloworld.dll libhelloworld.go
    go build -buildmode=c-shared -o libhelloworld.dylib libhelloworld.go
```

In our Julia, _libhelloworld.jl_, the heavy lifting of type conversion
happens in Julia's type system and in the *ccall* function call. Additionally we need
to handle the conversion from __Cstring__ Julian type to __UTF8String__ explicitly
in our return value via a functions named *convert* and *bytestring*.

```julia
    module libhelloworld

    # Now write our Julia idiomatic function
    function helloworld(txt::AbstractString)
        value = ccall((:helloworld, "./libhelloworld"), Cstring, (Cstring,), txt)
        convert(UTF8String, bytestring(value))
    end

    end
```

Our test code looks similar to our Python test implementation.

```julia
    include("libhelloworld.jl")
    import libhelloworld
 
    if length(ARGS) > 0
        println(libhelloworld.helloworld(join(ARGS, " ")))
    else
        println(libhelloworld.helloworld("World"))
    end
```

As before we see the Julia code is much more compact than Python's.


## Example 4, libjsonpretty.go, libjsonpretty.jl and libjsonpretty_test.jl

In this example we send JSON encode text to the Go package,
unpack it in Go's runtime and repack it using the `MarshalIndent()`
function in Go's JSON package before sending it back to Julia
in C string form.  You'll see the same encode/decode patterns as 
in our *libhelloworld* example.

Go code

```go
    package main
    
    import (
    	"C"
    	"encoding/json"
    	"fmt"
    	"log"
    )
    
    //export jsonpretty
    func jsonpretty(rawSrc *C.char) *C.char {
    	data := new(map[string]interface{})
    	err := json.Unmarshal([]byte(C.GoString(rawSrc)), &data)
    	if err != nil {
    		log.Printf("%s", err)
    		return C.CString("")
    	}
    	src, err := json.MarshalIndent(data, "", "    ")
    	if err != nil {
    		log.Printf("%s", err)
    		return C.CString("")
    	}
    	txt := fmt.Sprintf("%s", src)
    	return C.CString(txt)
    }
    
    func main() {}
```

Build commands for Linux, Windows and Mac OS X are as before, pick the one that matches
your operating system.

```shell
    go build -buildmode=c-shared -o libjsonpretty.so libjsonpretty.go
    go build -buildmode=c-shared -o libjsonpretty.dll libjsonpretty.go
    go build -buildmode=c-shared -o libjsonpretty.dylib libjsonpretty.go
```

Our Julia module code

```Julia
    module libjsonpretty

    # Now write our Julia idiomatic function
    function jsonpretty(txt::AbstractString)
        value = ccall((:jsonpretty, "./libjsonpretty"), Cstring, (Cstring,), txt)
        convert(UTF8String, bytestring(value))
    end
    
    end
```

Our Julia test code

```Julia
    include("./libjsonpretty.jl")
    import libjsonpretty

    src = """{"name":"fred","age":25,"height":75,"units":"inch","weight":"239"}"""
    println("Our origin JSON src", src)
    value = libjsonpretty.jsonpretty(src)
    println("And out pretty version\n", value)
```

As before you can run your tests with `julia libjsonpretty_test.jl`.

In closing I would like to note that to use these examples I am assuming your
Julia code is in the same directory as your shared C library. Julia, like Python3,
has a feature rich module and Package system. If you are creating a serious Julia
project then you need to be familiar with how Julia's package and module system works
and place your code and shared libraries appropriately.