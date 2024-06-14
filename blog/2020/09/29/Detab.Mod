MODULE Detab;
  IMPORT In, Out, Tabs;

CONST
  NEWLINE = 10;
  TAB = 9;
  BLANK = 32;

PROCEDURE Detab;
VAR
  c : CHAR;
  col : INTEGER;
  tabstops : Tabs.TabType;
BEGIN
    Tabs.SetTabs(tabstops); (* set initial tab stops *)
    col := 1;
    REPEAT
        In.Char(c);
        IF In.Done THEN
            IF (ORD(c) = TAB) THEN
                REPEAT
                  Out.Char(CHR(BLANK));
                  col := col + 1;
                UNTIL Tabs.TabPos(col, tabstops);
            ELSIF (ORD(c) = NEWLINE) THEN
                Out.Char(c);
                col := 1;
            ELSE
                Out.Char(c);
                col := col + 1;
            END;
        END;
    UNTIL In.Done # TRUE;
END Detab;

BEGIN
  Detab();
END Detab.

K & P, used a pre-processor similar to the C pre-processor to
compensate for the inability of their version of Pascal to
include modules (a.k.a. Units in UCSD and Turbo Pascal).
Oberon-7 addresses this easily with the use of Modules which
happen to be our fundamental unit of code in Oberon-7.
The "Detab" module and later "Entab" will both take advantage of
common type definitions and procedures which we'll put in a module
called "Tabs". This removes the need for preprocessors as
a mechanism of code reuse.

===============================================================

PROGRAM

  detab convert tabs into blanks

USAGE

  detab

FUNCTION

  detab copies its input to its output, expanding the horizontal
  tabs to blanks along the way, so that the output is visually
  the same as the input, but contains no tab characters. Tab stops
  are assumed to be set every four columns (i.e. 1, 5, 9, ...), so
  each tab character is replaced by from one to four blanks.

EXAMPLE

  Usaing "->" as a visible tab:

```
  detab
  ->col  1->2->34->rest
      col  1   34   rest
```

BUGS

  detab is naive about backspaces, vertical motions, and
  non-printing characters.

===============================================================

{ complete detab -- converts tabs into blanks. }
program detab (input, output);
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

procedure detab;
const
    MAXLINE = 1000; { or whatever }
type
    tabtype = array {1..MAXLINE} of boolean;
var
    c : character;
    col : integer;
    tabstops : tabtype;
#include "tabpos.p";
#include "settabs.p";
begin
    settabs(tabstops); { set initial tab stops }
    col := 1;
    while (getc(c) <> ENDFILE) do
        if (c = TAB) then
            repeat
                putc(BLANK);
                col := col + 1;
            until (tabpos(col, tabstops))
        else if (c = NEWLINE) then begin
            putc(NEWLINE);
            col := 1;
        end
        else begin
            putc(c);
            col := + 1;
        end
end;

begin { main program }
  detab;
end.

=======================================================
tabpos.p, included by detab.pas
-------------------------------------------------------
{ tabpos -- return true if col is a tab stop }
function tabpos (col: integer; var tabstops : tabtype) : boolean;
begin
    if (col > NEWLINE) then
        tabpos := true;
    else
        tabpos := tabstops[col]
end;
=========================================================
settabs.p, included by detab.pas
---------------------------------------------------------
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

