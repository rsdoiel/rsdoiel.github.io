MODULE Echo;
IMPORT Out, Args := extArgs;

CONST
    MAXSTR = 1024; (* or whatever *)
    BLANK = " ";

(* Echo -- echo command line arguments to output *)
PROCEDURE Echo();
VAR
    i, res : INTEGER;
    argstr : ARRAY MAXSTR OF CHAR;
BEGIN
    i := 0;
    FOR i := 0 TO (Args.count - 1) DO
        Args.Get(i, argstr, res);
        IF (i > 0) THEN
            Out.Char(BLANK);
        END;
        Out.String(argstr);
    END;
    IF Args.count > 0 THEN
        Out.Ln();
    END;
END Echo;

BEGIN
    Echo();
END Echo.

2.5 Command Arguments
=====================

[Page 44](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/44/mode/1up)

Program Documentation
---------------------

[Page 45](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/45/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

    echo    echo arguments to output

USAGE

    echo [ argument ... ]

FUNCTION

    echo copies its command line arguments to its output as a line
    of text with one space
    between each argument. IF there are no arguments, no output is
    produced.

EXAMPLE

    To see if your system is alive:

        echo hello world!
        hello world!

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Pascal Source
-------------

[Page 46](https://archive.org/stream/softwaretoolsinp00kern?ref=ol#page/46/mode/1up)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

const
    MAXSTR = 1024 (* or whatever *)

type
    string = array [1..MAXSTR] of CHAR;

(* echo -- echo command line arguments to output *)
procedure echo;
var
    i, j : INTEGER;
    argstr : string;
BEGIN
    i := 1
    WHILE (getarg(i, argstr, MAXSTR)) DO BEGIN
        if (i > 1) then
            putc(BLANK);
        for j := 1 to length(argstr) DO
            putc(argstr[j]);
        i := i + 1
    END;
    if (i > 1) then
        putc(NEWLINE);
END;

(* length -- compute length  of string *)
function length (var s : string) : INTEGER;
var
    n : INTEGER;
BEGIN
    n := 1;
    WHILE (s[n] <> ENDSTR) DO
        n := n + 1
    length := n - 1
END;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
