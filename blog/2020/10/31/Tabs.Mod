MODULE Tabs;

CONST
    MAXLINE = 1024; (* or whatever *)

TYPE
    TabType* = ARRAY MAXLINE OF BOOLEAN;

(* TabPos -- return TRUE if col is a tab stop *)
PROCEDURE TabPos*(col : INTEGER; VAR tabstops : TabType) : BOOLEAN;
  VAR res : BOOLEAN;
BEGIN
  res := FALSE; (* Initialize our internal default return value *)
  IF (col >= MAXLINE) THEN
    res := TRUE;
  ELSE
    res := tabstops[col];
  END;
  RETURN res
END TabPos;

(* SetTabs -- set initial tab stops *)
PROCEDURE SetTabs*(VAR tabstops: TabType);
CONST
  TABSPACE = 4; (* 4 spaces per tab *)
VAR
  i : INTEGER;
BEGIN
  (* NOTE: Arrays in Oberon start at zero, we want to
     stop at the last cell *)
  FOR i := 0 TO (MAXLINE - 1) DO
    tabstops[i] := ((i MOD TABSPACE) = 0);
  END;
END SetTabs;

END Tabs.

Tabs Module
===========

This module is used by Detab.Mod and Entab.Mod
and provides for common type definitions and code reuse.

NOTE: We export TabType, TabPos and SetTabs. Everything else
is private to this module.

Pascal Source
-------------

See [Page 25](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/25/mode/1up)


tabpos.p, included by detab.pas
-------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

{ tabpos -- return true if col is a tab stop }
function tabpos (col: integer; var tabstops : tabtype) : boolean;
begin
    if (col > NEWLINE) then
        tabpos := true;
    else
        tabpos := tabstops[col]
end;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

settabs.p, included by detab.pas
--------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
