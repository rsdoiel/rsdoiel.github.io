{
	"markup": "mmark", 
	"title": "Portable Oberon 7",
	"series": "Mostly Oberon",
	"number": 11,
	"author": "R. S. Doiel",
	"date": "2020-08-15",
	"keywords": [ "Oberon-7", "portable", "stdin" ],
	"copyright": "copyright (c) 2020, R. S. Doiel", 
	"license": "https://creativecommons.org/licenses/by-sa/4.0/" 
}


# Portable Oberon 7 

## using OBNC modules

This is the eleventh post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html) series.
Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the 
various rabbit holes I will inevitably fall into.

## Working with standard input

By R. S. Doiel, 2020-08-15

Karl's [OBNC](https://miasap.se/obnc/) Oberon-7 compiler 
provides the Oberon-2 set of portable Oberon modules as well as 
several very useful additions making Oberon-7 suitable for 
writing programs in a POSIX environment.  We're going to 
explore several of those modules in this post as we create a 
program called [SlowCat](SlowCat.Mod).

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

## Working with Standard Input, Out

The Oakwood guides for Oberon-2 describe two modules
particularly useful for working with standard input and output.
They are appropriately called `In` and `Out`. On may Oberon Systems
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
+ `In.Done` : Is a status Boolean variable, if the last call to an procedure in `In` was successful then it is set TRUE, otherwise FALSE (e.g. we're out the end of a file)

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

```Oberon7
    REPEAT
      In.Line(text);
      IF In.Done THEN
        Out.String(text);Out.Ln();
      END;
    END In.Done = FALSE;
```

So when you read this it is easy to think of `In.Done` as you're
done reading from standard input but actually we need to check for `FALSE`.
The value of `In.Done` was indicating the success of reading our line.
An unsuccessful line read, meaning we're at the end of the file, sets
`In.Done` to false!

### Input0

There are other input modules provided by Karl than are listed in
the Oakwood guides. Basically these consist of lower level abstractions
necessary to mask the vagaries of the host system.
I don't often use `Input0` directly for basic text processing
programs but in "SlowCat" I do need to use `Input0`. `Input0`
provides an unexpectedly helpful procedure called "Time" which 
let's you read the epoch value provided by Unix. We are going to 
use this for creating a busy wait delay between displaying our 
lines of text.

### Out

As mention `Out` provides our output functions. We'll be using
two procedure from `Out`, namely `Out.String()` and `Out.Ln()`.
We've seen both before.

## Working with Karl's extensions

Karl provides a number of extension module wrapping various
POSIX calls.  We are going to use two, 
[extArgs](http://miasap.se/obnc/obncdoc/ext/extArgs.def.html) 
which provides access to command line args and 
[extConvert](http://miasap.se/obnc/obncdoc/ext/extConvert.def.html) 
which provides a means of converting strings to integers.

## Our Algorithm

To create "SlowCat" we need four procedures and one
global variable.

+ `Usage()` display a help text if parameters don't make sense
+ `ProcessArgs()` to get our delay time from the command line
+ `Delay(count : INTEGER)
+ `SlowCat(count : INTEGER)` take standard input and display like a teleprompter
+ `count` is an integer holding our delay value (seconds of waiting) which is set by ProcessArgs()

### Usage

Usage just wraps helpful text and display it to standard out.

## ProcessArgs()

This procedure uses two of Karl's extension modules to retrieve
the since command line parameter and convert the string value
retrieved into an integer.  `ProcessArgs()` return TRUE if 
we can successful convert the command line parameter and set
the value of count otherwise return FALSE.

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

```
    MODULE SlowCat;
      IMPORT In, Out, Input0, Args := extArgs, Convert := extConvert;
    
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
       start := Input0.Time();
       REPEAT
         current := Input0.Time();
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
```

## Compiling and trying it out

To compile our program and try it out reading
our source code do the following.

```
    obnc SlowCat.Mod
    # If successful
    ./SlowCat 2 < SlowCat.Mod
```


### Previous 

+ Previous [Procedures in records](../..//07/07/Procedures-in-records.html) 


