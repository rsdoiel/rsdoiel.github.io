MODULE WordCount;
IMPORT In, Out;

PROCEDURE WordCount;
CONST
  NEWLINE = 10;
  BLANK = 32;
  TAB = 9;

VAR
  nw : INTEGER;
  c : CHAR;
  inword : BOOLEAN;
BEGIN
  nw := 0;
  inword := FALSE;
  REPEAT
    In.Char(c);
    IF In.Done THEN
      IF ((ORD(c) = BLANK) OR (ORD(c) = NEWLINE) OR (ORD(c) = TAB)) THEN
        inword := FALSE;
      ELSIF (inword = FALSE) THEN
        inword := TRUE;
        nw := nw + 1;
      END;
    END;
  UNTIL In.Done # TRUE;
  Out.Int(nw, 1);
  Out.Ln();
END WordCount;

BEGIN
  WordCount();
END WordCount.

===============================================================

PROGRAM

  wordcount count words in input

USAGE

  wordcount

FUNCTION

  wordcount counts the words in its input and write the total as a
  line of text to the output. A "word" is a maximal sequence of characters
  not containing a blank or tab or newline.

EXAMPLE

```
  wordcount
  A single line of input.
  <ENDFILE>
  **5**
```

BUGS

  The definition of "word" is simplistic.

===============================================================

{ complete wordcount -- count the number of words in input. }
program wordcount (input, output);
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


{ wordcount -- count lines in standard input. }
procedure wordcount;
var
  nw : integer;
  c : character;
  inword : boolean;
begin
  nl := 0;
  inword := false;
  while (getc(c) <> ENDFILE) do
    if (c = BLANK) or (c = NEWLINE) or (c = TAB) then
      inword := false
    else if (not inword) then begin
      inword := true;
      nw := nw + 1
    end;
  putdec(nw, 1);
  putc(NEWLINE);
end;

begin { main program }
  wordcount;
end.
