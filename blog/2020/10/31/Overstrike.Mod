MODULE Overstrike;
IMPORT In, Out;

CONST
  NEWLINE = 10;
  BLANK = 32;
  PLUS = 43;
  BACKSPACE = 8;

PROCEDURE Max(x, y : INTEGER) : INTEGER;
VAR max : INTEGER;
BEGIN
  IF (x > y) THEN
    max := x
  ELSE
    max := y
  END;
  RETURN max
END Max;

PROCEDURE Overstrike;
CONST
  SKIP = BLANK;
  NOSKIP = PLUS;
VAR
  c : CHAR;
  col, newcol, i : INTEGER;
BEGIN
  col := 1;
  REPEAT
    newcol := col;
    In.Char(c);
    (* NOTE We check In.Done on each loop evaluation *)
    WHILE (In.Done = TRUE) & (ORD(c) = BACKSPACE) DO (* eat the backspaces *)
      newcol := Max(newcol, 1);
      In.Char(c);
    END;
    (* NOTE: We check In.Done again, since we may have
       additional reads when eating the backspaces. If
       the previous while loop has taken us to the end of file.
       this will be also mean In.Done = FALSE. *)
    IF In.Done THEN
      IF (newcol < col) THEN
        Out.Char(CHR(NEWLINE)); (* start overstrike line *)
        Out.Char(CHR(NOSKIP));
        FOR i := 0 TO newcol DO
          Out.Char(CHR(BLANK));
        END;
        col := newcol;
      ELSIF (col = 1) THEN (* NOTE: In.Done already check for end of file *)
        Out.Char(CHR(SKIP)); (* normal line *)
      END;
      (* NOTE: In.Done already was checked so we're in mid line *)
      Out.Char(c);    (* normal character *)
      IF (ORD(c) = NEWLINE) THEN
        col := 1
      ELSE
        col := col + 1
      END;
    END;
  UNTIL In.Done # TRUE;
END Overstrike;

BEGIN
  Overstrike();
END Overstrike.

2.2 Overstrikes
===============

[Page 34](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/34/mode/1up)

Overstrike isn't a tool that is useful today but I've included it
simply to be follow along the flow of the K & P book and because
the nature of ASCII reflects some of it's early use. This program
shows how to work with what are normally non-printed characters.

Our module follows K & P design almost verbatim. The differences
are those suggested by differences between Pascal and Oberon-7.
Like in previous examples we don't need to use an ENDFILE constant
as we can simply check the value of `In.Done` to determine
if the last read was successful. This simplifies some of
the `IF/ELSE` logic and the termination of the `REPEAT/UNTIL`
loop.  It makes the `WHILE/DO` loop a little more verbose.

One thing I would like to mention in passing. After eating
the backspaces they is a sequence of `IF/THEN` and `IF/ELSE`
and when you read the K & P code it is ambiguous as they
end on a `ELSE IF ... BEGIN` with a one line statement.
Their style of writing Pascal (and I've seen in this in
K's publications on C) is to not always include block delimiters.
This is a very easy way to introduce errors if you are
modifying someone elses code or, in my case, transcribing
theirs for analysis. Fortunately Prof. Wirth solves this
problem for us. Oberon-7 requires the terminating "END" as
well as using "ELSIF" rather than "ELSE IF ..." where this
can easily become ambiguous for the reader.  In Oberon-7 it
is clear when you have a dangling "IF" statement. This
vintage Pascal, not so much.

K & P do mention the dangling "ELSE" problem later in the text.
Their recommend practice was include the explicit final "ELSE"
continuing the comment to avoid confusion. They just didn't seem
to do it in the **overstrike** program.

#### Limitations

This is documented "BUG" section describes the limitations
well, "**overstrike** is naive about vertical motions and non-printing
characters. It produces one overstruck line for each sequence
of backspaces". But in addition to that most printing devices
these days either have their own drivers or expect to work with
a standard like Postscript. This limited the usefulness of
this program today though controlling character movement in a
"vt100" emulation using old fashion ASCII control codes is
still interesting if only for historical reasons.


Program Documentation
---------------------

[Page 36](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/36/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

  overstrike    replace overstrikes by multiple-lines

USAGE

  overstrike

FUNCTION

  overstrike copies in input to its output, replacing lines
  containing backspaces by multiple lines that overstrike
  to print the same as input, but containing no backspaces.
  It is assumed that the output is to be printed on a device
  that takes the first character of each line as a carriage
  control; a blank carriage control causes normal space before
  print, while a plus sign '+' suppresses space before print
  and hence causes the remainder of the line to overstrike
  the previous line.

EXAMPLE

  Using <- as a visible backspace:

    overstrike
    abc<-<-<-___
     abc
    +___

BUGS

  overstrike is naive about vertical motions and non-printing
  characters. It produces one overstruck line for each sequence
  of backspaces.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pascal Source
-------------

[Page 35](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/35/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ overstrike -- convert backspaces into multiple lines }
program overstrike (input, output);
const
  ENDFILE = -1;
  NEWLINE = 10; { ASCII value }
  BLANK = 32; { ASCII value }
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

{ max -- compute the maximum of two integers }
function max(x, y : integer) : integer;
begin
  if (x > y) then
    max := x
  else
    max := y
end;

{ overstrike -- convert backspaces into multiple lines }
procedure overstrike;
const
  SKIP = BLANK;
  NOSKIP = PLUS;
var
  c : character;
  col, newcol, i : integer;
begin
  col := 1;
  repeat
    newcol := col;
    while (getc(c) = BACKSPACE) do { eat the backspaces }
      newcol := max(newcol-1, 1);
    if (newcol < col) then begin
      putc(NEWLINE); { start overstrike line }
      putc(NOSKIP);
      for i := 1 to newcol - 1 do
        putc(BLANK);
      col := newcol
    end
    else if (col = 1) and (c <> ENDFILE) then
      putc(SKIP); { normal line }
    if (c <> ENDFILE) then begin
      putc(c);    { normal character }
      if (c = NEWLINE) then
        col := 1
      else
        col := col + 1
    end
  until (c = ENDFILE)
end;

begin { main program }
  overstrike();
end.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
