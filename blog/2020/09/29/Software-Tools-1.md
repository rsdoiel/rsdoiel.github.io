{
    "markup": "mmark",
    "title": "Software Tools",
    "number": 1,
    "byline": "R. S. Doiel",
    "date": "2020-04-11",
    "copyright": "copyright (c) 2020, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}


# Software Tools, Chapter 1

## Overview

This is post starts a series revisiting the
programs described in the 1981 book by Brian W. Kernighan and
P. J. Plauger's called [Software Tools in Pascal](https://archive.org/details/softwaretoolsinp00kern).
The book is available from the [Open Library](https://openlibrary.org/)
and physical copies are still (2020) commonly available from used book 
sellers.  The book was an early text on creating portable command 
line programs.  Pascal was chosen as the implementation language 
because at the time Pascal was supplanting FORTRAN as the portable 
language of choice (an early version used a dialect of FORTRAN, 
"ratifier"). In 1981 [C](https://en.wikipedia.org/wiki/C_(programming_language)) was not ubiquitous.

In this series of posts I will present the K & P programs re-implemented in
Oberon-7 using Karl Landström's [OBNC](http://miasap.se/obnc/)
compiler[^langstrom].

[^langstrom]: OBNC compiler is the work of Karl Langström, it is portable across many systems where the C tool chain is available.

## Getting Started.

The opening chapter in the K & P book is about getting oriented to
developing in Pascal and starts off with some very simple
straight forward and useful examples. It introduces programs
which for the most part are included in standard POSIX compatible
systems (e.g. Linux, macOS, even Windows 10).

1. CopyProg, this is like "cat" in a POSIX system[^POSIX]
2. CharCount, this is like the "wc" POSIX command using the "-c" option
3. LineCount, this is like the "wc" POSIX command using the "-l" option
4. WordCount, this is like the "wc" POSIX command using the "-w" option
5. Detab, converts tabs to spaces using tab stops every four characters in a line

[^POSIX]: POSIX defines a standard of compatibility inspired by UNIX, see https://en.wikipedia.org/wiki/POSIX

### [1.1. File Copying](https://archive.org/details/softwaretoolsinp00kern/page/7/mode/1up)

The "copyprog.pas" is shown on [page 9](https://archive.org/details/softwaretoolsinp00kern/page/9/mode/1up).
It introduces both the copy procedure described in the preceding pages as
well as complete program. This "Copy" program functions like POSIX "cat"
without command line parameters.  It reads from standard input and writes
to standard out. The body of the pascal program invokes a procedure called
[copy](https://archive.org/details/softwaretoolsinp00kern/page/8/mode/1up)
this simply reads from standard in character by character and writes
to standard out character by character without modification.  Two
supporting procedures are introduced, "getc" and "putc". These are shown
in the complete program listing on page 9. They are repeatedly used
through out the book. One of the really good aspects of this simple
program is relying on the idea of standard input and output. This makes
"copyprog.pas" a simple filter and template for writing many of the programs
that follow. K & P provide a good explanation for this simple approach.

Our Oberon-7 version takes a similar approach. Our module looks remarkably
similar to the Pascal but is shorter because reading and writing characters are
provided for by Oberon's standard modules "In" and "Out".
I have chosen to use a "REPEAT/UNTIL" loop over the "WHILE" used
by K & P as we always try to read from standard in. One thing
to note in our "REPEAT/UNTIL" look is the terminating condition.
The value of `In.Done` is true on successful read and false
if you hit an end of file or the read failed for other reasons.
That means our loop must terminate on `In.Done # TRUE` rather than
`In.Done = TRUE`. This appears counter intuitive. It is important to
understand that `In.Done` meanings the read was successful and does not
mean "I'm done and can exit now". Likewise before writing out the character
just read I check the `In.Done` value and if TRUE, I know can display
the character using `Out.Char(c);`.

```oberon
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
```

#### Limitations

This program only works with standard input and output. A more generalized
version would work with named files.

### [1.2 Counting Characters](https://archive.org/details/softwaretoolsinp00kern/page/13/mode/1up)

[On page 13](https://archive.org/details/softwaretoolsinp00kern/page/13/mode/1up)
K & P introduce their second program, CharCount. It is based on a single
procedure that reads from standard input and counts up the number of
characters encountered then writes the total number found to standard out
followed by a newline. In the text only the procedure is shown, it is 
assumed you'll write the outer wrapper of the program yourself. The 
Oberon-7 version is very similar to the Pascal. Like in the our first 
"CopyProg" we will make use of the "In" and "Out" modules. Since we will 
need to write an INTEGER value we'll also use "Out.Int()" procedure which 
is very similar to K & P's "putdec()". Aside from the counting very simple like our first
program.

```oberon
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
```

#### Limitations

The obvious limitation is the naivete's in counting characters.
Even non-printed characters are counted. Like our first program
this only works on standard input and output. Ideally this should
be written so it works on any file including standard input and
output. If the reader implements that it could become part of a
package on statistical analysis of plain text files.

### [1.3 Counting Lines](https://archive.org/details/softwaretoolsinp00kern/page/14/mode/1up)

LineCount, from [page 15](https://archive.org/details/softwaretoolsinp00kern/page/15/mode/1up) is very similar to CharCount except adding an
conditional count in the loop for processing the file. In
our Oberon-7 implementation we'll check if the `In.Char(c)`
call was successful but we'll add a second condition to see if the
character read was a NEWLINE. Assuming it was we increment
our counter variable.

```oberon
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
```

#### Limitations

This program assumes that NEWLINE is ASCII value 10. Line delimiters
vary between operating systems.  If your OS used carriage returns
without a NEWLINE then this program would not count lines correctly.
The reader could extend the checking to support carriage returns,
new lines, and carriage return with new lines and cover most versions
of line endings.

### [1.4 Counting Words](https://archive.org/details/softwaretoolsinp00kern/page/14/mode/1up)

[Page 17](https://archive.org/details/softwaretoolsinp00kern/page/17/mode/1up) brings us to the WordCount program. Counting words can be
very nuanced but here K & P have chosen a simple definition
which most of the time is "good enough" for languages like English.
A word is defined simply as an run of characters separated by
a space, tab, newline characters.  In practice most documents
will work with this minimal definition. It also makes the code
straight forward.  This is a good example of taking the simple
road if you can. It keeps this program short and sweet.

If you follow along in the K & P book note their rationals
for the choices they make in choosing a simple solution.
While we do see an "if then else if" sequence is remains
clear what the program assumption are. This means the person
reading the source code can easily verify if the approach
chosen was too simple to meet their needs.

Our Oberon-7 implementation is again very simple like the Pascal.
Like in previous programs we still have an outer check to see
if the read worked (i.e. "In.Done = TRUE"), otherwise the
conditional logic is the same.

```oberon
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
```

## [1.5 Removing Tabs](https://archive.org/details/softwaretoolsinp00kern/page/20/mode/1up)

The source code for "detab" can be found in [page 24](https://archive.org/details/softwaretoolsinp00kern/page/24/mode/1up) in the last section
of chapter 1. The "detab" program that removes
tabs and replaces them with spaces. Rather than a simple "tab"
replaced with four spaces, this "detab" preserves the idea of
tab stops. In 1981 typewrites were still widely used though
word processing software would replacement. I think this shows
an important aspect of writing programs. Most humans of the time
who worked in offices preparing documents assumed the type writer
or even the computer interface version, the teletype, was the model's
assumptions. K & P implementation includes separate source files
for setting tab stops and checking for a tab stop.  The Pascal they
used don't support separate program modules in the way later Pascal
versions would (e.g. UCSD Pascal and Turbo Pascal). Modularization
and code reuse are import software techniques. To allow reuse
the K & P book included a preprocessor for their programs
that support including files inline. This preprocessor written
in Pascal was based on the early versions of the "C" preprocessor
they had available in the early UNIX systems. Not terribly Pascal
line but it worked and allowed the two files to be shared between
this program and the one in the next chapter.

Oberon-7 of course benefits from all the language improvements that
came before. Oberon-7 supports modules and as such their is no need
for a preprocessor.  Rather than have three files to build our
program well have two, One will be "Detab.Mod" and the other will
be "Tabs.Mod". The latter one will allow for code reuse and be the
place where we define our tab stop data structure as well as the
procedures that operating on that data structure.

Let's look at the first part, "Detab.Mod". This is the module
that forms our program by calling "Detab();" procedure in the
module's own "BEGIN/END" block.  We import "In", "Out" as before
but we also import "Tabs" which we will show next. Like our
previous examples we validate we had a successful read before
testing the character and making decisions about what to write
to standard out.

```oberon
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
```

Our second module is "Tabs.Mod" provides the supporting procedures
and definition of the our "TabType" data structure. For us this
is the first time we write a module which "exports" procedures
and type definitions. If you are new to Oberon, expected constants,
variables and procedures names have a trailing "*". Otherwise the
Oberon compiler will assume a local use only. This is a very
powerful information hiding capability and what allows you to
evolve a modules' internal implementation independently of the
programs that rely on it.

```oberon
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
  IF (col > MAXLINE) THEN
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
      tabstops[i] := (i MOD TABSPACE = 1);
    END;
END SetTabs;

END Tabs.
```

NOTE: This module is used by Detab.Mod and Entab.Mod
and provides for common type definitions and code reuse.
We exported TabType, TabPos and SetTabs. Everything else
is private to this module.

## In closing

This post briefly highlighted ports of the programs
presented in Chapter 1 of "Software Tools in Pascal".
I have included links below for the source files
of my implementation of the K & P tools. One of the
nice features of Oberon is that any text after the
closing "END *." statement is ignore by
the compiler. In these source files I've transcribed
the documentation examples in the K & P text as well
as the Pascal shown in the chapter. In this way you
can compare implementations easily and see what has
changed between the languages.

+ [CopyProg](CopyProg.Mod)
+ [CharCount](CharCount.Mod)
+ [LineCount](LineCount.Mod)
+ [WordCount](WordCount.Mod)
+ [Detab](Detab.Mod)
    + [Tabs](Tabs.Mod), this one we'll revisit in next installment.

