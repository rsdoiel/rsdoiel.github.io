---
title: Deno 2.1.7, Points of Friction
byline: R. S. Doiel
abstract: |
  A short discussion of working with file input in TypeScript+Deno coming from the
  perspective of Go's idiomatic use of io buffers.
createdDate: 2025-01-26
keywords:
  - deno
  - text
  - input
---

# Deno 2.1.7, Points of Friction

By R. S. Doiel, 2025-01-26

I have run into a few points of friction in my journey with Deno coming from Go. I miss Go's standard "io" and "bufio" packages. With the Go code I'm porting TypeScript I'd often need to handle standard input or input from a named file interchangeably. Seems like this should be easy in Deno's TypeScript but there are a few bumps in the road.

Here's the Go idiom I commonly use.

~~~go
var err error
input := io.Stdin
if inFilename != "" {
    input, err := os.Open(inFilename)
    if err !== nil {
        // ... handle error
    }
    defer input.Close();
}
// Now I can just pass "in" around for processing.
~~~

Conceptually this feels simple though verbose. I can pass around the "input" for processing in a way that is agnostic as to file or standard input. This type of Go code works equally on POSIX and Windows.

Deno provide access to [standard input](https://docs.deno.com/api/deno/~/Deno.stdin). Deno supports streamable files. From the docs here's an simple example.

~~~TypeScript
// If the text "hello world" is piped into the script:
const buf = new Uint8Array(100);
const numberOfBytesRead = await Deno.stdin.read(buf); // 11 bytes
const text = new TextDecoder().decode(buf);  // "hello world"
~~~

Setting aside the buffer management code it seems simple and straight forward. It is easy to understand and you could wrap it in a function easily to hide the buffer management part. Yet it doesn't provide the same flexibility as the more verbose Go version. Surely there is an an idiomatic why of doing this in TypeScript already? 

## Stability Challenge

Deno currently is a rapidly evolving platform. My first impulse was to reach for packages like `jsr:@std/fs` or `jsr:@sys/fs`. When I search for examples they mostly seem to reference specific versions of "std/fs" that are not available via jsr. So what's the "right" way to approach this?

## Repl to the rescue.

Poking around in the Deno repl I tried assigning `Deno.stdin` to a local variable. Playing with command line completion I realized it has most of the the methods you would get if you used `Deno.open()` to open a named file.

Here's a little test I ran in the repl after creating a "hellworld.txt" text file.

~~~deno
deno
const stdin = Deno.stdin;
let input = Deno.open('helloworld.txt')
stdin.isTerminal();
input.isTerminal();
stdin.valueOf();
input.valueOf();
Deno.exit(0);
~~~

The `valueOf()` reveals their type affiliation. It listed them as `Stdin {}` and `FsFile {}` respectively. I used TypeScript's typing system to let us implement "mycat.ts". You can assign multiple types to a variable with a `|` (pipe) symbol in TypeScript. 

Used that result to write a simple cat file implementation.

~~~TypeScript
async function catFile() {
    let input : Stdin | FsFile = Deno.stdin;

    if (Deno.args.length > 0) {
        input = await Deno.open(Deno.args[0]);
    }

    const decoder = new TextDecoder();

    // NOTE: the .readable function is available on both types of objects.
    for await (const chunk of input.readable) {
        console.log(decoder.decode(chunk));
    }
}

if (import.meta.main) catFile();
~~~

You can "run" this deno to see it in action. Try running it on your "helloworld.txt" file.

~~~shell
deno run --allow-read mycat.ts helloworld.txt
~~~

You can also read from standard input too. Try the command below type in some text then press Ctrl-D or Ctrl-Z if you're on Windows.

~~~shell
deno run --allow-read mycat.ts
~~~

Looks like we have a nice solution. Now I can compile "mycat.ts".

## trouble in paradise

While you can "run" the script you can't compile it. It doesn't pass "check". This is the error I get with Deno 2.1.7.

~~~shell
deno check mycat.ts
Check file:///C:/Users/rsdoi/Sandbox/Writing/Articles/Deno/mycat.ts
error: TS2304 [ERROR]: Cannot find name 'Stdin'.
    let input : Stdin | FsFile = Deno.stdin;
                ~~~~~
    at file:///C:/Users/rsdoi/Sandbox/Writing/Articles/Deno/mycat.ts:3:17

TS2552 [ERROR]: Cannot find name 'FsFile'. Did you mean 'File'?
    let input : Stdin | FsFile = Deno.stdin;
                        ~~~~~~
    at file:///C:/Users/rsdoi/Sandbox/Writing/Articles/Deno/mycat.ts:3:25

    'File' is declared here.
    declare var File: {
                ~~~~
        at asset:///lib.deno.web.d.ts:622:13

Found 2 errors.
~~~

It seems like what works in the repl should also compile but that's isn't the case. I have an open question on Deno's discord help channel and am curious to find the "correct" way to handle this problem.

## Update 2025-01-26, 5:00PM

I heard back on Deno Discord channel for help.  With the help of [crowlKat](https://github.com/crowlKats) sorted the problem out.

The compile and runnable version of [mycat.ts](mycat.ts) looks like this.

~~~typescript
async function main() {
    let input : Deno.FsFile | any = Deno.stdin;

    if (Deno.args.length > 0) {
        input = await Deno.open(Deno.args[0]);
    }

    const decoder = new TextDecoder();

    // NOTE: the .readable function is available on both types of objects.
    for await (const chunk of input.readable) {
        console.log(decoder.decode(chunk));
    }
}

if (import.meta.main) main();
~~~

The "any" type feels a little ugly but since I am assinging the default value is `Deno.stdin` it covers that case where the `Deno.FsFile` covers the case of a name file.  Where does this leave me? I have a nice clean idiom that does what I want for interacting with standard input or a file stream.  Not necessarily the fast thing on the planet but it works.


