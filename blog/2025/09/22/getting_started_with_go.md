---
title: Getting started with Go
description: A quick intro to Go and tool chain
author: R. S. Doiel
dateCreated: '2025-09-22'
dateModified: '2025-09-22'
datePublished: '2025-09-22'
postPath: 'blog/2025/09/22/getting_started_with_go.md'
keywords:
  - Golang
---

# Getting started with Go

By R. S. Doiel, 2025-09-22

This is just a quick tutorial covering installing the Go compile and toolchain and learning the basic tools through creating three programs -- hello world, a web server and a Markdown server. It is not a [tutorial](https://go.dev/learn/#selected-tutorials) on the Go language. The [Go website](https://go.dev) has that covered. This is really just the bare minimum to get started with the `go` command. 

Here's the files source files we'll be using in this tutorial

- [helloworld.go](helloworld/helloworld.go)
- [webserver.go](webserver/webserver.go)
- [markdown.go](mdserver/markdown.go)
- [markdown_test.go](mdserver/markdown_test.go)
- [handler.go](mdserver/handler.go)
- [handler_test.go](mdserver/handler_test.go)
- [mdserver's main](mdserver/cmd/mdserver/main.go)


## Installing Go and making sure it works

 It covers the basics of how the Go compiler and tool change work by walking throw three Go programs. The first one is to create a hello world program to make sure Go is available and working. The steps will be as follows.

1. Download and install Go, see <https://go.dev/dl/> (latest is currently 1.25.1)

## Creating hello world, making sure Go tool chain is working

1. Open a terminal
2. create a directory/folder you'll use for you creating a hello world program
3. Change into that directory
4. Type in the hello world program below and save it as "hello.go"
5. Try running "hello.go"
6. Follow the instruction to "build" the hello.go program (you're compiling the Go source into an executable)
7. Run you newly created executable

Here's the steps we'll take starting with step #3.

~~~shell
mkdir helloworld
cd helloworld
edit hello.go
go run hello.go
go build hello.go
./hello
cd ..
~~~

Here's the source code to hello world in Go

~~~go
package main

import (
    "fmt"
) 

func main() {
    fmt.Println("Hello World!")
}
~~~

If you got this far you've created your first Go program.

What are the parts of the source code package to take note of?

`package main`
: Identifies what "package" or module that the source file belongs to. The "main" package is special in that it what represents a stand alone program.

`import`
: This is a statement (including the contents inside the parenthesis) that shows what modules your program relies on.

`func`
: This defines a functions, in this case the main function.

`"fmt"`
: This is the name of the module for formatting text, includes functions like Println that display a line of text.

Things to keep in mind.  Go is a typed linguage. Variables and constants can be declared explicitly or be implicitly used on their first assignment.  Scope is block level like Python, TypeScript or ES6 when using "let".

Capticalized functions, variables and constants are "exported" from the current module and can be referenced when that package is later imported. When we use the imported "fmt" package with the "Println" function, the fact that it is capitalized means it can be used in the scope of our package. Other things inside of "fmt" which are not capitilized don't get exported and are not visible inside the current package scope. Capitization is like the "export" keyword in TypeScript or JavaScript.

Packages and modules are Go's resuable unit of code. Originally Go called them "packages", hence the "package" declaration in our program.  There are some technical distinctions. A packages are a collection of Go files in a directory.  They don't necessarily cary dependencies in them. This can be an issue for you are importing packages that might break between versions. Modules are implemented using packages but carry the dependency information with them so you compiles are consistant regardless of the latest release of a package that was imported. See the "mod" command below.

Let's look at the go command before looking at the source code. The go command is actually a collection of tools. The commons I used most frequently are the following.

run
: Run the main package Go file

build
: This compiles the program into an executable. It can also be used to cross compile if you set some environment variables

fmt
: Format the source code to a standard set by the Go community

vet
: Perform analysis on your Go source file(s) and indicate potention issues

We'll use the following two when we build our web server since it'll be constructed as a module.

mod
: Setup and maintain go module (this is be covered later)

test
: Test a go module (e.g. files that end in "_test.go")

## Build a static web server

We'll be doing the following next.

1. Create a new directory for our web server
2. Change into it.
3. Go to the http package docs, <https://pkg.go.dev/net/http#example-FileServer-DotFileHiding>
4. Copy the example for the dot file hiding file server and save as webserver.go
5. Create a hello world index.html file.
6. Use Go "run" our static web server

~~~shell
mkdir webserver
cd webserver
edit webserver.go
edit hello.html
go run webserver.go
# You can open your web browser to http://localhost:8080/hello.html
cd ..
~~~

## Build a Markdown web server

1. Create a new directory called "mdserver"
2. Change into it
3. Initialize the Go module we'll build (e.g. 'github.com/rsdoiel/mdserver', you'd use something that makes sense for you)
4. Add a Go modules for working with Markdown, "github.com/yuin/goldmark"
5. Write a function to convert Markdown into HTML in a file called markdown.go
6. Write a test function called MarkdownToHTML in a file called markdown_test.go
7. Run the test to make sure it works
8. Write a the function MarkdownHandler function and save it markdown.go
8. mkdir called "cli"
9. Copy "../webserver/webserver.go" to "cli/mdserver.go"
10. Update "cmd/mdserver/mdserver.go" to import our mdserver package
11. Wrap the dot file handler function with our MarkdownHandler function
12. Using go run to test our web server

~~~shell
mkdir mdserver
cd mdserver
go mod init 'github.com/rsdoiel/mdserver'
go mod tidy
go get "github.com/yuin/goldmark"
edit markdown.go
edit markdown_test.go
go test
# Now we're going to create our handler function and test of it
edit handler.go
edit handler_test.go
go test
# Now let's create our wrapping cli
mkdir -p cmd/mdserver
copy ../webserver/webserver.go cmd/mdserver/main.go
# Import our mdserver package and wrap the dotFileHandler function with the Markdown function
edit cmd/mdserver/main.go
go run cmd/mdserver/main.go
~~~


We can make a mdserver executable using the build command and specify an output name.

~~~shell
go build -o bin/mdserver cmd/mdserver/main.go
~~~

You've not create Go program that is defined by a module/package "mdserver" and runs that package in a command line program. What's left is to learn the language itself, get familiar with the standard library and write more Go programs.

## Next Steps

- Go through some of the Go.dev tutorials to better understand Go
  - Familiarize yourself with the Go standard library
- Try adding a YAML configuration to our two web server example
- Try out cross compiling to other computer platforms