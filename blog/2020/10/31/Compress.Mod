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

2.3 Text Compression
====================

[Page 37](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/37/mode/1up)

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

Pascal Source
-------------

[Page 39](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/39/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ compress -- compress standard input }
procedure compress;
const
    WARNING = TILDE;    { ~ }
var
    c, lastc : character;
    n : integer;
#include "putrep.p"
begin
    n := 1;
    lastc := getc(lastc);
    while (lastc <> ENDFILE) do begin
        if (getc(c) = ENDFILE) then begin
            if (n > 1) or (lastc = WARNING) then
                putrep(n, lastc)
            else
                putc(lastc)
        end
        else if (c = lastc) then
            n := n + 1
        else if (n > 1) or (lastc = WARNING) then begin
            putrep(n, lastc);
            n := 1
        end
        else
            putc(lastc)
        lastc := c
    end
end;

{ putrep -- put out representation of run of n 'c's }
procedure petrep (n : integer; c : character);
const
    MAXREP = 26;    { assuming 'A' .. 'Z' }
    THRESH = 4;
begin
    while (n >= THRESH) or ((c = WARNING) and (n > 0)) do begin
        putc(WARNING);
        putc(min(n, MAXREP) - 1 + ord('a'));
        putc(c);
        n := n - MAXREP
    end;
    for n := n downto 1 do
        putc(c)
end;

{ min -- compute minimum of two integers }
function min(x, y : integer) : integer;
begin
    if (x < y) then
        min := x
    else
        min := y
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


