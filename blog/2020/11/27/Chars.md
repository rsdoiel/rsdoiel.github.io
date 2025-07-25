---
title: Chars
author: R. S. Doiel
copyrightYear: 2020
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: |
  Source code for Chars.Mod.

  ...
dateCreated: '2020-11-27'
dateModified: '2025-07-22'
datePublished: '2020-11-27'
keywords:
  - Oberon-07
  - C-shared
series: |
  Mostly Oberon
seriesNo: 24
---

Chars
=====

This module provides common character oriented tests.

InRange
: Check to see if a character, c, is in an inclusive range from a lower to upper character.

IsUpper
: Check to see if a character is upper case

IsLower
: Check to see if a character is lower case

IsAlpha
: Check to see if a character is alphabetic, i.e. in the range of "a" to "z"
or "A" to "Z".

IsDigit
: Check to see if a character is a digit, i.e. in range of "0" to "9"

IsAlphaNum
: Check to see if a character is alpha or a digit

IsSpace
: Check to see if a character is a space, tab, carriage return or line feed

AppendChar
: Append a single char to the end of an ARRAY OF CHAR adjusting the terminating null character and return TRUE on success or FALSE otherwise.

AppendChars
: Append an ARRAY OF CHAR to another the destination ARRAY OF CHAR.

Equal
: Compares two ARRAY OF CHAR and returns TRUE if they match, FALSE otherwise

Clear
: Sets all cells in an ARRAY OF CHAR to 0X.

TrimSpace
: Trim the leading and trailing space characters from an ARRAY OF CHAR

TrimLeftSpace
: Trim the leading space characters from an ARRAY OF CHAR

TrimRightSpace
: Trim the trailing space characters from an ARRAY OF CHAR

StartsWith
: Checks to see if a prefix ARRAY OF CHAR matches a target ARRAY OF CHAR return TRUE if found, FALSE otherwise

EndsWith
: Checks to see if a suffix ARRAY OF CHAR matches a target ARRAY OF CHAR return TRUE if found, FALSE otherwise

TrimPrefix
: Trim a prefix ARRAY OF CHAR from a target ARRAY OF CHAR

TrimSuffix
: Trim a suffix ARRAY OF CHAR from a target ARRAY OF CHAR




Source code for **Chars.Mod**
-----------------------------

~~~
MODULE Chars;

IMPORT Strings;

CONST
    MAXSTR* = 1024; (* or whatever *)
    (* byte constants *)
    LF* = 10;
    CR* = 13;
    (* Character constants *)
    ENDSTR* = 0X;
    NEWLINE* = 10X;
    TAB* = 9X;
    SPACE* = " ";
    DASH* = "-";
    CARET* = "^";
    TILDE* = "~";
    QUOTE* = CHR(34);

(* InRange -- given a character to check and an inclusive range of
characters in the ASCII character set. Compare the ordinal values
for inclusively. Return TRUE if in range FALSE otherwise. *)
PROCEDURE InRange* (c, lower, upper : CHAR) : BOOLEAN;
VAR inrange : BOOLEAN;
BEGIN
  IF (ORD(c) >= ORD(lower)) & (ORD(c) <= ORD(upper)) THEN
    inrange := TRUE;
  ELSE
    inrange := FALSE;
  END;
  RETURN inrange
END InRange;

(* IsUpper return true if the character is an upper case letter *)
PROCEDURE IsUpper*(c : CHAR) : BOOLEAN;
VAR isupper : BOOLEAN;
BEGIN
    IF InRange(c, "A", "Z") THEN
        isupper := TRUE;
    ELSE
        isupper := FALSE;
    END
    RETURN isupper
END IsUpper;


(* IsLower return true if the character is a lower case letter *)
PROCEDURE IsLower*(c : CHAR) : BOOLEAN;
VAR islower : BOOLEAN;
BEGIN
    IF InRange(c, "a", "a") THEN
        islower := TRUE;
    ELSE
        islower := FALSE;
    END
    RETURN islower
END IsLower;

(* IsDigit return true if the character in the range of "0" to "9" *)
PROCEDURE IsDigit*(c : CHAR) : BOOLEAN;
VAR isdigit : BOOLEAN;
BEGIN
    IF InRange(c, "0", "9") THEN
        isdigit := TRUE;
    ELSE
        isdigit := FALSE;
    END;
    RETURN isdigit
END IsDigit;

(* IsAlpha return true is character is either upper or lower case letter *)
PROCEDURE IsAlpha*(c : CHAR) : BOOLEAN;
VAR isalpha : BOOLEAN;
BEGIN
    IF IsUpper(c) OR IsLower(c) THEN
        isalpha := TRUE;
    ELSE
        isalpha := FALSE;
    END;
    RETURN isalpha
END IsAlpha;

(* IsAlphaNum return true is IsAlpha or IsDigit *)
PROCEDURE IsAlphaNum* (c : CHAR) : BOOLEAN;
VAR isalphanum : BOOLEAN;
BEGIN
    IF IsAlpha(c) OR IsDigit(c) THEN
        isalphanum := TRUE;
    ELSE
        isalphanum := FALSE;
    END;
    RETURN isalphanum
END IsAlphaNum;

(* IsSpace returns TRUE if the char is a space, tab, carriage return or line feed *)
PROCEDURE IsSpace*(c : CHAR) : BOOLEAN;
VAR isSpace : BOOLEAN;
BEGIN
	isSpace := FALSE;
	IF (c = SPACE) OR (c = TAB) OR (ORD(c) = CR) OR (ORD(c) = LF) THEN
    	isSpace := TRUE;
	END;
	RETURN isSpace
END IsSpace;

(* AppendChar - this copies the char and appends it to
   the destination. Returns FALSE if append fails. *)
PROCEDURE AppendChar*(c : CHAR; VAR dest : ARRAY OF CHAR) : BOOLEAN;
VAR res : BOOLEAN; l : INTEGER;
BEGIN
  l := Strings.Length(dest);
  (* NOTE: we need to account for a trailing 0X to end
     the string. *)
  IF l < (LEN(dest) - 1) THEN
    dest[l] := c;
    dest[l + 1] := 0X;
    res := TRUE;
  ELSE
    res := FALSE;
  END;
  RETURN res
END AppendChar;

(* AppendChars - copy the contents of src ARRAY OF CHAR to end of
   dest ARRAY OF CHAR *)
PROCEDURE AppendChars*(src : ARRAY OF CHAR; VAR dest : ARRAY OF CHAR);
VAR i, j : INTEGER;
BEGIN
  i := 0;
  WHILE (i < LEN(dest)) & (dest[i] # 0X) DO
    i := i + 1;
  END;
  j := 0;
  WHILE (i < LEN(dest)) & (j < Strings.Length(src)) DO
    dest[i] := src[j];
    i := i + 1;
    j := j + 1;
  END;
  WHILE i < LEN(dest) DO
    dest[i] := 0X;
    i := i + 1;
  END;
END AppendChars;

(* Equal - compares two ARRAY OF CHAR and returns TRUE
if the characters match up to the end of string, FALSE otherwise. *)
PROCEDURE Equal*(a : ARRAY OF CHAR; b : ARRAY OF CHAR) : BOOLEAN;
VAR isSame : BOOLEAN; i : INTEGER;
BEGIN
  isSame := (Strings.Length(a) = Strings.Length(b));
  i := 0;
  WHILE isSame & (i < Strings.Length(a)) DO
    IF a[i] # b[i] THEN
      isSame := FALSE;
    END;
    i := i + 1;
  END;
  RETURN isSame
END Equal;


(* StartsWith - check to see of a prefix starts an ARRAY OF CHAR *)
PROCEDURE StartsWith*(prefix : ARRAY OF CHAR; VAR src : ARRAY OF CHAR) : BOOLEAN;
VAR startsWith : BOOLEAN; i: INTEGER;
BEGIN
    startsWith := FALSE;
    IF Strings.Length(prefix) <= Strings.Length(src) THEN
        startsWith := TRUE;
        i := 0;
        WHILE (i < Strings.Length(prefix)) & startsWith DO
            IF prefix[i] # src[i] THEN
                startsWith := FALSE;
            END;
            i := i + 1;
        END;
    END;    
    RETURN startsWith
END StartsWith;

(* EndsWith - check to see of a prefix starts an ARRAY OF CHAR *)
PROCEDURE EndsWith*(suffix : ARRAY OF CHAR; VAR src : ARRAY OF CHAR) : BOOLEAN;
VAR endsWith : BOOLEAN; i, j : INTEGER;
BEGIN
    endsWith := FALSE;
    IF Strings.Length(suffix) <= Strings.Length(src) THEN
        endsWith := TRUE;
        i := 0;
        j := Strings.Length(src) - Strings.Length(suffix);
        WHILE (i < Strings.Length(suffix)) & endsWith DO
            IF suffix[i] # src[j] THEN
                endsWith := FALSE;
            END;
            i := i + 1;
            j := j + 1;
        END;
    END;
    RETURN endsWith
END EndsWith;


(* Clear - resets all cells of an ARRAY OF CHAR to 0X *)
PROCEDURE Clear*(VAR a : ARRAY OF CHAR);
VAR i : INTEGER;
BEGIN
  FOR i := 0 TO (LEN(a) - 1) DO
    a[i] := 0X;
  END;
END Clear;

(* Shift returns the first character of an ARRAY OF CHAR and shifts the
remaining elements left appending an extra 0X if necessary *)
PROCEDURE Shift*(VAR src : ARRAY OF CHAR) : CHAR;
VAR i, last : INTEGER; c : CHAR;
BEGIN
    i := 0;
    c := src[i];
    Strings.Delete(src, 0, 1);
    last := Strings.Length(src) - 1;
    FOR i := last TO (LEN(src) - 1) DO
        src[i] := 0X;
    END;
    RETURN c
END Shift;

(* Pop returns the last non-OX element of an ARRAY OF CHAR replacing
   it with an OX *)
PROCEDURE Pop*(VAR src : ARRAY OF CHAR) : CHAR;
VAR i, last : INTEGER; c : CHAR;
BEGIN
	(* Move to the last non-0X cell *)
	i := 0;
	last := LEN(src);
	WHILE (i < last) & (src[i] # 0X) DO
	   i := i + 1;
	END;
	IF i > 0 THEN
		i := i - 1;
	ELSE
		i := 0;
	END;
	c := src[i];
	WHILE (i < last) DO
		src[i] := 0X;
		i := i + 1;
	END;
	RETURN c
END Pop;

(* TrimLeftSpace - remove leading spaces from an ARRAY OF CHAR *)
PROCEDURE TrimLeftSpace*(VAR src : ARRAY OF CHAR);
VAR i : INTEGER;
BEGIN
    (* find the first non-space or end of the string *)
    i := 0;
    WHILE (i < LEN(src)) & IsSpace(src[i]) DO
        i := i + 1;
    END;
    (* Trims the beginning of the string *)
    IF i > 0 THEN
        Strings.Delete(src, 0, i);
    END;
END TrimLeftSpace;

(* TrimRightSpace - remove the trailing spaces from an ARRAY OF CHAR *)
PROCEDURE TrimRightSpace*(VAR src : ARRAY OF CHAR);
VAR i, l : INTEGER; 
BEGIN
    (* Find the first 0X, end of string *)
	l := Strings.Length(src);
	i := l - 1;
	(* Find the start of the trailing space sequence *)
	WHILE (i > 0) & IsSpace(src[i]) DO
		i := i - 1;
	END;
	(* Delete the trailing spaces *)
	Strings.Delete(src, i + 1, l - i);
END TrimRightSpace;

(* TrimSpace - remove leading and trailing space CHARS from an ARRAY OF CHAR *)
PROCEDURE TrimSpace*(VAR src : ARRAY OF CHAR);
BEGIN
	TrimLeftSpace(src);
	TrimRightSpace(src);    
END TrimSpace;    
    

(* TrimPrefix - remove a prefix ARRAY OF CHAR from a target ARRAY OF CHAR *)
PROCEDURE TrimPrefix*(prefix : ARRAY OF CHAR; VAR src : ARRAY OF CHAR);
VAR l : INTEGER;
BEGIN
    IF StartsWith(prefix, src) THEN
         l := Strings.Length(prefix);
         Strings.Delete(src, 0, l);
    END;
END TrimPrefix;

(* TrimSuffix - remove a suffix ARRAY OF CHAR from a target ARRAY OF CHAR *)
PROCEDURE TrimSuffix*(suffix : ARRAY OF CHAR; VAR src : ARRAY OF CHAR);
VAR i, l : INTEGER;
BEGIN
	IF EndsWith(suffix, src) THEN
		l := Strings.Length(src) - 1;
		FOR i := ((l - Strings.Length(suffix)) + 1) TO l DO
			src[i] := 0X;
		END;
	END;
END TrimSuffix;


END Chars.

~~~