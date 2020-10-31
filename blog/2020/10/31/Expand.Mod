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

2.4 Text Expansion
==================

[Page 41](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/41/mode/1up)

Our procedures map closely to the original Pascal with some significant
differences.  As previously I've chosen a `REPEAT ... UNTIL` loop structure
because we're always attempting to read at least once. The `IF THEN ELSIF ELSE`
logic is a little different. In the K & P version they combine retrieving
a character and testing its value.  This is a style common in languages
like C. I've chosen to split the read of the character from the test. I've
done this for several reasons. First, Oberon `In` module reads a char as
a procedure that updates the value passed in the parameter. This means we
can't retrieve the value and test in one statement but I also feel that
retrieving the value, then testing is a simple statement to read. This
does change how you're structuring inner and outer `IF` statements.



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

Pascal Source
-------------

[Page 42](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/42/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ expand -- uncompress standard input }
procedure expand;
const
    WARNING = TILDE;    { ~ }
var
    c : character;
    n : integer;
begin
    while (getc(c) <> ENDFILE) do
        if (c <> WARNING) then
            putc(c)
        else if (isupper(getc(c))) then begin
            n := c - ord('A') + 1;
            if (getc(c) <> ENDFILE) then
                for n := n downto 1 do
                    putc(c)
            else begin
                putc(WARNING);
                putc(n - 1 + ord('A'))
            end
        end
        else begin
            putc(WARNING)
            if (c <> ENDFILE) then
                putc(c)
        end
end;

{ isupper -- true if c is upper case letter }
function isupper (c : character) : boolean;
begin
    isupper := c in [ord('A')..ord('Z')]
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
