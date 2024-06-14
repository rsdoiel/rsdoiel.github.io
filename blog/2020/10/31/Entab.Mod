MODULE Entab;
  IMPORT In, Out, Tabs;

CONST
  NEWLINE = 10;
  TAB = 9;
  BLANK = 32;

PROCEDURE Entab();
VAR
  c : CHAR;
  col, newcol : INTEGER;
  tabstops : Tabs.TabType;
BEGIN
  Tabs.SetTabs(tabstops);
  col := 1;
  REPEAT
    newcol := col;
    In.Char(c);
    IF In.Done THEN (* NOTE: We check that the read was successful! *)
      WHILE (ORD(c) = BLANK) DO
        newcol := newcol + 1;
        IF (Tabs.TabPos(newcol, tabstops)) THEN
          Out.Char(CHR(TAB));
          col := newcol;
        END;
        (* NOTE: Get the next char, check the loop condition
           and either iterate or exit the loop *)
        In.Char(c);
      END;
      WHILE (col < newcol) DO
        Out.Char(CHR(BLANK)); (* output left over blanks *)
        col := col + 1;
      END;
      (* NOTE: Since we may have gotten a new char in the first WHILE
         we need to check again if the read was successful *)
      IF In.Done THEN
        Out.Char(c);
        IF (ORD(c) = NEWLINE) THEN
          col := 1;
        ELSE
          col := col + 1;
        END;
      END;
    END;
  UNTIL In.Done # TRUE;
END Entab;

BEGIN
  Entab();
END Entab.

2.1 Putting Tabs Back
=======================================================

[Page 31](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/31/mode/1up)

Implementing **entab** in Oberon-7 is straight forward.
Like my [Detab](Detab.Mod) implementation I am using
a second modules called [Tabs](Tabs.Mod). This removes
the need for the `#include` macros used in the K & P version.
I have used the same loop structure as K & P this time.
The difference in my `WHILE` loops though is separating the
character read from the `WHILE` conditional test.  This is
something that is common in "C" which can cause issues and
in Oberon-7 doesn't make sense at all. Oberon's `In.Char()`
is not a function returning a value C, it is a procedural
call setting C and exposing state via `In.Done`. I've
chosen to put the next call to `In.Char()` at the bottom
of my `WHILE` loop because it is clear that it is the last
think done before ether iterating again or exiting the loop.
Other than that the Oberon version looks much like the Pascal.

Program Documentation
---------------------

[Page 32](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/32/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

  entab	convert runs of blanks into tabs

USAGE

  entab

FUNCTION

  entab copies its input to its output, replacing strings of
  blanks by tabs so the output is visually the same as the
  input, but contains fewer characters. Tab stops are assumed
  to be set every four columns (i.e. 1, 5, 9, ...), so that
  each sequence of one to four blanks ending on a tab stop
  is replaced by a tab character

EXAMPLE

  Using -> as visible tab:

    entab
      col  1   2   34  rest
    ->col->1->2->34->rest

BUGS

  entab is naive about backspaces, vertical motions, and
  non-printing characters. entab will convert  a single blank
  to a tab if it occurs at a tab stop. The entab is not an
  exact inverse of detab.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pascal Source
-------------

[Page 33](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/33/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{-- entab -- replace blanks by tabs and blanks }
program entab (input, output);
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

prodecure entab;
const
  MAXLINE = 1000; { or whatever }
type
  tabtype = array [1..MAXLINE] of boolean;
var
  c : character;
  col, newcol : integer;
  tabstops : tabtype;
#include "tabpos.p"
#include "settabs.p"
begin
  settabs(tabstops);
  col := 1;
  repeat
    newcol := col;
    while (getc(c) = BLANK) do begin
      newcol := newcol + 1;
      if (tabpos(newcol, tabstops)) then begin
        putc(TAB);
        col := newcol
      end
    end;
    while (col < newcol) do begin
      putc(BLANK);	{output leftover blanks }
      col := col + 1
    end;
    if (c <> ENDFILE) then begin
      putc(c);
      if (c = NEWLINE) then
        col := 1
      else
        col := col + 1
    end
  until (c = ENDFILE)
end;

begin { main program }
  entab;
end.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Supporting Source
-----------------

[Page 25](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/25/mode/1up)


tabpos.p, included by detab.pas
-------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ tabpos -- return true if col is a tab stop }
function tabpos (col: integer; var tabstops : tabtype) : boolean;
begin
    if (col > NEWLINE) then
        tabpos := true;
    else
        tabpos := tabstops[col]
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

settabs.p, included by detab.pas
--------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ settabs -- set initial tab stops }
procedure settabs (var tabstops: tabtype);
const
    TABSPACE = 4; { 4 spaces per tab }
var
    i : integer;
begin
    for i := 1 to MAXLINE do
        tabstops[i] := (i mod TABSPACE = 1)
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
