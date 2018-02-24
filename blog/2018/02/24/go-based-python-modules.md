
# Go based Python modules

By R. S. Doiel, 2018-02-24

The problem: I have written a number of Go packages at work.
My colleagues know Python and I'd like them to be able to use the
packages without resorting to system calls from Python to the
command line implementations. The solution is create a C-Shared
library from my Go packages, using Go's _C_ package and combine it
with Python's _ctypes_ package.  What follows is a series of 
simple recipes I used to understand the details of how that worked.


## Example 1, libtwice.go and twice.py

Many of the the examples I've come across on the web start by 
showing how to run a simple math operation on the Go side with
numeric values traveling round trip via the C shared library layer. 
It is a good place to start as you only need to consider type 
conversion between both Python's runtime and Go's runtime.  It 
provides a simple illustration of how the Go *C* package, Python's
*ctypes* module and the toolchain work together.

In this example we have a function in Go called "twice" it takes
a single integer, doubles it and returns the new value.  On
the Go side we create a _libtwice.go_ file with an empty `main()` 
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

On the python side we need to wrap our calls to our shared library
bringing them into the Python runtime in a useful and idiomatically
Python way. Python provides a few ways of doing this. In my examples
I am using the *ctypes* package.  _twice.py_ looks like this--

```python
    import ctypes
    import os
    
    # Set our shared library's name
    lib_name='libtwice'
    
    # Figure out shared library extension
    uname = os.uname().sysname
    ext = '.so'
    if uname == 'Darwin':
        ext = '.dylib'
    if uname == 'Windows':
        ext = '.dll'
    
    # Find our shared library and load it
    dir_path = os.path.dirname(os.path.realpath(__file__))
    lib = ctypes.cdll.LoadLibrary(os.path.join(dir_path, lib_name+ext))
    
    # Setup our Go functions to be nicely wrapped
    go_twice = lib.twice
    go_twice.argtypes = [ctypes.c_int]
    go_twice.restype = ctypes.c_int
    
    # Now write our Python idiomatic function
    def twice(i):
        return go_twice(ctypes.c_int(i))
    
    # We run this test code if with: python3 twice.py
    if __name__ == '__main__':
        print("Twice of 2 is", twice(2))
```

Notice the amount of lifting Python's *ctypes* does for us. It provides
for converting C based types to their Python counter parts. Indeed the
additional Python source here is focused around using that functionality
to create a simple Python function called twice. This pattern of 
bringing in a low level version of our desired function and then 
presenting in a Pythonic one is common in more complex C based Python
modules.  In general we need *ctypes* to access and wrapping our 
shared library. The *os* module is used so we can find our C 
shared library based on the naming conventions of our host OS. 
For simplicity I've kept the shared library (e.g. _libtwice.so_ 
under Linux) in the same directory as the python module 
code _twice.py_.

The build command for Linux looks like---

```shell
    go build -buildmode=c-shared -o libtwice.so libtwice.go
```

Under Windows it would look like---

```shell
    go build -buildmode=c-shared -o libtwice.dll libtwice.go
```

and Mac OS X---

```shell
    go build -buildmode=c-shared -o libtwice.dynlib libtwice.go
```

You can test the Python module with---

```shell
    python3 twice.py
```

Notice the filename choices. I could have called the Go shared
library anything as long as it wasn't called `twice.so`, `twice.dll`
or `twice.dylib`. This constraint is to avoid a module name collision
in Python.  If we had a Python script named `twice_test.py` and 
import `twice.py` then Python needs to make a distinction between
`twice.py` and our shared library. If you use a Python package
approach to wrapping the shared library you would have other options
for voiding name collision.

Here is an example of `twice_test.py` to make sure out import is
working.

```python
    import twice
    print("Twice 3", twice.twice(3))
```

Example 1 is our base recipe. The next examples focus on handling
other data types but follow the same pattern.


## Example 2, libsayhi.go and sayhi.py

I found working with strings a little more nuanced. Go's concept of
strings are oriented to utf-8. Python has its own concept of strings 
and encoding.  Both need to pass through the C layer which assumes 
strings are a char pointer pointing at contiguous memory ending 
in a null. The *sayhi* recipe is focused on moving a string from 
Python, to C, to Go (a one way trip this time). The example uses 
Go's *fmt* package to display the string. 

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

The Go source is similar to our first recipe but our Python modules
needs to use *ctypes* to get you Python string into shape to be
unpacked by Go.

```python
   import ctypes
   import os
   
   # Set the name of our shared library
   lib_name = 'libsayhi'

   # Figure out shared library extension
   uname = os.uname().sysname
   ext = '.so'
   if uname == 'Darwin':
       ext = '.dylib'
   if uname == 'Windows':
       ext = '.dll'
   
   # Find our shared library and load it
   dir_path = os.path.dirname(os.path.realpath(__file__))
   lib = ctypes.cdll.LoadLibrary(os.path.join(dir_path, lib_name+ext))
   
   # Setup our Go functions to be nicely wrapped
   go_say_hi = lib.say_hi
   go_say_hi.argtypes = [ctypes.c_char_p]
   # NOTE: we don't have a return type defined here, the message is 
   # displayed from Go
   
   # Now write our Python idiomatic function
   def say_hi(txt):
       return go_say_hi(ctypes.c_char_p(txt.encode('utf8')))
   
   if __name__ == '__main__':
       say_hi('Hello!')
```

Putting things together (if you are using Windows or Mac OS X
you'll adjust name output name, `libsayhi.so`, to match the
filename extension suitable for your operating system).

```bash
    go build -buildmode=c-shared -o libsayhi.so libsayhi.go
```

and testing.

```bash
    python3 sayhi.py
```


## Example 3, libhelloworld.go and helloworld.py

In this example we send a Python string to Go (which expects utf-8)
build our "hello world" message and then send it back to Python
(which needs to do additional conversion and decoding).

Like in previous examples the Go side remains very simple. The heavy
lifting is done by the *C* package and the comment `//export`. We
are using `C.GoString()` and `C.CString()` to flip between our native
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

In the python code below the conversion process is much more detailed.
Python isn't explicitly utf-8 like Go. Plus we're sending our Python 
string via C's char arrays (or pointer to chars). Finally when we 
comeback from Go via C we have to put things back in order for Python. 
Of particular note is checking how the byte arrays work then 
encoding/decoding everything as needed. We also explicitly set the result 
type from our Go version of the helloworld function.

```python
    import ctypes
    import os
    
    # Set the name of our shared library
    lib_name = 'libhelloworld'

    # Figure out shared library extension
    uname = os.uname().sysname
    ext = '.so'
    if uname == 'Darwin':
        ext = '.dylib'
    if uname == 'Windows':
        ext = '.dll'
    
    # Find our shared library and load it
    dir_path = os.path.dirname(os.path.realpath(__file__))
    lib = ctypes.cdll.LoadLibrary(os.path.join(dir_path, lib_name+ext))
    
    # Setup our Go functions to be nicely wrapped
    go_helloworld = lib.helloworld
    go_helloworld.argtypes = [ctypes.c_char_p]
    go_helloworld.restype = ctypes.c_char_p
    
    # Now write our Python idiomatic function
    def helloworld(txt):
        value = go_helloworld(ctypes.c_char_p(txt.encode('utf8')))
        if not isinstance(value, bytes):
            value = value.encode('utf-8')
        return value.decode()
    
    
    if __name__ == '__main__':
        import sys
        if len(sys.argv) > 1:
            print(helloworld(sys.argv[1]))
        else:
            print(helloworld('World'))
```

The build recipe remains the same as the two previous examples.

```bash
    go build -buildmode=c-shared -o libhelloworld.so libhelloworld.go
```

Here are two variations to test.

```bash
     python3 helloworld.py
     python3 helloworld.py Jane
```


## Example 4, libjsonpretty.go and jsonpretty.py

In this example we send JSON encode text to the Go package,
unpack it in Go's runtime and repack it using the `MarshalIndent()`
function in Go's JSON package before sending it back as Python
in string form.  You'll see the same encode/decode patterns as 
in our *helloworld* example.

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

Python code

```python
    import ctypes
    import os
    import json
    
    # Set the name of our shared library
    lib_name = 'libjsonpretty'

    # Figure out shared library extension
    uname = os.uname().sysname
    ext = '.so'
    if uname == 'Darwin':
        ext = '.dylib'
    if uname == 'Windows':
        ext = '.dll'

    dir_path = os.path.dirname(os.path.realpath(__file__))
    lib = ctypes.cdll.LoadLibrary(os.path.join(dir_path, lib_name+ext))
    
    go_jsonpretty = lib.jsonpretty
    go_jsonpretty.argtypes = [ctypes.c_char_p]
    go_jsonpretty.restype = ctypes.c_char_p
    
    def jsonpretty(txt):
        value = go_jsonpretty(ctypes.c_char_p(txt.encode('utf8')))
        if not isinstance(value, bytes):
            value = value.encode('utf-8')
        return value.decode()
    
    if __name__ == '__main__':
        src = '''
    {"name":"fred","age":25,"height":75,"units":"inch","weight":"239"}
    '''
        value = jsonpretty(src)
        print("Pretty print")
        print(value)
        print("Decode into dict")
        o = json.loads(value)
        print(o)
```

Build command

```shell
    go build -buildmode=c-shared -o libjsonpretty.so libjsonpretty.go
```

As before you can run your tests with `python3 jsonpretty.py`.

In closing I would like to note that to use these examples you Python3
will need to be able to find the module and shared library. For 
simplicity I've put all the code in the same directory. If your Python
code is spread across multiple directories you'll need to make some 
adjustments.

