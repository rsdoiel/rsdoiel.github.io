{
    "markup": "mmark"
}


# Mostly Oberon

By R. S. Doiel, 2020-04-11

Mostly Oberon is a series of blog posts documenting some of my experience exploring the Oberon Language, Oberon System and the various rabbit wholes I will inevitably fall into.

## Overview

Oberon[^1] is a classical computer language and operating system originated by Niklaus Wirth and Jürg Gutknecht at [ETH](https://en.wikipedia.org/wiki/ETH_Zurich) circa 1987.  It was inspired by their experiences in California at the [Xerox Palo Alto Research Center](https://en.wikipedia.org/wiki/PARC_(company).  This series of blog posts are my meandering exploration of Oberon 7 language based on [Project Oberon 2013](http://www.projectoberon.com/).


## My Voyage

I am new to both Oberon and the Oberon System.  Oberon language is in the tradition of ALGOL, Pascal, Modula 1 and 2 as well as incorporating ideas from the parent of Object Oriented languages Simula. I found certain aspects of Oberon language remind me of my first programming language [Turbo Pascal](https://en.wikipedia.org/wiki/Turbo_Pascal).  Oberon's language shape is more Pascal than C. For that reason I think it has largely been overlooked by many.

Oberon 7 is Wirth's most recent refinement of the Oberon language.  It is a terse and powerful systems language.  It strikes a different computing path then many popular programming languages used in 2020.  You find its influence along with Simula in more recent popular languages like [Go](https://golang.org).

While Wirth conceived of Oberon in the context of a whole system it's use in research and instruction means it is also well suited [POSIX](https://en.wikipedia.org/wiki/POSIX) based systems (e.g. BSD, Linux, macOS).  The difference in programming in Oberon for a POSIX system versus a native Oberon System is primarily in the modules you import. These posts will focus on using Oberon language in a POSIX environment.

The latest Oberon is Niklaus Wirth and Paul Reeds' Project Oberon 2013. If you want to explore it I suggest using Peter De Wachter's [emulator](https://github.com/pdewacht/oberon-risc-emu). Project Oberon also his links to the updated books and articles in PDF format which are easy to read (or print) on most computing devices.


## A starting point

I am starting my exploration with Karl Landström's [OBNC](https://miasap.se/obnc/) compiler. I am focusing on getting comfortable using and writing in the Oberon language.

Here's an example of a simple "Hello World"[^2] program in Oberon written for a POSIX system. I've named the [source code](HelloWorld.Mod) `HelloWorld.Mod`.

```Oberon
    MODULE HelloWorld;
      IMPORT Out;
    BEGIN
      Out.String("Hello World!"); Out.Ln;
    END HelloWorld.
```

While this is longer than a Python "hello world" program it is much shorter than I remember writing in Java and about the same number of lines as in C. `BEGIN` and `END` are similar to our opening and closing curly braces in C and the module is the basic unit of source code in Oberon. `IMPORT` includes the module `Out` (modules are similar to a included library in C) for sending values to the console (stdout in POSIX). One thing to note, Oberon language(s) are case sensitive. All language terms are capitalized. This makes it easy to distinguish between source code written in Oberon versus the Oberon language itself.

The `Out` module includes methods for displaying various data types native
to Oberon. There is a corresponding `In` for receiving input as well as
some additional modules provided with our chosen compiler implementation.

Modules in Oberon can include a module wide initialization block. The
`BEGIN` through `END HelloWorld.` are an initialization block. This is
similar to C or Go's "main" function for our POSIX environment.

### OBNC

If you want to run my "Hello World" you need to compile it.  I have found that [OBNC](https://miasap.se/obnc/) compiler runs well on Linux, macOS and [Raspberry Pi](https://www.raspberrypi.org). Karl has also made a precompiled version that runs on Windows available too. It is the Oberon compiler I plan to use in this series of posts.

OBNC compiles Oberon source into C then into machine code for the computer system you are running on. Because it is compiling to C it can function as a [cross compiler](https://en.wikipedia.org/wiki/Cross_compiler). This opens the door to [bare metal programming](https://en.wikipedia.org/wiki/Bare_machine).

If you're following along please install OBNC on your computer.  Instructions are found at https://maisap.se/obnc. Karl also has excellent documentation and is responsive to questions about his implementation. His contact methods are included on his website.


### Running OBNC

OBNC provides a Oberon 7 compiler with some optional modules for working in a POSIX environment.  Compiling our "Hello World" is easy from your shell or terminal.

```
    obnc HelloWorld.Mod
```

If all goes well this should produce a executable file named `HelloWorld` (or `HelloWorld.exe` on Windows). You can now run this program with a command like `./HelloWorld` (or `HelloWorld` on Windows).

### Learning more about Oberon

I have faced two challenges in my exploration of Oberon, finding a compiler I was happy with (thank you Karl for OBNC) and sorting out the literature around Oberon language implementations and system versions.

Oberon has a rich history though it was not well known in Southern California. Oberon's history is primarily academic and European. It was commonly used in college level instruction in Europe from it's inception at ETH in the late 80's through the early 2000s. The Oberon System is an Open Source system (predating the term by a decade) and was created in the spirit of other academic systems such as BSD. There are many books (physical books as opposed to ebooks) dating from that era.  They covered the Oberon language and system of their time.  From a historical computing point of view they are still very interesting. But running Oberon on modern 2020 hardware is a little more challenging. Fortunately Prof. Emeritus Wirth and Prof. Paul Reed brought things up to date in 2013. I recommend Reed's [www.projectoberon.com](https://www.projectoberon.com) as a good place to start. He includes links to revised versions of the classic Oberon and Oberon System texts written by Wirth et el. Prof. Wirth's [website](https://inf.ethz.ch/personal/wirth/) is still maintained[^3] and he features links to most of his major publications. His is the canonical source of information on Oberon.

I have found the ACM [Digital Library](https://dl.acm.org/) and the ETH [Research Collection](https://www.research-collection.ethz.ch/?locale-attribute=en) very helpful.  While much of the material is now historic it remains useful for both techniques and inspiration.  Today's hardware, even a Raspberry Pi Zero, is more resource rich than the original systems Oberon ran on.

The online community for Oberon and Oberon System seems mostly centered around a [mail list](https://lists.inf.ethz.ch/mailman/listinfo/oberon) at ETH and net news group [comp.lang.oberon](https://groups.google.com/forum/#!forum/comp.lang.oberon)




[^1]: Oberon grew from Wirth's Modula, which grew from Pascal, which grew from his experiences with Algol.

[^2]: In 2020 common POSIX systems include [Linux](https://en.wikipedia.org/wiki/Linux, [BSD](https://en.wikipedia.org/wiki/Berkeley_Software_Distribution) and [macOS](https://en.wikipedia.org/wiki/MacOS).

[^3]: Prof. Wirth's personal website at ETH was available as of 2020-04-11. 

