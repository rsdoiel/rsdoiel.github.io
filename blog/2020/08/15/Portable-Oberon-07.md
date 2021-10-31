---
title: "Portable Oberon-07"
series: "Mostly Oberon"
number: 11
author: "R. S. Doiel"
date: "2020-08-15"
keywords: [ "Oberon", "portable", "stdin" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---


# Portable Oberon-07

## using OBNC modules

This is the eleventh post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html) series.
Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the
various rabbit holes I will inevitably fall into.

## Working with standard input

By R. S. Doiel, 2020-08-15 (updated: 2020-09-05)

Karl Landström's [OBNC](https://miasap.se/obnc/), Oberon-07 compiler,
comes with an Oberon-2 inspired set of modules
described in the Oakwood Guidelines as well as
several very useful additions making Oberon-07 suitable for
writing programs in a POSIX environment.  We're going to
explore three of the Oakwood modules and two of Karl's own additions
in this post as we create a program called [SlowCat](SlowCat.Mod).
I am using the term "portable" to mean the code can be compiled
using OBNC on macOS, Linux, and Raspberry Pi OS and Windows 10
(i.e. wherever OBNC is available). The Oakwood Guideline modules
focus on portability between an Oberon System and other systems.
I'll leave that discussion along with
[POW!](http://www.fim.uni-linz.ac.at/pow/pow.htm)
to the end of this post.


### SlowCat

Recently while I was reviewing logs at work using [cat](https://en.wikipedia.org/wiki/Cat_(Unix)), [grep](https://en.wikipedia.org/wiki/Grep)
and [more](https://en.wikipedia.org/wiki/More_(command)) it
struck me that it would have been nice if **cat**
or **more** came with a time delay so you could use them like a
teleprompter. This would let you casually watch the file scroll
by while still being able to read the lines. The program we'll build
in this post is "SlowCat" which accepts a command line parameter
indicating the delay in seconds between display each line read from
standard input.

## Working with Standard Input and Output

The Oakwood guides for Oberon-2 describe two modules
particularly useful for working with standard input and output.
They are appropriately called `In` and `Out`. On many Oberon Systems
these have been implemented such that your code could run under Unix
or Oberon System with a simple re-compile.  We've used `Out` in our
first program of this series, "Hello World". It provides a means to
write Oberon system base types to standard out.  We've used `In`
a few times too. But `In` is worth diving into a bit more.

### In

The [In](http://miasap.se/obnc/obncdoc/basic/In.def.html) module provides
a mirror of inputs to those of [Out](http://miasap.se/obnc/obncdoc/basic/Out.def.html). In Karl's implementation we are interested in one procedure
and module status variable.

+ `In.Line(VAR line: ARRAY OF CHAR)` : Read a sequence of characters from standard input from the current position in the file to the end of line.
+ `In.Done` : Is a status Boolean variable, if the last call to an procedure in `In` was successful then it is set TRUE, otherwise FALSE (e.g. we're at the end of a file)

We use Karl's `In.Line()` extension to the standard `In` implementation
before and will do so again as it simplifies our code and keeps things
easily readable.

There is one nuance with `In.Done` that is easy to get tripped up on.
`In.Done` indicates if the last operation was successful.
So if you're using `In.Line()` then `In.Done`
should be true if reading the line was successful. If you hit the end of
the file then `In.Done` should be false.  When you write your loop
this can be counter intuitive.  Here is a example of testing `In.Done`
with a repeat until loop.


~~~

    REPEAT
      In.Line(text);
      IF In.Done THEN
        Out.String(text);Out.Ln();
      END;
    UNTIL In.Done = FALSE;

~~~


So when you read this it is easy to think of `In.Done` as you're
done reading from standard input but actually we need to check for `FALSE`.
The value of `In.Done` was indicating the success of reading our line.
An unsuccessful line read, meaning we're at the end of the file, sets
`In.Done` to false!

### Out

As mention `Out` provides our output functions. We'll be using
two procedure from `Out`, namely `Out.String()` and `Out.Ln()`.
We've seen both before.

### Input

"SlowCat" needs to calculate how often to write a line of
text to standard output with the `Out` module.  To do that
I need access to the system's current time.  There isn't an
Oakwood module for time. There is a module called 
`Input` which provides a "Time" procedure. As a result
I need to import `Input` as well as `In` even though
I am using `In` to manage reading the file I am processing
with "SlowCat".

A note about Karl's implementation.  `Input` is an Oakwood
module that provides access to three system resources -- 
mouse, keyboard and system time.  Karl 
provides two versions `Input` and `Input0`, the first is
intended to be used with the `XYPlane` module for graphical
applications the second for POSIX shell based application.
In the case of "SlowCat" I've stuck with `Input` as I am 
only accessing time I've stuck with `Input` to make my source
code more portable if you're using another Oberon compiler.

## Working with Karl's extensions

This is the part of my code which is not portable
between compiler implementations and with Oberon Systems.
Karl provides a number of extension module wrapping various
POSIX calls.  We are going to use two,
[extArgs](http://miasap.se/obnc/obncdoc/ext/extArgs.def.html)
which provides access to command line arguments and
[extConvert](http://miasap.se/obnc/obncdoc/ext/extConvert.def.html)
which provides a means of converting strings to integers.
If you are using another Oberon compiler you'll need to 
find their equivalents and change my code example. I
use `extArgs` to access the command line parameters
included in my POSIX shell invocation and I've used
`extConvert` to convert the string presentation of the
delay to an integer value for my delay.


## Our Approach

To create "SlowCat" we need four procedures and one
global variable.

`Usage()`
: display a help text if parameters don't make sense

`ProcessArgs()`
: to get our delay time from the command line

`Delay(count : INTEGER)`
: a busy wait procedure

`SlowCat(count : INTEGER)`
: take standard input and display like a teleprompter

`count`
: is an integer holding our delay value (seconds of waiting) which is set by ProcessArgs()

### Usage

Usage just wraps helpful text and display it to standard out.

## ProcessArgs()

This a functional procedure. It uses two of Karl's extension
modules. It uses `extArgs` to retrieve the command line parameters
and `extConvert` the string value retrieved into an integer.
`ProcessArgs()` returns TRUE if we can successful convert the
command line parameter and set the value of count otherwise return
FALSE.

## Delay(VAR count : INTEGER)

This procedure uses `Input0` to fetch the current epoch time
and counts the number of seconds until we've reached our delay
value. It's a busy loop which isn't ideal but does keep the
program simple.

## SlowCat(VAR count: INTEGER);

This is the heart of our command line program. It reads
a line of text from standard input, if successful writes it
to standard out and then waits using delay before repeating
this process. The delay is only invoked when a reading a
line was successful.

## Putting it all together

Here's a "SlowCat" program.


~~~

    MODULE SlowCat;
      IMPORT In, Out, Input, Args := extArgs, Convert := extConvert;

    CONST
      MAXLINE = 1024;

    VAR
      count: INTEGER;

    PROCEDURE Usage();
    BEGIN
      Out.String("USAGE:");Out.Ln();
      Out.Ln();
      Out.String("SlowCat outputs lines of text delayed by");Out.Ln();
      Out.String("a number of seconds. It takes one parameter,");Out.Ln();
      Out.String("an integer, which is the number of seconds to");Out.Ln();
      Out.String("delay a line of output.");Out.Ln();
      Out.String("SlowCat works on standard input and output.");Out.Ln();
      Out.Ln();
      Out.String("EXAMPLE:");
      Out.Ln();
      Out.String("    SlowCat 15 < README.md");Out.Ln();
      Out.Ln();
    END Usage;

    PROCEDURE ProcessArgs() : BOOLEAN;
      VAR i : INTEGER; ok : BOOLEAN; arg : ARRAY MAXLINE OF CHAR;
          res : BOOLEAN;
    BEGIN
      res := FALSE;
      IF Args.count = 1 THEN
        Args.Get(0, arg, i);
        Convert.StringToInt(arg, i, ok);
        IF ok THEN
           (* convert seconds to microseconds of clock *)
           count := (i * 1000);
           res := TRUE;
        END;
      END;
      RETURN res
    END ProcessArgs;

    PROCEDURE Delay*(count : INTEGER);
      VAR start, current, delay : INTEGER;
    BEGIN
       start := Input.Time();
       REPEAT
         current := Input.Time();
         delay := (current - start);
       UNTIL delay >= count;
    END Delay;

    PROCEDURE SlowCat(count : INTEGER);
      VAR text : ARRAY MAXLINE OF CHAR;
    BEGIN
      REPEAT
        In.Line(text);
        IF In.Done THEN
          Out.String(text);Out.Ln();
          (* Delay by count *)
          Delay(count);
        END;
      UNTIL In.Done = FALSE;
    END SlowCat;

    BEGIN
      count := 0;
      IF ProcessArgs() THEN
        SlowCat(count);
      ELSE
        Usage();
      END;
    END SlowCat.

~~~


## Compiling and trying it out

To compile our program and try it out reading
our source code do the following.


~~~

    obnc SlowCat.Mod
    # If successful
    ./SlowCat 2 < SlowCat.Mod

~~~



## Oakwood Guidelines and POW!

Oberon and Oberon-2 were both used in creating and enhancing the
Oberon System(s) as well as for writing programs on other operating
systems (e.g. Apple's Mac and Microsoft Windows).
Implementing Oberon compilers on non Oberon Systems required clarification
beyond the specification. The Oakwood Guidelines were an agreement
between some of the important Oberon-2 compiler implementers which
attempted to fill in that gap while encouraging portability in
source code between operating systems. Portability was desirable
because it allowed programmers (e.g. students) to compile
and run their Oberon programs with minimal modification in any
environment where an Oakwood compliant compiler was available.

Citation for Oakwood can be found in [Oberon-2 Programming with Windows](https://archive.org/details/oberonprogrammin00mhlb/page/n363/mode/2up?q=Oakwood+Guidlines).

> Kirk B.(ed): The Oakwood Guidelines for Oberon-2 Compiler Developers. Available via FTP from ftp.fim.uni-linz.ac.at, /pub/soft/pow-oberon/oakwood

The FTP machine doesn't exist any more and does not appear to have been included in JKU's preservation plans. Fortunately the POW! website has been preserved.

[POW!](http://www.fim.uni-linz.ac.at/pow/pow.htm) was a
different approach. It was a compiler and IDE targeting
other than Oberon Systems (e.g. Windows and later Java). It was
intended to be used in a hybrid development environment and to
facilitate leveraging non-Oberon resources (e.g. Java classes,
native Windows API).  POW project proposed "Opal" which was a
super set of modules that went beyond Oakwood. Having skimmed
"Oberon-2 Programming with Windows" some may seem reasonable to
port to Oberon-07, others less so.

Why Oakwood and POW? These efforts are of interest to Oberon-07
developers as a well worn path to write code that is easy to
compile on POSIX systems and on systems that are based on the
more recent [Project Oberon 2013](http://www.projectoberon.com/).
It enhances the opportunity to bring forward well written modules
from prior systems like [A2](https://en.wikibooks.org/wiki/Oberon/A2)
but implemented for the next generation of Oberon Systems
like [Integrated Oberon](https://github.com/io-core/io).

### Oakwood PDF

Finding a PDF of the original Oakwood guidelines is going to become
tricky in the future. It was created by Robinson Associates and the
copy I've read from 1995 includes a page saying not for distribution.
Which sorta makes sense in the era of closed source software
development. It is problematic for those of us who want to explore
how systems evolved.  The term "Oakwood Guidelines" is bandied about
after 1993 and several of the modules have had influence on the language
use via book publications.  I was able to find a PDF of the 1995
version of the guidelines at
[http://www.math.bas.bg/bantchev/place/oberon/oakwood-guidelines.pdf](http://www.math.bas.bg/bantchev/place/oberon/oakwood-guidelines.pdf).

Here's a typical explanation of Oakwood from 
[http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers#The_Oakwood_Guidelines](http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers#The_Oakwood_Guidelines)
for a description of Oakwood.

> __The Oakwood Guidelines for the Oberon-2 Compiler Developers /These guidelines have been produced by a group of Oberon-2 compiler developers, including ETH developers, after a meeting at the Oakwood Hotel in Croydon, UK in June 1993__

[http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers#The_Oakwood_Guidelines](http://www.edm2.com/index.php/The_Oakwood_Guidelines_for_Oberon-2_Compiler_Developers#The_Oakwood_Guidelines)  
(an OS/2 developer website) was helpful for providing details about Oakwood.

It would have been nice if the Oakwood document had made its way
into either ETH's or JKU's research libraries.

Leveraging prior art opens doors to the past and future. Karl has
done with this with the modules he provides with his OBNC compiler
project.

### Next and Previous

+ Next [Oberon to Markdown](../../10/03/Oberon-to-markdown.html)
+ Previous [Procedures in records](../..//07/07/Procedures-in-records.html)

