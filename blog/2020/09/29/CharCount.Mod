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

===============================================================

PROGRAM

  charcount count characters in input

USAGE

  charcount

FUNCTION

  charcount counts the characters in its input and writes the total
  as a single line of text to the output. Since each line of text is
  internally delimited by a NEWLINE character, the total count is the
  number of lines plus the number of characters within each line.

EXAMPLE

```
  charcount
  A single line of input.
  <ENDFILE>
  **24**
```

===============================================================

{ complete charcount -- count the number of chars in a file. }
program charcount (input, output);
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


{ charcount -- count characters in standard input. }
procedure charcount;
var
  nc : integer;
  c : character;
begin
  nc := 0;
  while (getc(c) <> ENDFILE) do
    nc := nc + 1;
  putdec(nc, 1);
  putc(NEWLINE);
end;

begin { main program }
  charcount;
end.
