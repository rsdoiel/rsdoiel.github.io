---
title: Quick tour of Deno 2.0.2
abstract: >
  A quick tour of Deno 2 and the features I enjoy. Deno includes thoughtful
  tooling, good language support,

  ECMAScript module support and a good standard library. Deno has the advantage
  of being able to cross compile

  TypeScript to an executable which makes deployment of web services as easy for
  me as it is with Go.
created: 2024-10-18T00:00:00.000Z
updated: 2024-10-21T00:00:00.000Z
pubDate: 2024-10-18T00:00:00.000Z
byline: 'R. S. Doiell, 2024-10-18'
keywords:
  - development
  - languages
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2024-10-18'
dateModified: '2025-07-23'
datePublished: '2024-10-18'
postPath: 'blog/2024/10/18/a-quick-tour-of-deno-2.md'
---

# Quick tour of Deno 2.0.2

By R. S. Doiel

I've been working with TypeScript this year using Deno. Deno has reached version 2.0. It has proven to be a nice platform for projects. Deno includes thoughtful tooling, good language support, ECMAScript module support and a [good standard library](https://jsr.io/@std).  As a TypeScript and JavaScript platform I find it much more stable and compelling than NodeJS. Deno has the advantage of being able to cross compile TypeScript to an executable which makes deployment of web services as easy for me as it is with Go.

## Easy install with Cargo

Deno is written in Rust. I like installing Deno via Rust's Cargo. You can installed Rust via [Rustup](https://rustup.rs). When I install Deno on a new machine I first check to make sure my Rust is the latest then I use Cargo to install Deno.

~~~shell
rustup update
cargo install deno
~~~

## Easy Deno upgrade

Deno is in active development. You'll want to run the latest releases.  That's easy using Deno. It has a self upgrade option.

~~~shell
deno upgrade
~~~

## Exploring TypeScript

When I started using Deno this year I wasn't familiar with TypeScript. Unlike NodeJS Deno can run TypeScript natively. Why write in TypeScript? TypeScript is a superset of JavaScript. That means if you know JavaScript you know most of TypeScript already. Where TypeScript differs is in the support for type safety and other modern language features. Writing TypeScript for Deno is a joy because it supports the web standard ECMAScript Models. That means the code I develop to run server side can be easily targetted to work in modern browsers too. TypeScript began life as a transpiled language targeting JavaScript. With Deno's emit module I can easily transpile my TypeScript to JavaScript. No more messying about with NodeJS and npm.

## Exploring Deno

As a learning platform I find Deno very refreshing. Deno provides a [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop). That means you can easily try out TypeScript interactively. Deno is smart about when it runs "programs" versus running as a REPL. This is an improvement over NodeJS.

Deno, like your web browser, runs TypeScript and JavaScript in a sand boxed environment. The REPL gives you full access to your machine but running programs via Deno requires you to give explicit permissions to resources like reading from your file system, accessing your environment, accessing the network or importing models from remote systems. This might sound tedious but Deno makes it easy in practice.

Deno projects use a `deno.json` file for initialization. Creating the file is as easy as typing `deno init` in your project directory. Here's an example of setting up a `happy_deno` project.

~~~shell
mkdir happy_deno
cd happy_deno
deno init
~~~

If you list your directory you will see a `deno.json` file (Windows Powershell also supports "ls" to list directories).

~~~shell
ls 
~~~

The init action created the following files.

`deno.json`
: The project configuration for Deno. It includes default tasks and module imports.

`main.ts`
: This is the "main" program for your project. It's where you'll add your TypeScript code.

`main_test.ts`
: This is a test program so you can test the code you've written in your "main" module.

The task action by itself will list currently defined tasks, e.g. `deno task` (the "dev" task
was defined by the init action).

~~~shell
Available tasks:
- dev
    deno run --watch main.ts
~~~

Looking at the `deno.json` file directly we see.

~~~json
{
  "tasks": {
    "dev": "deno run --watch main.ts"
  }
}
~~~

What does that do? The "dev" task will start deno using the "run" action passing it the "watch" option when running the file "main.ts". What does mean? The "watch" option will notice of the "main.ts" file changes on disk. It it changes it will re-run the "main.ts" program.  Save a change to "main.ts" in your editor deno and automagically it runs "main.ts" again. The really helps when you are write web services, the service automatically restarts.

Here's an example of the output of running the "dev" task with the command `deno task dev`.

~~~
Task dev deno run --watch main.ts
Watcher Process started.
Add 2 + 3 = 5
Watcher Process finished. Restarting on file change...
~~~

Using your editor, add a "hello world" log message to the code in "main.ts" so it looks like this.

~~~typescript
export function add(a: number, b: number): number {
  return a + b;
}

// Learn more at https://docs.deno.com/runtime/manual/examples/module_metadata#concepts
if (import.meta.main) {
  console.log("Add 2 + 3 =", add(2, 3));
  console.log("Hello World!");
}
~~~

Save your program and look what happens.

~~~
Watcher File change detected! Restarting!
Add 2 + 3 = 5
Hello World!
Watcher Process finished. Restarting on file change...
~~~

Adding additional tasks is just a matter of editing the `deno.json` file and adding them to the `tasks` attributes.

See [deno task](https://docs.deno.com/runtime/reference/cli/task_runner/) documentation for details.

### Modules in Deno

TypeScript and JavaScript support "modules". Specifically Deno supports [ES](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) modules. The nice thing about this is ES modules can be used with the same import export syntax in your web browser supports. Deno supports local modules and remote modules accessed via URL just like your browser. At work I have our project documentation hosted on GitHub. I can write a TypeScript modules there too. I can then import them into a another project just by using the URL.

Why is the significant? I don't need to rely on an external system like [npm](https://npmjs.com) for module repositories. All I need is a simple static website. Modules in the Deno community often use <https://jsr.io/> as a common module registery. This includes Deno's standard library modules.  Let's add the standard "fs" and "path" module to our happy deno project. Use Deno's "add" action.

~~~shell
deno add jsr:@std/fs
deno add jsr:@std/path
~~~

If you look at the `deno.json` now it should look something like this.

~~~json
{
  "tasks": {
    "dev": "deno run --watch main.ts"
  },
  "imports": {
    "@std/assert": "jsr:@std/assert@1",
    "@std/fs": "jsr:@std/fs@^1.0.4",
    "@std/path": "jsr:@std/path@^1.0.6"
  }
}
~~~

To quit my deno dev task I can press the control key and the "c" key (a.k.a. Ctrl-C) in my terminal window. 

I mentioned Deno runs programs in a sand box. That is because Deno tries to be secure by default. You must explicitly allow Deno to reach outside the sand box. One resource outside the sand box is the file system. If you use our remote modules we need to give Deno permission to do that too. See [security and permissions](https://docs.deno.com/runtime/fundamentals/security/) on Deno's documentation website for more details.

To allow reading files on the local file system with the "dev" task I would modify the "dev" command to look like.

~~~
    "dev": "deno run --allow-read --watch main.ts"
~~~

You can include multiple permissions by adding the related "allow" option (E.g. `--allow-import`, `--allow-env`, `--allow-net`). It is important to realize that importing a moddel doesn't give you permission, you need to explicitly allow Deno to do that. When you compile a program the permissions you allow will also be allowed in the compiled version.

### An exercise for the reader

Create a TypeScript file called [show_deno_json.ts](show_deno_json.ts). Read in and display the contents of the "deno.json" file in the same directory.

Here's so links to documentation that may be helpful in finishing the exercise.

- [reading files](https://docs.deno.com/examples/reading-files/)

Additional reading.

- [fundamentals](https://docs.deno.com/runtime/fundamentals/)
- [file system access](https://docs.deno.com/runtime/fundamentals/security/#file-system-access)
- [standard modules](https://docs.deno.com/runtime/fundamentals/standard_library/)
- [modules](https://docs.deno.com/runtime/fundamentals/modules/)
- [deno.json](https://docs.deno.com/runtime/fundamentals/configuration/)
- [security](https://docs.deno.com/runtime/fundamentals/security/)

## Compiling TypeScript to executable code

One of the really nice things about Deno + TypeScript is that your development experience can be interactive like interpretive languages (e.g. Python, Lisp) and as convenient to deploy as a [Go](https://golang.org) executable. You can compile our "main.ts" file with the following command.

~~~
deno compile --allow-read main.ts
~~~

Listing my directory in our project I see the following.

~~~shell
deno.json    deno.lock    happy_deno   main.ts      main_test.ts
~~~

~~~
./happy_deno
~~~

NOTE: On a Windows the compiled program is named `happy_deno.exe`, to execute it I would type `.\happy_deno.exe` in your Powershell session.

By default Deno uses the project directory for the executable name. You can explicitly set the executable name with a [command line option](https://docs.deno.com/runtime/getting_started/command_line_interface/). You can also use command line options with the compile action to [cross compile](https://en.wikipedia.org/wiki/Cross_compiler) your executable similar to how it is done with Go.

Why compile your program?  Well it runs slightly fast but more importantly you can now copy the executable to another machine and run it even if Deno isn't installed. This means you no longer have the version dependency problems I typically experience with deploying code from Python and NodeJS projects.  Like Go the Deno compiler is a cross compiler. That means I can compile versions for macOS, Windows and Linux on one machine then copy the platform specific executable to the machines where they are needed. Deno's compiler provides similar advantages to Go.

## TypeScript to JavaScript with Deno

JavaScript is a first class language in modern web browsers but TypeScript is not.  When TypeScript was invented it was positioned as a [transpiled](https://en.wikipedia.org/wiki/Source-to-source_compiler) language. Deno is a first class TypeScript environment but how do I get my TypeScript transpiled to JavaScript?  Deno provides an [emit](https://jsr.io/@deno/emit) module for that. With a five lines of TypeScript I can write a bundler to convert my TypeScript to JavaScript. I can even add running that as a task to my `deno.json` file. Here's an example of "main_to_js.ts".

~~~typescript
import { bundle } from "jsr:@deno/emit";
const url = new URL("./main.ts", import.meta.url);
const result = await bundle(url);
const { code } = result;
console.log(code);
~~~

The command I use to run `main_to_js.ts` is

~~~shell
deno run --allow-read --allow-env main_to_js.ts
~~~

My `deno.json` file will look like this with a "transpile" task.

~~~json
{
  "tasks": {
    "dev": "deno run --allow-read --watch main.ts",
    "transpile": "deno run --allow-read --allow-env main_to_js.ts"
  },
  "imports": {
    "@std/assert": "jsr:@std/assert@1",
    "@std/fs": "jsr:@std/fs@^1.0.4",
    "@std/path": "jsr:@std/path@^1.0.6"
  }
}
~~~

Now when I want to see the `main.ts` in JavaScript I can do `deno task transpile`.

## Contrasting Deno + TypeScript with Go and Python

For me working in Go has been a pleasure in large part because of its tooling. The "go" command comes with module management, code formatter, linting, testing and cross compiler right out of the box. I like a garbage collected language. I like type safety. I like the ease which you can work with structured data. I've enjoyed programming with the excellent Go standard library while having the option to include third party modules if needed.

Deno with TypeScript gives me most of what I like about Go out of the box. The `deno` command includes a task runner, module manager, testing, linting (aka check), cross compiler and formatter out of the box. TypeScript interfaces provide a similar experience to working with `struct` types in Go. Unlike Go you can work with Deno interactively similar to using the REPL in Python, Lisp or your favorite SQL client. I like the ES module experience of Deno better than Go's module experience.

What makes Deno + TypeScript compelling over writing web services over Python is Deno's cross compiler.  Like Go I can compile executables for macOS, Windows and Linux on one box and target x86_64 and ARM 64 CPUs.No more need to manage virtual environments and no more sorting out things when virtual environments inevitably get crossed up. Copying an executable to the production machines is so much easier.  Many deployments boil down to an `scp` and restarting the services on the report machines. Example `scp myservice apps.example.edu:/serivces/bin/; ssh apps.example.edu "systemctl restart myservice"`.  It also means curl installs are trivial. All you need is an SH or Powershell script that can download a zip file, unpack it and copy it into the search path of the host system. Again the single self contained executable is a huge simplifier.

One feature I miss in Deno + TypeScript is the DSL in Go content strings embedded in struct type definitions. This makes it trivial to write converts for XML, JSON and YAML.  Allot of code in libraries and archives involves structured metadata and that feature ensures the structures definition are consistent between formats. I think adding to/from methods will become a chore at some point.

If you are working in Data Science domain I think Python still has the compelling code ecosystem. It works, it mature and there is lots of documentation and community out there. While you can run Deno from a [Jupyter notebook](https://docs.deno.com/runtime/reference/cli/jupyter/) I think it'll take a while for TypeScript/JavaScript to reach parity with Python for this application domain.

Switching from Go to Deno/TypeScript has been largely a matter of getting familiar with Deno, the standard library and remembering JavaScript while adding the TypeScript's type annotations. I've also had to learn TypeScript's approach to type conversions though that feels similar to Go. If I need the same functional code server side and browser side I think the Deno + TypeScript story can be compelling.

Python, Rust, Go and Deno + TypeScript all support creating and running WASM modules.  Of those languages Rust has the best story and most complete experience. Deno runs a close second. Largely because it is written in Rust so what you learn about WASM in rust carries over nicely. The Python story is better than Go at this time. This is largely a result of how garbage collection is integrated into Go.  If I write a Go WASM module there is a penalty paid when you move between the Go runtime space and the hosts WASM runtime space. This will improve over time but it isn't something I've felt comfortable using in my day to day Go work (October 2024, Go v1.23.2).

Deno makes TypeScript is a serious application language. I suspect more work projects to be implemented in TypeScript where shared server and browser code is needed. I has be useful exploring Deno and TypeScript.
