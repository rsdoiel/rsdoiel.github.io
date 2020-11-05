MODULE Chars;
IMPORT Strings;

CONST
    DASH* = "-";
    ENDSTR* = 0X;
    NEWLINE* = 10X;
    TAB* = 9X;
    BLANK* = 32X;
    CARET* = "^";
    TILDE* = "~";

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

(* Equal - compares two ARRAY OF CHAR and returns TRUE
if the characters match up to the end of string, FALSE otherwise. *)
PROCEDURE Equal*(a : ARRAY OF CHAR; b : ARRAY OF CHAR) : BOOLEAN;
VAR isSame : BOOLEAN; i : INTEGER;
BEGIN
  isSame := TRUE;
  IF Strings.Length(a) # Strings.Length(b) THEN
    isSame := FALSE;
  ELSE
    FOR i := 0 TO (Strings.Length(a) - 1) DO
      IF a[i] # b[i] THEN
        isSame := FALSE;
      END;
    END;
  END;
  RETURN isSame
END Equal;

(* Clear - resets all cells of an ARRAY OF CHAR to 0X *)
PROCEDURE Clear*(VAR a : ARRAY OF CHAR);
VAR i : INTEGER;
BEGIN
  FOR i := 0 TO (LEN(a) - 1) DO
    a[i] := 0X;
  END;
END Clear;

END Chars.



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

AppendChar
: Append a single char to the end of an ARRAY OF CHAR adjusting the terminating null character.

Equal
: Compares two ARRAY OF CHAR and returns TRUE if they match, FALSE otherwise

Clear
: Sets all cells in an ARRAY OF CHAR to 0X.

