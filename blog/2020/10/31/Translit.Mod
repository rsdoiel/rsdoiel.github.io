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

(* Clear string fills an array of char with 0X to (re)set
   a string to a known state. *)
PROCEDURE ClearString*(VAR s : ARRAY OF CHAR);
VAR i : INTEGER;
BEGIN
  FOR i := 0 TO LEN(s) - 1 DO
    s[i] := 0X;
  END;
END ClearString;

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
   position and appends the escaped value to the destination
   array.  It returns TRUE on successes, FALSE otherwise. *)
PROCEDURE ExpandEscape*(src : ARRAY OF CHAR; i : INTEGER; VAR dest : ARRAY OF CHAR) : BOOLEAN;
VAR res : BOOLEAN; j : INTEGER;
BEGIN
 res := FALSE;
 j := i + 1;
 IF j < Strings.Length(src)  THEN
    res := AppendChar(src[j], dest)
 END
 RETURN res
END ExpandEscape;

(* IsSequence - this procedure looks at position i and checks
   to see if we have a sequence to expand *)
PROCEDURE IsSequence*(src : ARRAY OF CHAR; i : INTEGER) : BOOLEAN;
VAR res : BOOLEAN;
BEGIN
  res := Strings.Length(src) - i >= 3;
  (* Do we have a sequence of alphanumeric character 
     DASH alphanumeric character? *)
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
  (* Make sure sequence is ascending *)
  res := TRUE;
  start := ORD(src[i]);
  end := ORD(src[i+2]);
  IF start < end THEN
    FOR cur := start TO end DO
      IF res THEN
        res := AppendChar(CHR(cur), dest);
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
            makeset := AppendChar(src[i], dest);
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
    (* NOTE: We are doing low level of string manipulation. Oberon
       strings are terminated by 0X, but Oberon compilers do not 
       automatically initialize memory to a specific state. In the 
       OBNC implementation of Oberon-7 assign "" to an assignment 
       like `s := "";` only writes a 0X to position zero of the 
       array of char. Since we're doing position based character 
       assignment and can easily overwrite a single 0X.  To be safe 
       we want to assign all the positions in the array to 0X so the 
       memory is in a known state.  *)
    ClearString(arg);
    ClearString(fromset);
    ClearString(toset);
    IF (Args.count = 0) THEN
        Error("usage: translit from to");
    END;
    (* NOTE: I haven't used an IF ELSE here because we have
       additional conditions that lead to complex logic.  The
       procedure Error() calls ASSERT(FALSE); which in Oberon-7
       halts the program from further execution *)
    IF (Args.count > 0) THEN
        Args.Get(0, arg, res);
        allbut := (arg[0] = NEGATE);
        IF (allbut) THEN
            i := 1;
        ELSE
            i := 0;
        END;
        Out.String("DEBUG i: ");Out.Int(i, 0);Out.Ln();
        IF MakeSet(arg, i, fromset) = FALSE THEN
        Out.String("DEBUG fromset: ");Out.String(fromset);Out.Ln();
            Error("from set too long");
        END;
    END;
    (* NOTE: We've initialized our array of char earlier so we only
       need to know if we need to update toset to a new value *)
    ClearString(arg);
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


2.6 Character Transliteration
=============================

[Page 47](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/47/mode/1up)


**translit** is the most complicated program so far in the book.
Most of the translation process from Pascal to Oberon-7 has
remained similar to the previous examples.

My implementation of **translit** diverges from the K & P 
implementation at several points. Much of this is a result of Oberon 
evolution beyond Pascal. First Oberon counts arrays from zero 
instead of one so I have opted to use -1 as a value to indicate the 
index of a character in a string was not found. Equally I have 
simplified the logic in `xindex()` to make it clear how 
I am handling the index lookup described in `index()` of the Pascal 
implementation. K & P implemented `makeset()` and `dodash()`.
`dodash()` particularly looked troublesome. If you came across the 
function name `dodash()` without seeing the code comments 
"doing a dash" seems a little obscure.  I have chosen to name
that process "Expand Sequence" for clarity. I have simplified the 
task of making sets of characters for translation into three cases 
by splitting the test conditions from the actions. First check to see 
if we have an escape sequence and if so handle it. Second check to 
see if we have an expansion sequence and if so handle it else append 
the char found to the end of the set being assembled. This resulted 
in `dodash()` being replaced by `IsSequence()` and 
`ExpandSequence()`.  Likewise `esc()` was replaced with `IsEscape()`
and `ExpandEscape()`. I renamed `addchar()` to `AppendChar()` 
as that seemed more specific and clearer.

I choose to advance the value used when expanding a set description
in the loop inside of my `MakeSet()`. I minimized the side effects 
of the expand functions to the target destination.  It is clearer 
while in the `MakeSet()` loop to see the relationship of the test 
and transformation and how to advance through the string. This also 
allowed me to use fewer parameters to procedures which tends to make 
things more readable as well as simpler.

I have included an additional procedure not included in the K & P 
Pascal of this program. `Error()` displays a string and halts. K & P 
provide this as part of their Pascal environment. I have chosen to 
embed it here because it is short and trivial.

Translit suggested the "Chars" module because of the repetition in 
previous programs. In K & P the approach to code reuse is to create 
a separate source file and to included via a pre-processor. In 
Oberon we have the module concept.

My [Chars](Chars.Mod) module provides a useful set of test procedures
like `IsAlpha(c)`, `IsUpper(c)`, `IsLower()` in addition to the 
`CharInRange()` and `IsAlphaNum()`.  It also includes `AppendChar()` 
which can be used to append a single character value to an end of an 
array of char.


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
    are copies as is. Both the src and dest may contain sub-strings of
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
    Finally, if src is proceeded by ^, then all but the characters
    represented by src are taken as the source string; i.e., they are
    all deleted if dest is absent, or they are all collapsed if the
    last character in dest is present.

EXAMPLE

    To convert upper case to lower:

        translit A-Z a-z

    To discard punctuation and isolate words by spaces on each line:

        translit ^a-zA-Z@n " "
        This is a simple-minded test, i.e., a test of translit.
        This is a simple minded test i e a test of translit

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pascal Source
-------------

[Page 48](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/48/mode/1up)


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ index -- find position of character c in string s }
function index (var s : string; c : character) : integer;
var
    i : integer;
begin
    i := 1;
    while (s[i] <> c) and (s[i] <> ENDSTR) do
        i := i + 1;
    if (s[i] = ENDSTR) then
        index := 0
    else
        index := i
end;

{ xindex -- conditionally invert value from index }
function xindex (var inset : string; c : character;
    allbut : boolean; lastto : integer) : integer;
begin
    if (c = ENDFILE) then
        xindex := 0
    else if (not allbut) then
        xindex := index(inset, c)
    else if (index(inset, c) > 0) then
        xindex := 0
    else
        xindex := lastto + 1
end;

{ translit -- map characters }
procedure translit;
const
    NEGATE = CARET; { ^ }
var
    arg, fromset, toset : string;
    c : character;
    i, lastto : 0..MAXSTR;
    allbut, squash : boolean;
#include "makeset.p"
#include "xindex.p"
begin
    if (not getarg(1, arg, MAXSTR)) then
        error('usage: translit from to');
    allbut := (arg[1] = NEGATE);
    if (allbut) then
        i := 2
    else
        i := 1;
    if (not makeset(arg, i, fromset, MAXSTR)) then
        error('translit: "from" set too large"');
    if (not getarg(2, arg, MAXSTR)) then
        toset[1] := ENDSTR
    else if (not makeset(arg, 1, toset, MAXSTR)) then
        error('translit: "to" set too large')
    else if (Length(fromset) < Length(toset)) then
        error('translit: "from" shorter than "to"');

    lastto := Length(toset);
    squash := (Length(fromset) > lastto) or (allbut);
    repeat
        i := xindex(fromset, getc(c), allbut, lastto);
        if (squash) and (i>=lastto) and (lastto>0) then begin
            putc(toset[lastto]);
            repeat
                i := xindex(fromset, getc(c), allbut, lastto)
            until (i < lastto)
        end;
        if (c <> ENDFILE) then begin
            if (i > 0) and (lastto > 0) then    { translate }
                putc(toset[i])
            else if (i = 0) then                { copy }
                putc(c)
            { else delete }
        end
    until (c = ENDFILE)
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Additional source files
-----------------------

**makeset.p**

[Page 52](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/52/mode/2up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ makeset -- make set from inset[k] in outset }
function makeset (var inset : string; k : integer;
            var outset : string; maxset : integer) : boolean;
var
    j : integer;
#include "dodash.p"
begin
    j := 1
    dodash(ENDSTR, inset, k, outset, j, maxset);
    makeset := addstr(ENDSTR, outset, j, maxset)
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**addstr.p**

[Page 53](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/53/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ addstr -- put c in outset[j] if it fits, increment j }
function addstr(c : character; var outset : string;
            var j : integer; max : integer) : boolean;
begin
    if (j > maxset) then
        addstr := false
    else begin
        outset[j] := c;
        j := j + 1;
        addstr := true
    end
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**dodash.p**

[Page 53](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/53/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{ dodash - expand set at src[i] into dest[j], stop at delimit }
procedure dodash (delim : character; var src : string;
        var i : integer; var dest : string;
        var j : integer; maxset : integer);
var
    k : integer;
    junk : boolean;
begin
    while (arc[i] <> delim) and (src[i] <> ENDSTR) do begin
        if (src[i] = ESCAPE) then
            junk := addstr(esc(src[i], i), dest, j, maxset);
        else if (src[i] <> DASH) then
            junk := addstr(src[i], dest, j, maxset);
        else if (j <= 1) or (src[i+1] = ENDSTR) then
            junk := addstr(DASH, dest, j, maxstr); { literal - }
	else if (isalphanum(src[i-1]))
	    and (isalphanum(src[i+1]))
	    and (src[i-1] <= src[i+1]) then begin
	        for k := src[i-1] + 1 to src[i-1] do
	            junk := addstr(k, dest, j, maxstr);
	        i := i + 1;
	end
	else
	    junk := addstr(DASH, dest, j, maxstr);
	i := i + 1;
    end
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**isalphanum.p**

[Page 54](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/54/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ isalphanum -- true if c is letter or digit }
function isalphanum (c : character) : integer;
begin
    isalphanum := c in [ord('a') .. ord('z'),
                        ord('A') .. ord('Z'),
                        ord('0') .. ord('9')]
end

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**esc.p**

[Page 55](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/55/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ esc -- map s[i] into escape character, increment i }
function esc (var s : string; var i : integer) : character;
begin
    if (s[i] <> ESCAPE) then
        esc := s[i]
    else if (s[i+1] = ENDSTR) then { @ not special ast end }
        esc := ESCAPE
    else begin
        i := i + 1;
        if (s[i] = ord('n')) then
           esc := NEWLINE
        else if (s[i] = ord('t') then
           esc := TAB
        else
           esc := s[i]
    end
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**length.p**

[Page 46](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/46/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ length -- complete length of string }
function length(var s: string) : integer;
var
    n : integer;
begin
    n := 1;
    while (s[n] <> ENDSTR) do
        n := n + 1;
    length := n - 1
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


The impacts of having a richer language than 1980s ISO Pascal and 
evolution in practice suggest a revision in the K & P approach. I 
have attempted to keep the spirit of their example program while 
reflecting changes in practice that have occurred in the last four 
decades.


