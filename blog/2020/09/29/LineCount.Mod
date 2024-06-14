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
    IF In.Done THEN
      IF (ORD(c) = NEWLINE) THEN
        nl := nl + 1;
      END;
    END;
  UNTIL In.Done # TRUE;
  Out.Int(nl, 1);
  Out.Ln();
END LineCount;

BEGIN
  LineCount();
END LineCount.

===============================================================

PROGRAM

  linecount count lines in input

USAGE

  linecount

FUNCTION

  linecount counts the lines in its input and write the total as a
  line of text to the output.

EXAMPLE

```
  linecount
  A single line of input.
  <ENDFILE>
  **1**
```

===============================================================

{ complete linecount -- count the number of lines in input. }
program linecount (input, output);
const
  ENDFILE = -1;
  NEWLINE = 10; { ASCII value }
type
  character = -1..127 { ASCII, plus ENDFILE }

{ getc -- get one character from standard input }
function getc(var c : character) : character;
var
    ch : char;
begin
    if (eof) then
        c := ENDFILE
    else if (eoln) then begin
        readln;
        c := NEWLINE;
    end
    else begin
        read(ch);
        c := ord(ch)
    end;
    getc := c;
end;

{ putc -- put one character on the standard output }
procedure putc (c : character);
begin
    if (c = NEWLINE) then
        writeln;
    else
        write(chr(c))
end;


{ linecount -- count lines in standard input. }
procedure charcount;
var
  nl : integer;
  c : character;
begin
  nl := 0;
  while (getc(c) <> ENDFILE) do
    if (c = NEWLINE) then
      nl := nl + 1;
  putdec(nc, 1);
  putc(NEWLINE);
end;

begin { main program }
  linecount;
end.
