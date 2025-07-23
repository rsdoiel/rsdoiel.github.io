---
title: 'Software Tools, Filters'
series: Software Tools
number: 2
author: rsdoiel@gmail.com (R. S. Doiel)
keywords:
  - Oberon
  - Pascal
  - Programming
copyright: 'copyright (c) 2020, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2020
copyrightHolder: R. S. Doiel
abstract: >
  This post is the second in a series revisiting the programs
  described in the 1981 book by Brian W. Kernighan and P. J.

  Plauger's called [Software Tools in
  Pascal](https://archive.org/details/softwaretoolsinp00kern). The book is
  available from the

  [Open Library](https://openlibrary.org/) and physical copies
  are still (2020) commonly available from used book sellers.
  The book was an late 20th century text on creating portable
  command line programs using ISO standard Pascal of the era.
  
  ...

dateCreated: '2020-10-31'
dateModified: '2025-07-22'
datePublished: '2020-10-31'
seriesNo: 2
---

Software Tools, Filters
=======================

Overview
--------

This post is the second in a series revisiting the programs
described in the 1981 book by Brian W. Kernighan and P. J.
Plauger's called [Software Tools in Pascal](https://archive.org/details/softwaretoolsinp00kern). The book is available from the
[Open Library](https://openlibrary.org/) and physical copies
are still (2020) commonly available from used book sellers.
The book was an late 20th century text on creating portable
command line programs using ISO standard Pascal of the era.

In this chapter K & P focuses on developing the idea of filters.
Filters are programs which typically process standard input, do
some sort of transformation or calculation and write to standard
output.  They are intended to work either standalone or in a pipeline
to solve more complex problems. I like to think of filters as
software [LEGO](https://en.wikipedia.org/wiki/Lego).
Filter programs can be "snapped" together creating simple shapes
data shapes or combined to for complex compositions.

The programs from this chapter include:

+ **entab**, respecting tabstops, convert strings of spaces to tabs
+ **overstrike**, this is probably not useful anymore, it would allow "overstriking" characters on devices that supported it. From [wikipedia](https://en.wikipedia.org/wiki/Overstrike), "In typography, overstrike is a method of printing characters that are missing from the printer's character set. The character was created by placing one character on another one — for example, overstriking "L" with "-" resulted in printing a "Ł" (L with stroke) character."
+ **compress**, an early UNIX style compress for plain text files
+ **expand**, an early UNIX style expand for plain text files, previously run through with **compress**
+ **echo**, write echo's command line parameters to standard output, introduces working with command line parameters
+ **translit**, transliterate characters using a simple from/to substitution with a simple notation to describe character sequences and negation. My implementation diverges from K & P

Implementing in Oberon-07
------------------------

With the exception of **echo** (used to introduce command line parameter processing) each program increases in complexity.  The last program **translit**is the most complex in this chapter.  It introducing what we a "domain specific language" or "DSL".  A DSL is a notation allowing us to describe something implicitly rather than explicitly. All the programs except **translit** follow closely the original Pascal translated to Oberon-07.  **translit** book implementation is very much a result of the constraints of Pascal of the early 1980s as well as the minimalist assumption that could be made about the host operating system. I will focus on revising that program in particular bring the code up to current practice as well as offering insights I've learned.


The program **translit** introduces what is called a "Domain Specific Language".Domain specific languages or DSL for short are often simple notations to describe how to solve vary narrow problems.  If you've used any of the popular spreadsheet programs where you've entered a formula to compute something you've used a domain specific language.  If you've ever search for text in a document using a regular expression you've used a domain specific language.  By focusing a notation on a small problem space you can often come up with simple ways of expressing or composing programmatic solutions to get a job done.

In **translit** the notation let's us describe what we want to translate. At the simplest level the **translit** program takes a character and replaces it with another character. What make increases **translit** utility is that it can take a set of characters and replace it with another.  If you want to change all lower cases letters and replace them with uppercase letters. This "from set" and "to set" are easy to describe as two ranges, "a" to "z" and "A" to "Z".  Our domain notation allows us to express this as "a-z" and "A-Z".  K & P include several of features in there notation including characters to exclude from a translation as well as an "escape notation" for describing characters like new lines, tabs, or the characters that describe a range and exclusion (i.e. dash and caret).



2.1 Putting Tabs Back
=====================

[Page 31](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/31/mode/1up)

Implementing **entab** in Oberon-07 is straight forward.
Like my [Detab](Detab.Mod) implementation I am using
a second modules called [Tabs](Tabs.Mod). This removes
the need for the `#include` macros used in the K & P version.
I have used the same loop structure as K & P this time.
There is a difference in my `WHILE` loop. I separate the
character read from the `WHILE` conditional test.  Combining the
two is common in "C" and is consistent with the programming style
other books by Kernighan.  In Oberon-07 doesn't make sense at all.
Oberon's `In.Char()` is not a function returning as in the Pascal
primitives implemented for the K & P book or indeed like in the "C"
language. In Oberon's "In" module the status of a read operation is
exposed by `In.Done`. I've chosen to put the next call to
`In.Char()` at the bottom of my `WHILE` loop because it is clear
that it is the last think done before ether iterating again or
exiting the loop. Other than that the Oberon version looks much
like K & P's Pascal.


Program Documentation
---------------------

[Page 32](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/32/mode/1up)


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

  entab	convert runs of blanks into tabs

USAGE

  entab

FUNCTION

  entab copies its input to its output, replacing strings of
  blanks by tabs so the output is visually the same as the
  input, but contains fewer characters. Tab stops are assumed
  to be set every four columns (i.e. 1, 5, 9, ...), so that
  each sequence of one to four blanks ending on a tab stop
  is replaced by a tab character

EXAMPLE

  Using -> as visible tab:

    entab
      col  1   2   34  rest
    ->col->1->2->34->rest

BUGS

  entab is naive about backspaces, virtical motions, and
  non-printing characters. entab will convert  a single blank
  to a tab if it occurs at a tab stop. The entab is not an
  exact inverse of detab.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Source code for **Entab.Mod**
-----------------------------

~~~

MODULE Entab;
  IMPORT In, Out, Tabs;

CONST
  NEWLINE = 10;
  TAB = 9;
  BLANK = 32;

PROCEDURE Entab();
VAR
  c : CHAR;
  col, newcol : INTEGER;
  tabstops : Tabs.TabType;
BEGIN
  Tabs.SetTabs(tabstops);
  col := 1;
  REPEAT
    newcol := col;
    In.Char(c);
    IF In.Done THEN (* NOTE: We check that the read was successful! *)
      WHILE (ORD(c) = BLANK) DO
        newcol := newcol + 1;
        IF (Tabs.TabPos(newcol, tabstops)) THEN
          Out.Char(CHR(TAB));
          col := newcol;
        END;
        (* NOTE: Get the next char, check the loop condition
           and either iterate or exit the loop *)
        In.Char(c);
      END;
      WHILE (col < newcol) DO
        Out.Char(CHR(BLANK)); (* output left over blanks *)
        col := col + 1;
      END;
      (* NOTE: Since we may have gotten a new char in the first WHILE
         we need to check again if the read was successful *)
      IF In.Done THEN
        Out.Char(c);
        IF (ORD(c) = NEWLINE) THEN
          col := 1;
        ELSE
          col := col + 1;
        END;
      END;
    END;
  UNTIL In.Done # TRUE;
END Entab;

BEGIN
  Entab();
END Entab.

~~~



2.2 Overstrikes
===============


[Page 34](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/34/mode/1up)


Overstrike isn't a tool that is useful today but I've included it
simply to be follow along the flow of the K & P book. It very much
reflects an error where teletype like devices where still common and
printers printed much like typewriters did. On a 20th century
manual type writer you could underline a word or letter by backing
up the carriage then typing the underscore character. Striking out
a word was accomplished by a similar technique. The mid to late
20th century computers device retained this mechanism though by
1980's it was beginning to disappear along with manual typewriters.
This program relies on the the nature of ASCII character set and
reflects some of the non-print character's functionality. I
found it did not work on today's terminal emulators reliably. Your
mileage may very nor do I have a vintage printer to test it on.

Our module follows K & P design almost verbatim. The differences
are those suggested by differences between Pascal and Oberon-07.
Like in previous examples we don't need to use an ENDFILE constant
as we can simply check the value of `In.Done` to determine
if the last read was successful. This simplifies some of
the `IF/ELSE` logic and the termination of the `REPEAT/UNTIL`
loop.  It makes the `WHILE/DO` loop a little more verbose.

One thing I would like to point out in the original Pascal of the
book is a problem often referred to as the "dangling else" problem.
While this is usually discussed in the context of compiler
implementation I feel like it is a bigger issue for the person
reading the source code. It is particularly problematic when you
have complex "IF/ELSE" sequences that are nested.  This is not
limited to the 1980's era Pascal. You see it in other languages
like C.  It is a convenience for the person typing the source code
but a problem for those who maintain it. We see this ambiguity in
the Pascal procedure **overstrike** inside the repeat loop
on [page 35](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/35/mode/1up).
It is made worse by the fact that K & P have taken advantage of
omitting the semi-colons where optional. If you type in this
procedure and remove the indication if quickly becomes ambiguous
about where on "IF/ELSE" begins and the next ends. In Oberon-07 it
is clear when you have a dangling "IF" statement. This vintage
Pascal, not so much.

K & P do mention the dangling "ELSE" problem later in the text.
Their recommend practice was include the explicit final "ELSE"
at a comment to avoid confusion. But you can see how easy an
omitting the comment is in the **overstrike** program.

Limitations
-----------

This is documented "BUG" section describes the limitations
well, "**overstrike** is naive about vertical motions and non-
printing characters. It produces one over struck line for each
sequence of backspaces". But in addition to that most printing
devices these days either have their own drivers or expect to work
with a standard like Postscript. This limited the usefulness of
this program today though controlling character movement in a
"vt100" emulation using old fashion ASCII control codes is
still interesting if only for historical reasons.


Program Documentation
---------------------

[Page 36](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/36/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

  overstrike    replace overstrikes by multiple-lines

USAGE

  overstrike

FUNCTION

  overstrike copies in input to its output, replacing lines
  containing backspaces by multiple lines that overstrike
  to print the same as input, but containing no backspaces.
  It is assumed that the output is to be printed on a device
  that takes the first character of each line as a carriage
  control; a blank carriage control causes normal space before
  print, while a plus sign '+' suppresses space before print
  and hence causes the remainder of the line to overstrike
  the previous line.

EXAMPLE

  Using <- as a visible backspace:

    overstrike
    abc<-<-<-___
     abc
    +___

BUGS

  overstrike is naive about vertical motions and non-printing
  characters. It produces one over struck line for each sequence
  of backspaces.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Source code for **Overstrike.Mod**
----------------------------------

~~~

MODULE Overstrike;
IMPORT In, Out;

CONST
  NEWLINE = 10;
  BLANK = 32;
  PLUS = 43;
  BACKSPACE = 8;

PROCEDURE Max(x, y : INTEGER) : INTEGER;
VAR max : INTEGER;
BEGIN
  IF (x > y) THEN
    max := x
  ELSE
    max := y
  END;
  RETURN max
END Max;

PROCEDURE Overstrike;
CONST
  SKIP = BLANK;
  NOSKIP = PLUS;
VAR
  c : CHAR;
  col, newcol, i : INTEGER;
BEGIN
  col := 1;
  REPEAT
    newcol := col;
    In.Char(c);
    (* NOTE We check In.Done on each loop evalution *)
    WHILE (In.Done = TRUE) & (ORD(c) = BACKSPACE) DO (* eat the backspaces *)
      newcol := Max(newcol, 1);
      In.Char(c);
    END;
    (* NOTE: We check In.Done again, since we may have
       additional reads when eating the backspaces. If
       the previous while loop has taken us to the end of file.
       this will be also mean In.Done = FALSE. *)
    IF In.Done THEN
      IF (newcol < col) THEN
        Out.Char(CHR(NEWLINE)); (* start overstrike line *)
        Out.Char(CHR(NOSKIP));
        FOR i := 0 TO newcol DO
          Out.Char(CHR(BLANK));
        END;
        col := newcol;
      ELSIF (col = 1) THEN (* NOTE: In.Done already check for end of file *)
        Out.Char(CHR(SKIP)); (* normal line *)
      END;
      (* NOTE: In.Done already was checked so we are in mid line *)
      Out.Char(c);    (* normal character *)
      IF (ORD(c) = NEWLINE) THEN
        col := 1
      ELSE
        col := col + 1
      END;
    END;
  UNTIL In.Done # TRUE;
END Overstrike;

BEGIN
  Overstrike();
END Overstrike.

~~~


2.3 Text Compression
====================

[Page 37](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/37/mode/1up)

In 20th century computing everything is expensive, memory,
persistent storage computational ability in CPU.  If you were
primarily working with text you still worried about running out of
space in your storage medium. You see it in the units
of measurement used in that era such as bytes, kilobytes, hertz and
kilohertz. To day we talk about megabytes, gigabytes, terabytes and
petabytes. Plain text files are a tiny size compared to must
digital objects today but in the late 20th century
their size in storage was still a concern.  One way to solve this
problem was to encode your plain text to use less storage space.
Early attempts at file compression took advantage of repetition to
save space. Many text documents have repeated characters
whether spaces or punctuation or other formatting. This is what
inspired the K & P implementation of **compress** and **expand**.
Today we'd use other approaches to save space whether we were
storing text or a digital photograph.


Program Documentation
---------------------

[Page ](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/40/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

    compress    compress input by encoding repeated characters

USAGE

    compress

FUNCTION

    compress copies its input to its output, replacing strings
    of four or more identical characters by a code sequence so
    that the output generally contains fewer characters than the
    input. A run of x's is encoded as -nx, where the count n is
    a character: 'A' calls for a repetition of one x, 'B' a
    repetition of two x's, and so on. Runs longer than 26 are
    broken into several shorter ones. Runs of -'s of any length
    are encoded.

EXAMPLE

    compress
    Item     Name           Value
    Item-D Name-I Value
    1       car             -$7,000.00
    1-G car-J -A-$7,000.00
    <ENDFILE>

BUGS

    The implementation assumes 26 legal characters beginning with A.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Source code for **Compress.Mod**
--------------------------------

~~~

MODULE Compress;
IMPORT In, Out;

CONST
    TILDE = "~";
    WARNING = TILDE;    (* ~ *)

(* Min -- compute minimum of two integers *)
PROCEDURE Min(x, y : INTEGER) : INTEGER;
VAR min : INTEGER;
BEGIN
    IF (x < y) THEN
        min := x
    ELSE
        min := y
    END;
    RETURN min
END Min;

(* PutRep -- put out representation of run of n 'c's *)
PROCEDURE PutRep (n : INTEGER; c : CHAR);
CONST
    MAXREP = 26;    (* assuming 'A' .. 'Z' *)
    THRESH = 4;
VAR i : INTEGER;
BEGIN
    WHILE (n >= THRESH) OR ((c = WARNING) & (n > 0)) DO
        Out.Char(WARNING);
        Out.Char(CHR((Min(n, MAXREP) - 1) + ORD("A")));
        Out.Char(c);
        n := n - MAXREP;
    END;
    FOR i := n TO 1 BY (-1) DO
        Out.Char(c);
    END;
END PutRep;

(* Compress -- compress standard input *)
PROCEDURE Compress();
VAR
    c, lastc : CHAR;
    n : INTEGER;
BEGIN
    n := 1;
    In.Char(lastc);
    WHILE (In.Done = TRUE) DO
        In.Char(c);
        IF (In.Done = FALSE) THEN
            IF (n > 1) OR (lastc = WARNING) THEN
                PutRep(n, lastc)
            ELSE
                Out.Char(lastc);
            END;
        ELSIF (c = lastc) THEN
            n := n + 1
        ELSIF (n > 1) OR (lastc = WARNING) THEN
            PutRep(n, lastc);
            n := 1
        ELSE
            Out.Char(lastc);
        END;
        lastc := c;
    END;
END Compress;


BEGIN
    Compress();
END Compress.

~~~



2.4 Text Expansion
==================

[Page 41](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/41/mode/1up)

Our procedures map closely to the original Pascal with a few
significant differences.  As previously I've chosen a
`REPEAT ... UNTIL` loop structure because we are always attempting
to read at least once. The `IF THEN ELSIF ELSE` logic is a little
different. In the K & P version they combine retrieving
a character and testing its value.  This is a style common in
languages like C. As previous mentioned I split the read of the
character from the test.  Aside from the choices imposed by the
"In" module I also feel that retrieving the value, then testing is
a simpler statement to read. There is little need to worry about a
side effect when you separate the action from the test. It does
change the structure of the inner and outer `IF` statements.



Program Documentation
---------------------

[Page 43](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/43/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

    expand  expand compressed input

USAGE

    expand

FUNCTION

    expand copies its input, which has presumably been encoded by
    compress, to its output, replacing code sequences -nc by the
    repeated characters they stand for so that the text output
    exactly matches that which was originally encoded. The
    occurrence of the warning character - in the input means that
    which was originally encoded. The occurrence of the warning
    character - in the input means that the next character is a
    repetition count; 'A' calls for one instance of the following
    character, 'B' calls for two, and so on up to 'Z'.

EXAMPLE

    expand
    Item~D Name~I Value
    Item    Name        Value
    1~G car~J ~A~$7,000.00
    1       car         -$7,000.00
    <ENDFILE>

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Source code for **Expand.Mod**
------------------------------

~~~
MODULE Expand;
IMPORT In, Out;

CONST
    TILDE = "~";
    WARNING = TILDE;    (* ~ *)
    LetterA = ORD("A");
    LetterZ = ORD("Z");

(* IsUpper -- true if c is upper case letter *)
PROCEDURE IsUpper (c : CHAR) : BOOLEAN;
VAR res : BOOLEAN;
BEGIN
    IF (ORD(c) >= LetterA) & (ORD(c) <= LetterZ) THEN
        res := TRUE;
    ELSE
        res := FALSE;
    END
    RETURN res
END IsUpper;

(* Expand -- uncompress standard input *)
PROCEDURE Expand();
VAR
    c : CHAR;
    n, i : INTEGER;
BEGIN
    REPEAT
        In.Char(c);
        IF (c # WARNING) THEN
            Out.Char(c);
        ELSE
            In.Char(c);
            IF IsUpper(c) THEN
                n := (ORD(c) - ORD("A")) + 1;
                In.Char(c);
                IF (In.Done) THEN
                    FOR i := n TO 1 BY -1 DO
                        Out.Char(c);
                    END;
                ELSE
                    Out.Char(WARNING);
                    Out.Char(CHR((n - 1) + ORD("A")));
                END;
            ELSE
                Out.Char(WARNING);
                IF In.Done THEN
                    Out.Char(c);
                END;
            END;
        END;
    UNTIL In.Done # TRUE;
END Expand;

BEGIN
    Expand();
END Expand.

~~~


2.5 Command Arguments
=====================

[Page 44](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/44/mode/1up)


Program Documentation
---------------------

[Page 45](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/45/mode/1up)


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

    echo    echo arguments to standard output

USAGE

    echo [ argument ... ]

FUNCTION

    echo copies its command line arguments to its output as a line
    of text with one space
    between each argument. IF there are no arguments, no output is
    produced.

EXAMPLE

    To see if your system is alive:

        echo hello world!
        hello world!

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Source code for **Echo.Mod**
----------------------------

~~~

MODULE Echo;
IMPORT Out, Args := extArgs;

CONST
    MAXSTR = 1024; (* or whatever *)
    BLANK = " ";

(* Echo -- echo command line arguments to output *)
PROCEDURE Echo();
VAR
    i, res : INTEGER;
    argstr : ARRAY MAXSTR OF CHAR;
BEGIN
    i := 0;
    FOR i := 0 TO (Args.count - 1) DO
        Args.Get(i, argstr, res);
        IF (i > 0) THEN
            Out.Char(BLANK);
        END;
        Out.String(argstr);
    END;
    IF Args.count > 0 THEN
        Out.Ln();
    END;
END Echo;

BEGIN
    Echo();
END Echo.

~~~


2.6 Character Transliteration
=============================

[Page 47](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/47/mode/1up)


**translit** is the most complicated program so far in the book.
Most of the translation process from Pascal to Oberon-07 has
remained similar to the previous examples.

My implementation of **translit** diverges from the K & P
implementation at several points. Much of this is a result of
Oberon evolution beyond Pascal. First Oberon counts arrays from
zero instead of one so I have opted to use -1 as a value to
indicate the index of a character in a string was not found.
Equally I have simplified the logic in `xindex()` to make it clear
how I am handling the index lookup described in `index()` of the
Pascal implementation. K & P implemented `makeset()` and `dodash()`.
`dodash()` particularly looked troublesome. If you came across the
function name `dodash()` without seeing the code comments
"doing a dash" seems a little obscure.  I have chosen to name
that process "Expand Sequence" for clarity. I have simplified the
task of making sets of characters for translation into three cases
by splitting the test conditions from the actions. First check to
see if we have an escape sequence and if so handle it. Second check
to see if we have an expansion sequence and if so handle it else
append the char found to the end of the set being assembled. This
resulted in `dodash()` being replaced by `IsSequence()` and
`ExpandSequence()`.  Likewise `esc()` was replaced with `IsEscape()`
and `ExpandEscape()`. I renamed `addchar()` to `AppendChar()`
in the "Chars" module as that seemed more specific and clearer.

I choose to advance the value used when expanding a set description
in the loop inside of my `MakeSet()`. I minimized the side effects
of the expand functions to the target destination.  It is clearer
while in the `MakeSet()` loop to see the relationship of the test
and transformation and how to advance through the string. This also
allowed me to use fewer parameters to procedures which tends to
make things more readable as well as simpler.

I have included an additional procedure not included in the K & P
Pascal of this program. `Error()` displays a string and halts.
K & P provide this as part of their Pascal environment. I have
chosen to embed it here because it is short and trivial.

Translit suggested the "Chars" module because of the repetition in
previous programs. In K & P the approach to code reuse is to create
a separate source file and to included via a pre-processor. In
Oberon we have the module concept.

My [Chars](Chars.Mod) module provides a useful set of test
procedures like `IsAlpha(c)`, `IsUpper(c)`, `IsLower()` in addition
to the `CharInRange()` and `IsAlphaNum()`.  It also includes
`AppendChar()` which can be used to append a single character value
to an end of an array of char.


Program Documentation
---------------------

[Page 56](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/56/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

    translit    transliterate characters

USAGE

    translit    [^]src [dest]

FUNCTION

    translit maps its input, on a character by character basis, and
    writes the translated version to its output.In the simplest case,
    each character is the argument src is translated to the
    corresponding character is the argument dest; all other characters
    are copies as is. Both the src and dest may contain substrings of
    the form c1 - c2 as shorthand for all the characters in the range
    c1..c2 and c2 must both be digits, or both be letter of the same
    case. If dest is absent, all characters represented by src are
    deleted. Otherwise, if dest is shorter than src, all characters
    is src that would map to or beyond the last character in
    dest are mapped to the last character in dest; moreover adjacent
    instances of such characters in the input are represented in the
    output by a single instance of the last character in dest. The

        translit 0-9 9

    converts each string of digits to the single digit 9.
    Finally, if src is precedded by ^, then all but the characters
    represented by src are taken as the source string; i.e., they are
    all deleted if dest is absent, or they are all collapsed if the
    last character in dest is present.

EXAMPLE

    To convert upper case to lower:

        translit A-Z a-z

    To discard punctualtion and isolate words by spaces on each line:

        translit ^a-zA-Z@n " "
        This is a simple-minded test, i.e., a test of translit.
        This is a simple minded test i e a test of translit

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pascal Source
-------------

[translit.p, Page 48](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/48/mode/1up)

[makeset.p, Page 52](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/52/mode/2up)


[addstr.p, Page 53](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/53/mode/1up)

[dodash.p, Page 53](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/53/mode/1up)

[isalphanum.p, Page 54](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/54/mode/1up)

[esc.p, Page 55](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/55/mode/1up)


[length.p, Page 46](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/46/mode/1up)


The impacts of having a richer language than 1980s ISO Pascal and
evolution in practice suggest a revision in the K & P approach. I
have attempted to keep the spirit of their example program while
reflecting changes in practice that have occurred in the last four
decades.


Source code for **Translit.Mod**
--------------------------------

~~~
MODULE Translit;
IMPORT In, Out, Args := extArgs, Strings, Chars;

CONST
    MAXSTR = 1024; (* or whatever *)
    DASH = Chars.DASH;
    ENDSTR = Chars.ENDSTR;
    ESCAPE = "@";
    TAB* = Chars.TAB;

(* Error -- write an error string to standard out and
   halt program *)
PROCEDURE Error(s : ARRAY OF CHAR);
BEGIN
    Out.String(s);Out.Ln();
    ASSERT(FALSE);
END Error;

(* IsEscape - this procedure looks to see if we have an
escape sequence at position in variable i *)
PROCEDURE IsEscape*(src : ARRAY OF CHAR; i : INTEGER) : BOOLEAN;
VAR res : BOOLEAN; last : INTEGER;
BEGIN
  res := FALSE;
  last := Strings.Length(src) - 1;
  IF (i < last) & (src[i] = ESCAPE) THEN
    res := TRUE;
  END;
  RETURN res
END IsEscape;

(* ExpandEscape - this procedure takes a source array, a
   position and appends the escaped value to the destintation
   array.  It returns TRUE on successuss, FALSE otherwise. *)
PROCEDURE ExpandEscape*(src : ARRAY OF CHAR; i : INTEGER; VAR dest : ARRAY OF CHAR) : BOOLEAN;
VAR res : BOOLEAN; j : INTEGER;
BEGIN
 res := FALSE;
 j := i + 1;
 IF j < Strings.Length(src)  THEN
    res := Chars.AppendChar(src[j], dest)
 END
 RETURN res
END ExpandEscape;

(* IsSequence - this procedure looks at position i and checks
   to see if we have a sequence to expand *)
PROCEDURE IsSequence*(src : ARRAY OF CHAR; i : INTEGER) : BOOLEAN;
VAR res : BOOLEAN;
BEGIN
  res := Strings.Length(src) - i >= 3;
  (* Do we have a sequence of alphumeric character
     DASH alpanumeric character? *)
  IF res & Chars.IsAlphaNum(src[i]) & (src[i+1] = DASH) &
            Chars.IsAlphaNum(src[i+2]) THEN
      res := TRUE;
  END;
  RETURN res
END IsSequence;

(* ExpandSequence - this procedure expands a sequence x
   starting at i and append the sequence into the destination
   string. It returns TRUE on success, FALSE otherwise *)
PROCEDURE ExpandSequence*(src : ARRAY OF CHAR; i : INTEGER; VAR dest : ARRAY OF CHAR) : BOOLEAN;
VAR res : BOOLEAN; cur, start, end : INTEGER;
BEGIN
  (* Make sure sequence is assending *)
  res := TRUE;
  start := ORD(src[i]);
  end := ORD(src[i+2]);
  IF start < end THEN
    FOR cur := start TO end DO
      IF res THEN
        res := Chars.AppendChar(CHR(cur), dest);
      END;
    END;
  ELSE
    res := FALSE;
  END;
  RETURN res
END ExpandSequence;


(* makeset -- make sets based on src expanded into destination *)
PROCEDURE MakeSet* (src : ARRAY OF CHAR; start : INTEGER; VAR dest : ARRAY OF CHAR) : BOOLEAN;
VAR i : INTEGER; makeset : BOOLEAN;
BEGIN
    i := start;
    makeset := TRUE;
    WHILE (makeset = TRUE) & (i < Strings.Length(src)) DO
        IF IsEscape(src, i) THEN
            makeset := ExpandEscape(src, i, dest);
            i := i + 2;
        ELSIF IsSequence(src, i) THEN
            makeset := ExpandSequence(src, i, dest);
            i := i + 3;
        ELSE
            makeset := Chars.AppendChar(src[i], dest);
            i := i + 1;
        END;
    END;
    RETURN makeset
END MakeSet;


(* Index -- find position of character c in string s *)
PROCEDURE Index* (VAR s : ARRAY OF CHAR; c : CHAR) : INTEGER;
VAR
    i, index : INTEGER;
BEGIN
    i := 0;
    WHILE (s[i] # c) & (s[i] # ENDSTR) DO
        i := i + 1;
    END;
    IF (s[i] = ENDSTR) THEN
        index := -1; (* Value not found *)
    ELSE
        index := i; (* Value found *)
    END;
    RETURN index
END Index;

(* XIndex -- conditionally invert value found in index *)
PROCEDURE XIndex* (VAR inset : ARRAY OF CHAR; c : CHAR;
    allbut : BOOLEAN; lastto : INTEGER) : INTEGER;
VAR
    xindex : INTEGER;
BEGIN
    (* Uninverted index value *)
    xindex := Index(inset, c);
    (* Handle inverted index value *)
    IF (allbut = TRUE) THEN
        IF (xindex = -1)  THEN
            (* Translate as an inverted the response *)
            xindex := 0; (* lastto - 1; *)
        ELSE
            (* Indicate no translate *)
            xindex := -1;
        END;
    END;
    RETURN xindex
END XIndex;

(* Translit -- map characters *)
PROCEDURE Translit* ();
CONST
    NEGATE = Chars.CARET; (* ^ *)
VAR
    arg, fromset, toset : ARRAY MAXSTR OF CHAR;
    c : CHAR;
    i, lastto : INTEGER;
    allbut, squash : BOOLEAN;
    res : INTEGER;
BEGIN
    i := 0;
    lastto := MAXSTR - 1;
    (* NOTE: We are doing low level of string manimulation. Oberon
       strings are terminated by 0X, but Oberon compilers do not
       automatically initialize memory to a specific state. In the
       OBNC implementation of Oberon-07 assign "" to an assignment
       like `s := "";` only writes a 0X to position zero of the
       array of char. Since we are doing position based character
       assignment and can easily overwrite a single 0X.  To be safe
       we want to assign all the positions in the array to 0X so the
       memory is in a known state.  *)
    Chars.Clear(arg);
    Chars.Clear(fromset);
    Chars.Clear(toset);
    IF (Args.count = 0) THEN
        Error("usage: translit from to");
    END;
    (* NOTE: I have not used an IF ELSE here because we have
       additional conditions that lead to complex logic.  The
       procedure Error() calls ASSERT(FALSE); which in Oberon-07
       halts the program from further execution *)
    IF (Args.count > 0) THEN
        Args.Get(0, arg, res);
        allbut := (arg[0] = NEGATE);
        IF (allbut) THEN
            i := 1;
        ELSE
            i := 0;
        END;
        IF MakeSet(arg, i, fromset) = FALSE THEN
            Error("from set too long");
        END;
    END;
    (* NOTE: We have initialized our array of char earlier so we only
       need to know if we need to update toset to a new value *)
    Chars.Clear(arg);
    IF (Args.count = 2) THEN
        Args.Get(1, arg, res);
        IF MakeSet(arg, 0, toset) = FALSE THEN
            Error("to set too long");
        END;
    END;

    lastto := Strings.Length(toset);
    squash := (Strings.Length(fromset) > lastto) OR (allbut);
    REPEAT
        In.Char(c);
        IF In.Done THEN
            i := XIndex(fromset, c, allbut, lastto);
            IF (squash) & (i>=lastto) & (lastto>0) THEN (* translate *)
                Out.Char(toset[lastto]);
            ELSIF (i >= 0) & (lastto > 0) THEN    (* translate *)
                Out.Char(toset[i]);
            ELSIF i = -1 THEN                        (* copy *)
              (* Do not translate the character *)
              Out.Char(c);
              (* NOTE: No else clause needed as not writing out
			     a cut value is deleting *)
            END;
        END;
    UNTIL (In.Done # TRUE);
END Translit;

BEGIN
    Translit();
END Translit.

~~~



In closing
==========

In this chapter we interact with some of the most common features
of command line programs available on POSIX systems. K & P have given
us a solid foundation on which to build more complex and ambitious
programs. In the following chapters the read will find an
accelerated level of complexity bit also programs that are
significantly more powerful.

Oberon language evolved with the Oberon System which had a very
different rich text user interface when compared with POSIX.
Fortunately Karl's OBNC comes with a set of modules that make
Oberon-07 friendly for building programs for POSIX operating systems.
I've taken advantage of his `extArgs` module much in the way
that K & P relied on a set of primitive tools to provide a common
programming environment. K & P's version of
[implementation of primitives](https://archive.org/details/softwaretoolsinp00kern/page/315/mode/1up)
listed in their appendix. Karl's OBNC extensions modules are
described on [website](https://miasap.se/obnc/obncdoc/ext/).
Other Oberon compilers provide similar modules though implementation
specific. A good example is Spivey's [Oxford Oberon-2 Compiler](https://spivey.oriel.ox.ac.uk/corner/Oxford_Oberon-2_compiler).
K & P chose to target multiple Pascal implementations, I have the
luxury of targeting one Oberon-07 implementation. That said if you
added a pre-processor like K & P did you could also take their approach
to allow you Oberon-07 code to work across many Oberon compiler
implementations. I leave that as an exercise for the reader.

I've chosen to revise some of the code presented in K & P's book. I
believe the K & P implementations still contains wisdom in their
implementations. They had different constraints and thus made
different choices in implementation. Understand the trade offs and
challenges to writing portable code capable of running in very
divergent set of early 1980's operating systems remains useful today.

Compiling with OBNC:

~~~

    obnc -o entab Entab.Mod
    obnc -o overstrike Overstrike.Mod
    obnc -o compress Compress.Mod
    obnc -o expand Expand.Mod
    obnc -o echo Echo.Mod
    obnc -o translit Translit.Mod

~~~

+ [Entab](Entab.Mod)
    + [Tabs](Tabs.Mod), this one visited this one in last installment.
+ [Overstrike](Overstrike.Mod)
+ [Compress](Compress.Mod)
+ [Expand](Expand.Mod)
+ [Echo](Echo.Mod)
+ [Translit](Translit.Mod)
	+ [Chars](Chars.Mod)

<!--
Next and Previous
-----------------

+ Next: [Files]()
-->

Previous
--------

+ Previous: [Getting Started](../../09/29/Software-Tools-1.html)
