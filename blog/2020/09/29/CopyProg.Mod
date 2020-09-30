MODULE CopyProg;
IMPORT In, Out;

PROCEDURE copy;
VAR
    c : CHAR;
BEGIN
    REPEAT
        In.Char(c);
        IF In.Done THEN
            Out.Char(c);
        END;
    UNTIL In.Done # TRUE;
END copy;

BEGIN
    copy();
END CopyProg.

===============================================================

PROGRAM

    copy    copy input to output

USAGE

    copy

FUNCTION

    copy copies its input to its output unchanged. It is useful for copying
    from a terminal to a file, from file to file, or even from terminal to
    terminal. It may be used for displaying the contents of a file, without
    interpretation or formatting, by copying from the file to terminal.

EXAMPLE

    To echo lines type at your terminal.

```
    copy
    hello there, are you listening?
    **hello there, are you listening?**
    yes, I am.
    **yes, I am.**
    <ENDFILE>
```

===============================================================


{ complete copy -- to show one possible implementation }
program copyprog (input, output);
const
    ENDFILE = -1;
    NEWLINE = 10; { ASCII value }
type
    character = -1..127; { ASCII, plus ENDFILE }

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

{ copy -- copy input to output }
procedure copy;
var
    c : character;
begin
    while (getc(c) <> ENDFILE) do
        putc(c)
end;

begin { main program }
    copy
end.
