---
title: "Beyond Oakwood, Modules and Aliases"
number: 18
author: "R. S. Doiel"
date: "2021-05-16"
copyright: "copyright (c) 2021, R. S. Doiel"
keywords: [ "Oberon", "Modules", "Oakwood", "Strings", "Chars" ]
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---

Beyond Oakwood, Modules and Aliases
===================================

By R. S. Doiel, 2021-05-16

Oakwood is the name used to refer to an early Oberon language
standardization effort in the late 20th century.  It's the name
of a hotel where compiler developers and the creators of Oberon
and the Oberon System met to discuss compatibility. The lasting
influence on the 21st century Oberon-7 language can be seen
in the standard set of modules shipped with POSIX based Oberon-7
compilers like
[OBNC](https://miasap.se/obnc/), [Vishap Oberon Compiler](https://github.com/vishaps/voc) and the 
[Oxford Oberon Compiler](http://spivey.oriel.ox.ac.uk/corner/Oxford_Oberon-2_compiler).

The Oakwood guidelines described a minimum expectation for
a standard set of modules to be shipped with compilers.
The modules themselves are minimalist in implementation.
Minimalism can assist in easing the learning curve
and encouraging a deeper understanding of how things work.

The Oberon-7 language is smaller than the original Oberon language
and the many dialects that followed.  I think of Oberon-7 as the
distillation of all previous innovation.  It embodies the
spirit of "Simple but not simpler than necessary". Minimalism is
a fit description of the adaptions of the Oakwood modules for 
Oberon-7 in the POSIX environment.


When simple is too simple
-------------------------

Sometimes I want more than the minimalist module.  A good example
is standard [Strings](https://miasap.se/obnc/obncdoc/basic/Strings.def.html)
module.  Thankfully you can augment the standard modules with your own.
If you are creative you can even create a drop in replacement.
This is what I wound up doing with my "Chars" module.

In the spirit of "Simple but no simpler" I originally kept Chars 
very minimal. I only implemented what I missed most from Strings.
I got down to a handful of functions for testing characters,
testing prefixes and suffixes as well as trim procedures. It was
all I included in `Chars` was until recently.

Over the last couple of weeks I have been reviewing my own Oberon-7
code in my personal projects.  I came to understand that
in my quest for minimalism I had fallen for "too simple".
This was evidenced by two observations.  Everywhere I had used
the `Strings` module I also included `Chars`. It was boiler plate.
The IMPORT sequence was invariably a form of --

~~~
    IMPORT Strings, Chars, ....
~~~

On top of that I found it distracting to see `Chars.*` and `Strings.*`
comingled and operating on the same data. If felt sub optimal. It
felt baroque. That got me thinking.

> What if Chars included the functionality of Strings?

I see two advantages to merging Chars and Strings. First I
only need to include one module instead of two. The second
is my code becomes more readable. I think that is because
expanding Strings to include new procedures and constants allows
for both the familiar and for evolution. The problem is renaming
`Chars.Mod` to `Strings.Mod` implies I'm supplying the standard
`Strings` module. Fortunately Oberon provides a mechanism for
solving this problem. The solution Oberon provides is to allow
module names to be aliased.  Look at my new import statement.

~~~
    IMPORT Strings := Chars, ...
~~~

It is still minimal but at the same time shows `Chars` is going
to be referenced as `Strings`. By implication `Chars` provides
the functionality `Strings` but is not the same as `Strings`.
My code reads nicely.  I don't loose the provenance of what
is being referred to by `Strings` because it is clearly 
provided in the IMPORT statement.

In my new [implementation](Chars.Mod) I support all the standard
procedures you'd find in an Oakwood compliant `Strings`.  I've
included additional additional constants and functional procedures
like `StartsWith()` and `EndsWith()` and a complement of trim
procedures like `TrimLeft()`, `TrimRight()`, `Trim()`.
`TrimPrefix()`, and `TrimSuffix()`.

Here's how `Chars` definition stacks up as rendered by the
obncdoc tool.

```
(* Chars.Mod - A module for working with CHAR and 
   ARRAY OF CHAR data types.

Copyright (C) 2020, 2021 R. S. Doiel <rsdoiel@gmail.com>
This Source Code Form is subject to the terms of the
Mozilla PublicLicense, v. 2.0. If a copy of the MPL was
not distributed with thisfile, You can obtain one at
http://mozilla.org/MPL/2.0/. *)
DEFINITION Chars;

(*
Chars.Mod provides a modern set of procedures for working
with CHAR and ARRAY OF CHAR. It is a drop in replacement
for the Oakwood definition 
Strings module.

Example:

    IMPORT Strings := Chars;

You now have a Strings compatible Chars module plus all the Chars
extra accessible through the module alias of Strings. *)

CONST
  (* MAXSTR is exported so we can use a common
     max string size easily *)
  MAXSTR = 1024;
  (* Character constants *)
  EOT = 0X;
  TAB = 9X;
  LF  = 10X;
  FF  = 11X;
  CR  = 13X;
  SPACE = " ";
  DASH  = "-";
  LODASH = "_";
  CARET = "^";
  TILDE = "~";
  QUOTE = 34X;

  (* Constants commonly used characters to quote things.  *)
  QUOT   = 34X;
  AMP    = "&";
  APOS   = "'";
  LPAR   = ")";
  RPAR   = "(";
  AST    = "*";
  LT     = "<";
  EQUALS = "=";
  GT     = ">";
  LBRACK = "[";
  RBRACK = "]";
  LBRACE = "}";
  RBRACE = "{";

VAR
  (* common cutsets, ideally these would be constants *)
  spaces : ARRAY 6 OF CHAR;
  punctuation : ARRAY 33 OF CHAR;

(* InRange -- given a character to check and an inclusive range of
    characters in the ASCII character set. Compare the ordinal values
    for inclusively. Return TRUE if in range FALSE otherwise. *)
PROCEDURE InRange(c, lower, upper : CHAR) : BOOLEAN;

(* InCharList checks if character c is in list of chars *)
PROCEDURE InCharList(c : CHAR; list : ARRAY OF CHAR) : BOOLEAN;

(* IsUpper return true if the character is an upper case letter *)
PROCEDURE IsUpper(c : CHAR) : BOOLEAN;

(* IsLower return true if the character is a lower case letter *)
PROCEDURE IsLower(c : CHAR) : BOOLEAN;

(* IsDigit return true if the character in the range of "0" to "9" *)
PROCEDURE IsDigit(c : CHAR) : BOOLEAN;

(* IsAlpha return true is character is either upper or lower case letter *)
PROCEDURE IsAlpha(c : CHAR) : BOOLEAN;

(* IsAlphaNum return true is IsAlpha or IsDigit *)
PROCEDURE IsAlphaNum (c : CHAR) : BOOLEAN;

(* IsSpace returns TRUE if the char is a space, tab, carriage return or line feed *)
PROCEDURE IsSpace(c : CHAR) : BOOLEAN;

(* IsPunctuation returns TRUE if the char is a non-alpha non-numeral *)
PROCEDURE IsPunctuation(c : CHAR) : BOOLEAN;

(* Length returns the length of an ARRAY OF CHAR from zero to first
    0X encountered. [Oakwood compatible] *)
PROCEDURE Length(source : ARRAY OF CHAR) : INTEGER;

(* Insert inserts a source ARRAY OF CHAR into a destination 
    ARRAY OF CHAR maintaining a trailing 0X and truncating if
    necessary [Oakwood compatible] *)
PROCEDURE Insert(source : ARRAY OF CHAR; pos : INTEGER; VAR dest : ARRAY OF CHAR);

(* AppendChar - this copies the char and appends it to
    the destination. Returns FALSE if append fails. *)
PROCEDURE AppendChar(c : CHAR; VAR dest : ARRAY OF CHAR) : BOOLEAN;

(* Append - copy the contents of source ARRAY OF CHAR to end of
    dest ARRAY OF CHAR. [Oakwood complatible] *)
PROCEDURE Append(source : ARRAY OF CHAR; VAR dest : ARRAY OF CHAR);

(* Delete removes n number of characters starting at pos in an
    ARRAY OF CHAR. [Oakwood complatible] *)
PROCEDURE Delete(VAR source : ARRAY OF CHAR; pos, n : INTEGER);

(* Replace replaces the characters starting at pos with the
    source ARRAY OF CHAR overwriting the characters in dest
    ARRAY OF CHAR. Replace will enforce a terminating 0X as
    needed. [Oakwood compatible] *)
PROCEDURE Replace(source : ARRAY OF CHAR; pos : INTEGER; VAR dest : ARRAY OF CHAR);

(* Extract copies out a substring from an ARRAY OF CHAR into a dest
    ARRAY OF CHAR starting at pos and for n characters
    [Oakwood compatible] *)
PROCEDURE Extract(source : ARRAY OF CHAR; pos, n : INTEGER; VAR dest : ARRAY OF CHAR);

(* Pos returns the position of the first occurrence of a pattern
    ARRAY OF CHAR starting at pos in a source ARRAY OF CHAR. If
    pattern is not found then it returns -1 *)
PROCEDURE Pos(pattern, source : ARRAY OF CHAR; pos : INTEGER) : INTEGER;

(* Cap replaces each lower case letter within source by an uppercase one *)
PROCEDURE Cap(VAR source : ARRAY OF CHAR);

(* Equal - compares two ARRAY OF CHAR and returns TRUE
    if the characters match up to the end of string,
    FALSE otherwise. *)
PROCEDURE Equal(a : ARRAY OF CHAR; b : ARRAY OF CHAR) : BOOLEAN;

(* StartsWith - check to see of a prefix starts an ARRAY OF CHAR *)
PROCEDURE StartsWith(prefix : ARRAY OF CHAR; VAR source : ARRAY OF CHAR) : BOOLEAN;

(* EndsWith - check to see of a prefix starts an ARRAY OF CHAR *)
PROCEDURE EndsWith(suffix : ARRAY OF CHAR; VAR source : ARRAY OF CHAR) : BOOLEAN;

(* Clear - resets all cells of an ARRAY OF CHAR to 0X *)
PROCEDURE Clear(VAR a : ARRAY OF CHAR);

(* Shift returns the first character of an ARRAY OF CHAR and shifts the
    remaining elements left appending an extra 0X if necessary *)
PROCEDURE Shift(VAR source : ARRAY OF CHAR) : CHAR;

(* Pop returns the last non-OX element of an ARRAY OF CHAR replacing
    it with an OX *)
PROCEDURE Pop(VAR source : ARRAY OF CHAR) : CHAR;

(* TrimLeft - remove the leading characters in cutset
    from an ARRAY OF CHAR *)
PROCEDURE TrimLeft(cutset : ARRAY OF CHAR; VAR source : ARRAY OF CHAR);

(* TrimRight - remove tailing characters in cutset from
    an ARRAY OF CHAR *)
PROCEDURE TrimRight(cutset : ARRAY OF CHAR; VAR source : ARRAY OF CHAR);

(* Trim - remove leading and trailing characters in cutset
    from an ARRAY OF CHAR *)
PROCEDURE Trim(cutset : ARRAY OF CHAR; VAR source : ARRAY OF CHAR);

(* TrimLeftSpace - remove leading spaces from an ARRAY OF CHAR *)
PROCEDURE TrimLeftSpace(VAR source : ARRAY OF CHAR);

(* TrimRightSpace - remove the trailing spaces from an ARRAY OF CHAR *)
PROCEDURE TrimRightSpace(VAR source : ARRAY OF CHAR);

(* TrimSpace - remove leading and trailing space CHARS from an 
    ARRAY OF CHAR *)
PROCEDURE TrimSpace(VAR source : ARRAY OF CHAR);

(* TrimPrefix - remove a prefix ARRAY OF CHAR from a target 
    ARRAY OF CHAR *)
PROCEDURE TrimPrefix(prefix : ARRAY OF CHAR; VAR source : ARRAY OF CHAR);

(* TrimSuffix - remove a suffix ARRAY OF CHAR from a target
    ARRAY OF CHAR *)
PROCEDURE TrimSuffix(suffix : ARRAY OF CHAR; VAR source : ARRAY OF CHAR);

(* TrimString - remove cutString from beginning and end of ARRAY OF CHAR *)
PROCEDURE TrimString(cutString : ARRAY OF CHAR; VAR source : ARRAY OF CHAR);

END Chars.
```

My new `Chars` module has proven to be both more readable
and more focused in my projects. I get all the functionality
of `Strings` and the additional functionality I need in my own
projects. This improved the focus in my other modules and I think
maintained the spirit of "Simple but not simpler".

+ [Chars.Mod](Chars.Mod)

UPDATE: The current version of my `Chars` module can be found in 
my [Artemis](https://github.com/rsdoiel/Artemis) repository. The
repository includes additional code and modules suitable to working
with Oberon-7 in a POSIX envinronment.

### Next, Previous

+ Next [Combining Oberon-7 with C using Obc-3](/blog/2021/06/14/Combining-Oberon-7-with-C-using-Obc-3.html)
+ Prev [Dates & Clocks](/blog/2020/11/27/Dates-and-Clock.html)

