---
title: Portable Conversions (Integers)
number: 21
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2021-11-26'
copyright: 'copyright (c) 2021, R. S. Doiel'
keywords:
  - Oberon
  - Modules
  - Types
  - conversion
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2021
copyrightHolder: R. S. Doiel
abstract: >
  An area in working with Oberon-07 on a POSIX machine that has proven
  problematic is type conversion. In particular converting to and from INTEGER
  or REAL and ASCII.  None of the three compilers I am exploring provide a
  common way of handling this. I've explored relying on C libraries but that
  approach has it's own set of problems.  I've become convinced a better
  approach is a pure Oberon-07 library that handles type conversion with a
  minimum of assumptions about the implementation details of the Oberon compiler
  or hardware. I'm calling my conversion module "Types". The name is short and
  descriptive and seems an appropriate name for a module consisting of type
  conversion tests and transformations.  My initial implementation will focusing
  on converting integers to and from ASCII.


  ...
dateCreated: '2021-11-26'
dateModified: '2025-07-22'
datePublished: '2021-11-26'
postPath: 'blog/2021/11/26/Portable-Conversions-Integers.md'
series: |
  Mostly Oberon
seriesNo: 19
---

Portable conversions (Integers)
===============================

By R. S. Doiel, 2021-11-26

An area in working with Oberon-07 on a POSIX machine that has proven problematic is type conversion. In particular converting to and from INTEGER or REAL and ASCII.  None of the three compilers I am exploring provide a common way of handling this. I've explored relying on C libraries but that approach has it's own set of problems.  I've become convinced a better approach is a pure Oberon-07 library that handles type conversion with a minimum of assumptions about the implementation details of the Oberon compiler or hardware. I'm calling my conversion module "Types". The name is short and descriptive and seems an appropriate name for a module consisting of type conversion tests and transformations.  My initial implementation will focusing on converting integers to and from ASCII.

INTEGER to ASCII and back again
-------------------------------

I don't want to rely on the representation of the INTEGER value in the compiler or at the machine level. That has lead me to think in terms of an INTEGER as a signed whole number. 

The simplest case of converting to/from ASCII is the digits from zero to nine (inclusive). Going from an INTEGER to an ASCII CHAR is just looking up the offset of the character representing the "digit". Like wise going from ASCII CHAR to a INTEGER is a matter of mapping in the reverse direction.  Let's call these procedures `DigitToChar` and  `CharToDigit*`.

Since INTEGER can be larger than zero through nine and CHAR can hold non-digits I'm going to add two additional procedures for validating inputs -- `IsIntDigit` and `IsCharDigit`. Both return TRUE if valid, FALSE if not.

For numbers larger than one digit I can use decimal right shift to extract the ones column value or a left shift to reverse the process.  Let's called these `IntShiftRight` and `IntShiftLeft`.  For shift right it'd be good to capture the ones column being lost. For shift left it would be good to be able to shift in a desired digit. That way you could shift/unshift to retrieve to extract and put back values.

A draft definition for "Types" should look something like this.

~~~
DEFINITION Types;

(* Check if an integer is a single digit, i.e. from 0 through 9 returns
   TRUE, otherwise FALSE *)
PROCEDURE IsIntDigit(x : INTEGER) : BOOLEAN;

(* Check if a CHAR is "0" through "9" and return TRUE, otherwise FALSE *)
PROCEDURE IsCharDigit(ch : CHAR) : BOOLEAN;

(* Convert digit 0 through 9 into an ASCII CHAR "0" through "9",
   ok is TRUE if conversion successful, FALSE otherwise *)
PROCEDURE DigitToChar(x : INTEGER; VAR ch : CHAR; VAR ok : BOOLEAN);

(* Convert a CHAR "0" through "9" into a digit 0 through 9, ok
   is TRUE is conversion successful, FALSE otherwise *)
PROCEDURE CharToDigit(ch : CHAR; VAR x : INTEGER; VAR ok : BOOLEAN);

(* Shift an integer to the right (i.e. x * 0.1) set "r" to the
   value shifted out (ones column lost) and return the shifted value.
   E.g.  x becomes 12, r becomes 3.

       x := IntShiftRight(123, r);
   
 *)
PROCEDURE IntShiftRight(x : INTEGER; VAR r : INTEGER) : INTEGER;

(* Shift an integer to the left (i.e. x * 10) adding the value y
   after the shift.

   E.g. x before 123

       x := IntShiftRight(12, 3);

 *)
PROCEDURE IntShiftLeft(x, y : INTEGER) : INTEGER;

(* INTEGER to ASCII *)
PROCEDURE Itoa(src : INTEGER; VAR value : ARRAY OF CHAR; VAR ok : BOOLEAN);

(* ASCII to INTEGER *)
PROCEDURE Atoi(src : ARRAY OF CHAR; VAR value : INTEGER; VAR ok : BOOLEAN);

END Types.
~~~


NOTE: Oberon-07 provides us the ORD and CHR built as part of the
language.  These are for working with the encoding and decoding
values as integers. This is not the same thing as the meaning
of "0" versus the value of 0.  Getting to and from the encoding
to the meaning of the presentation can be done with some simple
arithmetic.

Putting it all together
-----------------------

~~~
(* DigitToChar converts an INTEGER less than to a character. E.g.
   0 should return "0", 3 returns "3", 0 returns "9" *)
PROCEDURE DigitToChar*(i : INTEGER) : CHAR;
BEGIN
  RETURN (CHR(ORD("0") + i))
END DigitToChar;

(* CharToDigit converts a single "Digit" character to an INTEGER value.
   E.g. "0" returns 0, "3" returns 3, "9" returns 9. *)
PROCEDURE CharToDigit(ch : CHAR) : INTEGER;
BEGIN
  RETURN (ORD(ch) - ORD("0"))
END CharToDigit;
~~~

This implementation is naive. It assumes the ranges of the input values
was already checked. In practice this is going to encourage bugs.

In a language like Go or Python you can return multiple values (in
Python you can return a tuple). In Oberon-07 I could use a
RECORD type to do that but that feels a little too baroque. Oberon-07
like Oberon-2, Oberon, Modula and Pascal does support "VAR" parameters. 
With a slight modification to our procedure signatures I can support
easy assertions about the conversion. Let's create two functional
procedures `IsIntDigit()` and `IsCharDigit()` then update our
`DigitToChar()` and `CharToDigit()` with an a  "VAR ok : BOOLEAN"
parameter.

~~~
(* IsIntDigit returns TRUE is the integer value is zero through nine *)
PROCEDURE IsIntDigit(i : INTEGER) : BOOLEAN;
BEGIN 
  RETURN ((i >= 0) & (i <= 9))
END IsIntDigit;

(* IsCharDigit returns TRUE if character is zero through nine. *)
PROCEDURE IsCharDigit(ch : CHAR) : BOOLEAN;
BEGIN
  RETURN ((ch >= "0") & (ch <= "9"))
END IsCharDigit;

(* DigitToChar converts an INTEGER less than to a character. E.g.
   0 should return "0", 3 returns "3", 0 returns "9" *)
PROCEDURE DigitToChar*(i : INTEGER; VAR ok : BOOLEAN) : CHAR;
BEGIN
  ok := IsIntDigit(i);
  RETURN (CHR(ORD("0") + i))
END DigitToChar;

(* CharToDigit converts a single "Digit" character to an INTEGER value.
   E.g. "0" returns 0, "3" returns 3, "9" returns 9. *)
PROCEDURE CharToDigit(ch : CHAR; VAR ok : BOOLEAN) : INTEGER;
BEGIN
  ok := IsCharDigit(ch);
  RETURN (ORD(ch) - ORD("0"))
END CharToDigit;
~~~

What about values are greater nine? Here we can take advantage
of our integer shift procedures.  `IntShiftRight` will move the
INTEGER value right reducing it's magnitude (i.e. x * 0.1). It
also captures the ones column lost in the shift.  Repeatedly calling
`IntShiftRight` will let us peal off the ones columns until the
value "x" is zero. `IntShiftLeft` shifts the integer to the
left meaning it raises it a magnitude (i.e. x * 10). `IntShiftLeft`
also rakes a value to shift in on the right side of the number.
In this way we can shift in a zero and get `x * 10` or shift in
another digit and get `(x * 10) + y`. This means you can use
`IntShiftRight` and recover an `IntShiftLeft`.

~~~

(* IntShiftRight converts the input integer to a real, multiplies by 0.1
   and converts by to an integer. The value in the ones column is record
   in the VAR parameter r.  E.g. IntShiftRight(123) return 12, r is set to 3. *)
PROCEDURE IntShiftRight*(x : INTEGER; VAR r : INTEGER) : INTEGER;
  VAR i : INTEGER; isNeg : BOOLEAN;
BEGIN
  isNeg := (x < 0);
  i := FLOOR(FLT(ABS(x)) * 0.1);
  r := ABS(x) - (i * 10);
  IF isNeg THEN
    i := i * (-1);
  END;
  RETURN i
END IntShiftRight;

(* IntShiftLeft multiples input value by 10 and adds y. E.g. IntShiftLeft(123, 4) return 1234 *)
PROCEDURE IntShiftLeft*(x, y : INTEGER) : INTEGER;
  VAR i : INTEGER; isNeg : BOOLEAN;
BEGIN
  isNeg := (x < 0);
  i := (ABS(x) * 10) + y;
  IF isNeg THEN
    i := i * (-1);
  END;
  RETURN i
END IntShiftLeft;

~~~

I have what I need for implementing `Itoa` (integer to ASCII).


~~~

(* Itoa converts an INTEGER to an ASCII string setting ok BOOLEAN to
   TRUE if value ARRAY OF CHAR holds the full integer, FALSE if
   value was too small to hold the integer value.  *)
PROCEDURE Itoa*(x : INTEGER; VAR value : ARRAY OF CHAR; ok : BOOLEAN);
  VAR i, j, k, l, minL : INTEGER; tmp : ARRAY BUFSIZE OF CHAR; isNeg : BOOLEAN;
BEGIN
  i := 0; j := 0; k := 0; l := LEN(value); isNeg := (x < 0);
  IF isNeg THEN
    (* minimum string length for value is 3, negative sign, digit and 0X *)
    minL := 3;
  ELSE 
    (* minimum string length for value is 2, one digit and 0X *)
    minL := 2; 
  END;
  ok := (l >= minL) & (LEN(value) >= LEN(tmp));
  IF ok THEN
    IF IsIntDigit(ABS(x)) THEN
      IF isNeg THEN
         value[i] := "-"; INC(i);
      END;
      value[i] := DigitToChar(ABS(x), ok); INC(i); value[i] := 0X;
    ELSE
      x := ABS(x); (* We need to work with the absolute value of x *)
      i := 0; tmp[i] := 0X;
      WHILE (x >= 10) & ok DO
        (* extract the ones columns *)
        x := IntShiftRight(x, k); (* a holds the shifted value, 
                                     "k" holds the ones column 
                                     value shifted out. *)
        (* write append k to our temp array holding values in
           reverse number magnitude *)
        tmp[i] := DigitToChar(k, ok); INC(i); tmp[i] := 0X;
      END;
      (* We now can convert the remaining "ones" column. *)
      tmp[i] := DigitToChar(x, ok); INC(i); tmp[i] := 0X;
      IF ok THEN
        (* now reverse the order of tmp string append each
           character to value *)
        i := 0; j := Strings.Length(tmp) - 2;
        IF isNeg THEN
          value[i] := "-"; INC(i);
        END;
        j := Strings.Length(tmp) - 1;
        WHILE (j > -1) DO
          value[i]:= tmp[j]; 
          INC(i); DEC(j);
          value[i] := 0X;
        END;
        value[i] := 0X;
      END;
    END; 
  ELSE
    ok := FALSE;
  END;
END Itoa;

~~~

Integers in Oberon are signed. So I've chosen to capture the sign in the `isNeg` variable. This lets me work with the absolute value for the actual conversion.  One failing in this implementation is I don't detect an overflow.  Also notice that I am accumulating the individual column values in reverse order (lowest magnitude first).  That is what I need a temporary buffer. I can then copy the values in reverse order into the VAR ARRAY OF CHAR. Finally I also maintain the ok BOOLEAN to track if anything went wrong.

When moving from an ASCII representation I can simplified the code by having a local (to the module) procedure for generating magnitudes.

Going the other way I can simplify my `Atoi` if I have an local to the module "magnitude" procedure.

~~~

(* magnitude takes x and multiplies it be 10^y, If y is positive zeros
   are appended to the right side (i.e. multiplied by 10). If y is
   negative then the result is shifted left (i.e.. multiplied by
   0.1 via IntShiftRight().).  The digit(s) shift to the fractional
   side of the decimal are ignored. *)
PROCEDURE magnitude(x, y : INTEGER) : INTEGER;
  VAR z, w : INTEGER;
BEGIN
  z := 1;
  IF y >= 0 THEN
    WHILE y > 0 DO
      z := IntShiftLeft(z, 0);
      DEC(y);
    END;
  ELSE
    WHILE y < 0 DO
      x := IntShiftRight(x, w);
      INC(y);
    END;
  END;
  RETURN (x * z)
END magnitude;

~~~

And with that I can put together my `Atoi` (ASCII to integer) procedure.  I'll need to add some sanity checks as well.

~~~

(* Atoi converts an ASCII string to a signed integer value
   setting the ok BOOLEAN to TRUE on success and FALSE on error. *)
PROCEDURE Atoi*(source : ARRAY OF CHAR; VAR value : INTEGER; VAR ok : BOOLEAN);
  VAR i, l, a, m: INTEGER; isNeg : BOOLEAN;
BEGIN
  (* "i" is the current CHAR position we're analyzing, "l" is the
     length of our string, "a" holds the accumulated value,
     "m" holds the current magnitude we're working with *)
  i := 0; l := Strings.Length(source);
  a := 0; m := l - 1; isNeg := FALSE; ok := TRUE;
  (* Validate magnitude and sign behavior *)
  IF (l > 0) & (source[0] = "-") THEN
    INC(i); DEC(m);
    isNeg := TRUE;
  ELSIF (l > 0) & (source[0] = "+") THEN
    INC(i); DEC(m);
  END;

  (* The accumulator should always hold a positive integer, if the
     sign flips we have overflow, ok should be set to FALSE *)
  ok := TRUE;
  WHILE (i < l) & ok DO
    a := a + magnitude(CharToDigit(source[i], ok), m);
    IF a < 0 THEN
      ok := FALSE; (* we have an overflow condition *)
    END;
    DEC(m);
    INC(i);
  END;
  IF ok THEN
    IF (i = l) THEN
      IF isNeg THEN
        value := a * (-1);
      ELSE
        value := a;
      END;
    END;
  END;
END Atoi;

~~~

Here's an example using the procedures.

Converting an integer 1234 to an string "1234".

~~~

   x := 1234; s := ""; ok := FALSE;
   Types.Itoa(x, s, ok);
   IF ok THEN 
     Out.String(s); Out.String(" = ");
     Out.Int(x,1);Out.Ln;
   ELSE
     Out.String("Something went wrong");Out.Ln;
   END;

~~~

Converting a string "56789" to integer 56789.

~~~

   x := 0; src := "56789"; ok := FALSE;
   Types.Atoi(src, x, ok);
   IF ok THEN 
     Out.Int(x,1); Out.String(" = "); Out.String(s); 
     Out.Ln;
   ELSE
     Out.String("Something went wrong");Out.Ln;
   END;

~~~


References and resources
------------------------

Implementations for modules for this article are linked here [Types](./Types.Mod), [TypesTest](./TypesTest.Mod) and [Tests](./Tests.Mod). 

Expanded versions of the `Types` module will be available as part of Artemis Project -- [github.com/rsdoiel/Artemis](https://github.com/rsdoiel/Artemis).

Previous
--------

- [Revisiting Files](../../11/22/Revisiting-Files.html)
