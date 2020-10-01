{
    "markup": "mmark",
    "title": "Software Tools, Getting Started",
    "number": 1,
    "byline": "R. S. Doiel",
    "date": "2020-09-29",
    "copyright": "copyright (c) 2020, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}


# Software Tools, Getting Started

## Overview

This post is the first in a series revisiting the
programs described in the 1981 book by Brian W. Kernighan and
P. J. Plauger's called [Software Tools in Pascal](https://archive.org/details/softwaretoolsinp00kern).
The book is available from the [Open Library](https://openlibrary.org/)
and physical copies are still (2020) commonly available from used book
sellers.  The book was an early text on creating portable command
line programs.  

In this series I present the K & P (i.e. Software Tools in Pascal)
programs re-implemented in Oberon-7. I am testing my implementations
using Karl Landström's [OBNC](http://miasap.se/obnc/)
compiler and his implementation of the Oakwood Guide's modules
for portable Oberon programs. Karl also provides a few additional
modules for working in a POSIX environment (e.g. BSD, macOS, Linux,
Windows 10 with Linux subsystem).

NOTE: OBNC compiler is the work of Karl Langström, it is portable across many systems where the C tool chain is available.

NOTE: POSIX defines a standard of compatibility inspired by [UNIX](https://en.wikipedia.org/wiki/Unix), see <https://en.wikipedia.org/wiki/POSIX>


## Getting Started.

Chapter one in K & P is the first chapter that presents code. It introduces
some challenges and constraints creating portable Pascal suitable for use
across hardware architectures and operating systems. In 1981 this included
mainframes, minicomputers as well as the recent evolution of the microcomputer.
The programs presented build up from simple to increasingly complex as
you move through the book.  They provide example documentation and discuss
their implementation choices. It is well worth reading the book for those
discussions, while specific to the era, mirror the problems program authors
face today in spite of the wide spread success of the POXIS model, the
consolidation of CPU types and improvements made in development tools in
the intervening decades.

Through out K & P you'll see the bones of many POSIX commands we have today.

Programs from this chapter include:

1. **copyprog**, this is like "cat" in a POSIX system
2. **charcount**, this is like the "wc" POSIX command using the "-c" option
3. **linecount**, this is like the "wc" POSIX command using the "-l" option
4. **wordcount**, this is like the "wc" POSIX command using the "-w" option
5. **detab**, converts tabs to spaces using tab stops every four characters in a line

All programs in this chapter rely solely on standard input and output.
Today's reader will notice an absence to common concepts in today's
command line programs.  First is the lack of interaction with command line
parameters, the second is no example take advantage of environment variables.
These operating system features were not always available across
operating systems of the early 1980s. Finally I'd like to point out a
really nice feature included in the book. It is often left out as a topic
in programming books.  K & P provide example documentation. It's structure
like an early UNIX man page. It very clear and short. This is something
I wish all programming texts at least mentioned. Documentation is important
to the program author because it clarifies scope of the problem being
tackled and to the program user so they understand what they are using.


### [1.1. File Copying](https://archive.org/details/softwaretoolsinp00kern/page/7/mode/1up)

Here's how K & P describe "copyprog.pas" (refered to as "copy" in
the documentation).


~~~

PROGRAM

    copy    copy input to output

USAGE

    copy

FUNCTION

    copy copies its input to its output unchanged. It is useful for copying
    from a terminal to a file, from file to file, or even from terminal to
    terminal. It may be used for displaying the contents of a file, without
    interpretation or formatting, by copying from the file to terminal.

EXAMPLE

    To echo lines type at your terminal.

    copy
    hello there, are you listening?
    **hello there, are you listening?**
    yes, I am.
    **yes, I am.**
    <ENDFILE>

~~~

The source code for "copyprog.pas" is shown on
[page 9](https://archive.org/details/softwaretoolsinp00kern/page/9/mode/1up)
of K & P.  First the authors introduce the __copy__ procedure
then a complete the section introducing it in context of the complete Pascal
program. After this first example K & P leave implementation of the full
program up to the reader.

The body of the Pascal program invokes a procedure called
[copy](https://archive.org/details/softwaretoolsinp00kern/page/8/mode/1up)
which reads from standard input character by character and writes
to standard output character by character without modification.  Two
supporting procedures are introduced, "getc" and "putc". These are shown
in the complete program listing on page 9. They are repeatedly used
through out the book. One of the really good aspects of this simple
program is relying on the idea of standard input and output. This makes
"copyprog.pas" a simple filter and template for writing many of the programs
that follow. K & P provide a good explanation for this simple approach.
Also note K & P's rational for working character by character versus
line by line.

My Oberon-7 version takes a similar approach. The module looks remarkably
similar to the Pascal but is shorter because reading and writing characters are
provided for by Oberon's standard modules "In" and "Out".
I have chosen to use a "REPEAT/UNTIL" loop over the "WHILE"
loop used by K & P is the attempt to read from standard input needs to happen
at least once. Note in my "REPEAT/UNTIL" loop's terminating condition.
The value of `In.Done` is true on successful read and false
otherwise (e.g. you hit an end of the file). That means our loop must
terminate on `In.Done # TRUE` rather than `In.Done = TRUE`. This appears
counter intuitive unless you keep in mind our loop stops when we having
nothing more to read, rather than when we can continue to read.
It `In.Done` means the read was successful and does not
mean "I'm done and can exit now". Likewise before writing out the character
we read, it is good practice to check the `In.Done` value. If `In.Done` is
TRUE, I know can safely display the character using `Out.Char(c);`.

~~~

MODULE CopyProg;
IMPORT In, Out;

PROCEDURE copy;
VAR
  c : CHAR;
BEGIN
  REPEAT
    In.Char(c);
    IF In.Done THEN
        Out.Char(c);
    END;
  UNTIL In.Done # TRUE;
END copy;

BEGIN
  copy();
END CopyProg.

~~~

#### Limitations

This program only works with standard input and output. A more generalized
version would work with named files.

### [1.2 Counting Characters](https://archive.org/details/softwaretoolsinp00kern/page/13/mode/1up)

~~~

PROGRAM

  charcount count characters in input

USAGE

  charcount

FUNCTION

  charcount counts the characters in its input and writes the total
  as a single line of text to the output. Since each line of text is
  internally delimited by a NEWLINE character, the total count is the
  number of lines plus the number of characters within each line.

EXAMPLE

  charcount
  A single line of input.
  <ENDFILE>
  24

~~~

[On page 13](https://archive.org/details/softwaretoolsinp00kern/page/13/mode/1up)
K & P introduces their second program, **charcount**. It is based on a single
procedure that reads from standard input and counts up the number of
characters encountered then writes the total number found to standard out
followed by a newline. In the text only the procedure is shown, it is
assumed you'll write the outer wrapper of the program yourself as
was done with the **copyprog** program. My Oberon-7 version is very similar
to the Pascal. Like in the our first "CopyProg" we will make use of the
"In" and "Out" modules. Since we will
need to write an INTEGER value we'll also use "Out.Int()" procedure which
is very similar to K & P's "putdec()". Aside from the counting this is very
simple  like our first program.

~~~

MODULE CharCount;
IMPORT In, Out;

PROCEDURE CharCount;
VAR
  nc : INTEGER;
  c : CHAR;
BEGIN
  nc := 0;

  REPEAT
    In.Char(c);
    IF In.Done THEN
      nc := nc + 1;
    END;
  UNTIL In.Done # TRUE;
  Out.Int(nc, 1);
  Out.Ln();
END CharCount;

BEGIN
  CharCount();
END CharCount.

~~~

#### Limitations

The primary limitation in counting characters is most readers are
interested in visible character count. In our implementation
even non-printed characters are counted. Like our first program
this only works on standard input and output. Ideally this should
be written so it works on any file including standard input and
output. If the reader implements that it could become part of a
package on statistical analysis of plain text files.

### [1.3 Counting Lines](https://archive.org/details/softwaretoolsinp00kern/page/14/mode/1up)

~~~

PROGRAM

  linecount count lines in input

USAGE

  linecount

FUNCTION

  linecount counts the lines in its input and write the total as a
  line of text to the output.

EXAMPLE

  linecount
  A single line of input.
  <ENDFILE>
  1

~~~

**linecount**, from [page 15](https://archive.org/details/softwaretoolsinp00kern/page/15/mode/1up)
is very similar to **charcount** except adding a
conditional count in the loop for processing the file. In
our Oberon-7 implementation we'll check if the `In.Char(c)`
call was successful but we'll add a second condition to see if the
character read was a NEWLINE. If it was I increment
our counter variable.

~~~

MODULE LineCount;
IMPORT In, Out;

PROCEDURE LineCount;
CONST
  NEWLINE = 10;

VAR
  nl : INTEGER;
  c : CHAR;
BEGIN
  nl := 0;
  REPEAT
    In.Char(c);
    IF In.Done & (ORD(c) = NEWLINE) THEN
      nl := nl + 1;
    END;
  UNTIL In.Done # TRUE;
  Out.Int(nl, 1);
  Out.Ln();
END LineCount;

BEGIN
  LineCount();
END LineCount.

~~~

#### Limitations

This program assumes that NEWLINE is ASCII value 10. Line delimiters
vary between operating systems.  If your OS used carriage returns
without a NEWLINE then this program would not count lines correctly.
The reader could extend the checking to support carriage returns,
new lines, and carriage return with new lines and cover most versions
of line endings.


### [1.4 Counting Words](https://archive.org/details/softwaretoolsinp00kern/page/14/mode/1up)

~~~

PROGRAM

  wordcount count words in input

USAGE

  wordcount

FUNCTION

  wordcount counts the words in its input and write the total as a
  line of text to the output. A "word" is a maximal sequence of characters
  not containing a blank or tab or newline.

EXAMPLE

  wordcount
  A single line of input.
  <ENDFILE>
  5

BUGS

  The definition of "word" is simplistic.

~~~

[Page 17](https://archive.org/details/softwaretoolsinp00kern/page/17/mode/1up)
brings us to the **wordcount** program. Counting words can be
very nuanced but here K & P have chosen a simple definition
which most of the time is "good enough" for languages like English.
A word is defined simply as an run of characters separated by
a space, tab or newline characters.  In practice most documents
will work with this minimal definition. It also makes the code
straight forward.  This is a good example of taking the simple
road if you can. It keeps this program short and sweet.

If you follow along in the K & P book note their rational
and choices in arriving at there solutions. There solutions
will often balance readability and clarity over machine efficiency.
While the code has progressed from "if then" to "if then else if"
logical sequence, the solution's modeled remains
clear. This means the person reading the source code can easily verify
if the approach chosen was too simple to meet their needs or it was
"good enough".

My Oberon-7 implementation is again very simple. Like in previous programs
I still have an outer check to see if the read worked (i.e. "In.Done = TRUE"),
otherwise the conditional logic is the same as the Pascal implementation.

~~~

MODULE WordCount;
IMPORT In, Out;

PROCEDURE WordCount;
CONST
  NEWLINE = 10;
  BLANK = 32;
  TAB = 9;

VAR
  nw : INTEGER;
  c : CHAR;
  inword : BOOLEAN;
BEGIN
  nw := 0;
  inword := FALSE;
  REPEAT
    In.Char(c);
    IF In.Done THEN
      IF ((ORD(c) = BLANK) OR (ORD(c) = NEWLINE) OR (ORD(c) = TAB)) THEN
        inword := FALSE;
      ELSIF (inword = FALSE) THEN
        inword := TRUE;
        nw := nw + 1;
      END;
    END;
  UNTIL In.Done # TRUE;
  Out.Int(nw, 1);
  Out.Ln();
END WordCount;

BEGIN
  WordCount();
END WordCount.

~~~

## [1.5 Removing Tabs](https://archive.org/details/softwaretoolsinp00kern/page/20/mode/1up)

~~~

PROGRAM

  detab convert tabs into blanks

USAGE

  detab

FUNCTION

  detab copies its input to its output, expanding the horizontal
  tabs to blanks along the way, so that the output is visually
  the same as the input, but contains no tab characters. Tab stops
  are assumed to be set every four columns (i.e. 1, 5, 9, ...), so
  each tab character is replaced by from one to four blanks.

EXAMPLE

  Usaing "->" as a visible tab:

  detab
  ->col 1->2->34->rest
      col 1   2   34  rest

BUGS

  detab is naive about backspaces, vertical motions, and
  non-printing characters.

~~~

The source code for "detab" can be found on
[page 24](https://archive.org/details/softwaretoolsinp00kern/page/24/mode/1up)
in the last section of chapter 1. **detab** removes
tabs and replaces them with spaces. Rather than a simple "tab"
replaced with four spaces **detab** preserves a concept found on
typewriters called "tab stops". In 1981 typewrites were still widely
used though word processing software would become common. Supporting the
"tab stop" model means the program works with what office workers would
expect from older tools like the typewriter or even the computer's
teletype machine. I think this shows an important aspect of writing
programs. Write the program for people, support existing common concepts
they will likely know.

K & P implementation includes separate source files
for setting tab stops and checking a tab stop.  The Pascal K & P
wrote for didn't support separate source files or program modules. Recent Pascal
versions did support the concept of modularization (e.g. UCSD Pascal). Since
and significant goal of K & P was portability they needed to come up
with a solution that worked on the "standard" Pascal compilers available on
minicomputers and mainframes and not write their solution to a specific
Pascal system like UCSD Pascal (see Appendix, "IMPLEMENTATION
PRIMITIVES [page 315](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/315/mode/1up)).
Modularization facilitates code reuse and like information hiding is an
import software technique. Unfortunately the preprocessor approach doesn't
support information hiding.

To facilitate code reuse the K & P book includes a preprocessor as part
of the Pascal development tools (see [page 71](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/71/mode/1up)
for implementation). The preprocessor written
in Pascal was based on the early versions of the "C" preprocessor
they had available in the early UNIX systems. Not terribly Pascal
like but it worked and allowed the two files to be shared between
this program and one in the next chapter.

Oberon-7 of course benefits from all of Wirth's language improvements
that came after Pascal. Oberon-7 supports modules and as such
there is no need for a preprocessor.  Because of Oberon-7's module
support I've implemented the Oberon version using two files
rather than three. My main program file is "Detab.Mod",
the supporting library module is "Tabs.Mod". "Tabs" is where I
define our tab stop data structure as well as the
procedures that operating on that data structure.

Let's look at the first part, "Detab.Mod". This is the module
that forms the program and it features an module level "BEGIN/END" block.
In that block I call "Detab();" which implements the program's functionality.
I import "In", "Out" as before but I also import "Tabs" which I will show next.
Like my previous examples I validate the read was successful before proceeding
with the logic presented in the original Pascal and deciding
what to write to standard output.

~~~

MODULE Detab;
  IMPORT In, Out, Tabs;

CONST
  NEWLINE = 10;
  TAB = 9;
  BLANK = 32;

PROCEDURE Detab;
VAR
  c : CHAR;
  col : INTEGER;
  tabstops : Tabs.TabType;
BEGIN
  Tabs.SetTabs(tabstops); (* set initial tab stops *)
  col := 1;
  REPEAT
    In.Char(c);
    IF In.Done THEN
      IF (ORD(c) = TAB) THEN
        REPEAT
          Out.Char(CHR(BLANK));
          col := col + 1;
        UNTIL Tabs.TabPos(col, tabstops);
      ELSIF (ORD(c) = NEWLINE) THEN
        Out.Char(c);
        col := 1;
      ELSE
        Out.Char(c);
        col := col + 1;
      END;
    END;
  UNTIL In.Done # TRUE;
END Detab;

BEGIN
  Detab();
END Detab.

~~~

Our second module is "Tabs.Mod". It provides the supporting procedures
and definition of the our "TabType" data structure. For us this
is the first time we write a module which "exports" procedures
and type definitions. If you are new to Oberon, expected constants,
variables and procedures names have a trailing "*". Otherwise the
Oberon compiler will assume a local use only. This is a very
powerful information hiding capability and what allows you to
evolve a modules' internal implementation independently of the
programs that rely on it.

~~~

MODULE Tabs;

CONST
  MAXLINE = 1000; (* or whatever *)

TYPE
  TabType* = ARRAY MAXLINE OF BOOLEAN;

(* TabPos -- return TRUE if col is a tab stop *)
PROCEDURE TabPos*(col : INTEGER; VAR tabstops : TabType) : BOOLEAN;
  VAR res : BOOLEAN;
BEGIN
  res := FALSE; (* Initialize our internal default return value *)
  IF (col >= MAXLINE) THEN
    res := TRUE;
  ELSE
    res := tabstops[col];
  END;
  RETURN res
END TabPos;

(* SetTabs -- set initial tab stops *)
PROCEDURE SetTabs*(VAR tabstops: TabType);
CONST
  TABSPACE = 4; (* 4 spaces per tab *)
VAR
  i : INTEGER;
BEGIN
  (* NOTE: Arrays in Oberon start at zero, we want to
     stop at the last cell *)
  FOR i := 0 TO (MAXLINE - 1) DO
    tabstops[i] := ((i MOD TABSPACE) = 0);
  END;
END SetTabs;

END Tabs.

~~~

NOTE: This module is used by "Detab.Mod" and "Entab.Mod"
and provides for common type definitions and code reuse.
We exported `TabType`, `TabPos` and `SetTabs`. Everything else
is private to this module.

## In closing

This post briefly highlighted ports of the programs
presented in Chapter 1 of "Software Tools in Pascal".
Below are links to my source files of the my
implementations inspired by the K & P book. Included
in each Oberon module source after the module definition
is transcribed text of the program documentation as well
as transcribed text of the K & P Pascal implementations.
Each file should compiler without modification using the
OBNC compiler.  By default the OBNC compiler will use the
module's name as the name of the executable version. I
I have used mixed case module names, if you prefer lower
case executable names use the "-o" option with the OBNC
compiler.

~~~

    obnc -o copy CopyProg.Mod
    obnc -o charcount CharCount.Mod
    obnc -o linecount LineCount.Mod
    obnc -o wordcount WordCount.Mod
    obnc -o detab Detab.Mod

~~~


+ [CopyProg](CopyProg.Mod)
+ [CharCount](CharCount.Mod)
+ [LineCount](LineCount.Mod)
+ [WordCount](WordCount.Mod)
+ [Detab](Detab.Mod)
    + [Tabs](Tabs.Mod), this one we'll revisit in next installment.


<!--

# Next

+ [Filters]()

-->
