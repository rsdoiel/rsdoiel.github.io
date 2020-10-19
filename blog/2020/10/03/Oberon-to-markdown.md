{
	"title": "Oberon to Markdown",
	"series": "Mostly Oberon",
	"number": 12,
	"author": "R. S. Doiel",
	"date": "2020-10-03",
	"keywords": [ "Oberon-7", "portable", "markdown" ],
	"copyright": "copyright (c) 2020, R. S. Doiel",
	"license": "https://creativecommons.org/licenses/by-sa/4.0/"
}

Oberon to Markdown
==================

This is the twelfth post in the [Mostly Oberon](https://rsdoiel.github.io/blog/2020/04/11/Mostly-Oberon.html) series. Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the various rabbit holes I will inevitably fall into.

A nice feature of Oberon
------------------------

Oberon source code has a very nice property in that anything
after the closing end statement is ignored by the compiler.
This makes it a nice place to write documentation, program
notes and other ideas.

I've gotten in the habit of writing up program docs and
notes there. When I prep to make a web document I used to
copy the source file, doing a cut and paste to re-order
the module code to the bottom of the document. I'd follow
that with adding headers and code fences. Not hard but
tedious. Of course if I changed the source code I'd also
have to do another cut and paste edit. This program,
`ObnToMd.Mod` automates that process.

Program Documentation
---------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PROGRAM

  ObnToMd

FUNCTION

  This is a simple program that reads Oberon modules
  from standard in and re-renders that to standard output
  such that it is suitable to process with Pandoc or other
  text processing system.

EXAMPLE

  Read the source for this program and render a file
  called "blog-post.md". Use Pandoc to render HTML.

    ObnToMd <ObnToMd.Mod > blog-post.md
    pandoc -s --metadata title="Blog Post" \
        blog-post.md >blog-post.html

BUGS

  It uses a naive line analysis to identify the module
  name and then the end of module statement. Might be
  tripped up by comments containing the same strings.
  The temporary file created is called "o2m.tmp" and
  this filename could potentially conflict with another
  file.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




Source code for **ObnToMd.Mod**
-------------------------------

~~~

(* ObnToMd.Mod - an simple filter process for reading
an Oberon-7 module source file and rendering a markdown
friendly output suitable for piping into Pandoc. The
filter reads from standard input and writes to standard
output and makes use of a temp file name o2m.tmp which
it removes after successful rendering.

@Author R. S. Doiel, <rsdoiel@gmail.com>
copyright (c) 2020, all rights reserved.
Released under the BSD 2-clause license
See: https://opensource.org/licenses/BSD-2-Clause
*)
MODULE ObnToMd;
  IMPORT In, Out, Files, Strings;

CONST
  MAXLENGTH = 1024;
  LF = CHR(10);

VAR
  endOfLine : ARRAY 2 OF CHAR;

(*
 * Helper methods
 *)
PROCEDURE GenTempName(prefix, suffix : ARRAY OF CHAR; VAR name : ARRAY OF CHAR);
BEGIN
  name := "";
  Strings.Append(prefix, name);
  Strings.Append(".", name);
  Strings.Append(suffix, name);
END GenTempName;

PROCEDURE GenTempFile(name : ARRAY OF CHAR; VAR r : Files.Rider; VAR f : Files.File);
BEGIN
  f := Files.New(name);
  IF f = NIL THEN
    Out.String("ERROR: can't create ");Out.String(name);Out.Ln();
    ASSERT(FALSE);
  END;
  Files.Register(f);
  Files.Set(r, f, 0);
END GenTempFile;


PROCEDURE StartsWith(target, source : ARRAY OF CHAR) : BOOLEAN;
  VAR res : BOOLEAN;
BEGIN
  IF Strings.Pos(target, source, 0) > -1 THEN
    res := TRUE;
  ELSE
    res := FALSE;
  END;
  RETURN res
END StartsWith;

PROCEDURE ClearString(VAR s : ARRAY OF CHAR);
  VAR i : INTEGER;
BEGIN
  FOR i := 0 TO LEN(s) - 1 DO
    s[i] := 0X;
  END;
END ClearString;


PROCEDURE ProcessModuleDef(VAR r : Files.Rider; VAR modName : ARRAY OF CHAR);
  VAR
    line, endStmt : ARRAY MAXLENGTH OF CHAR;
    start, end : INTEGER;
BEGIN
  line := "";
  endStmt := "";
  modName := "";
  (* Find the name of the module and calc the "END {NAME}." statement *)
  REPEAT
    ClearString(line);
    In.Line(line);
    IF In.Done THEN
      Files.WriteString(r, line); Files.WriteString(r, endOfLine);
      (* When `MODULE {NAME};` is encountered extract the module name *)
      IF StartsWith("MODULE ", line) THEN
        start := 7;
        end := Strings.Pos(";", line, 0);
        IF (end > -1) & (end > start) THEN
            Strings.Extract(line, start, end - start, modName);
            endStmt := "END ";
            Strings.Append(modName, endStmt);
            Strings.Append(".", endStmt);
        END;
      END;
    END;
  UNTIL (In.Done # TRUE) OR (endStmt # "");

  (* When `END {NAME}.` is encountered  stop writing tmp file *)
  REPEAT
    In.Line(line);
    IF In.Done THEN
      Files.WriteString(r, line); Files.WriteString(r, endOfLine);
    END;
  UNTIL (In.Done # TRUE) OR StartsWith(endStmt, line);
END ProcessModuleDef;

PROCEDURE WriteModuleDef(name : ARRAY OF CHAR; VAR r : Files.Rider; VAR f : Files.File);
  VAR s : ARRAY MAXLENGTH OF CHAR; res : INTEGER;
BEGIN
  Files.Set(r, f, 0);
  REPEAT
    Files.ReadString(r, s);
    IF r.eof # TRUE THEN
      Out.String(s);
    END;
  UNTIL r.eof;
  Files.Close(f);
  Files.Delete(name, res);
END WriteModuleDef;


PROCEDURE OberonToMarkdown();
VAR
  tmpName, modName, line : ARRAY MAXLENGTH OF CHAR;
  f : Files.File;
  r : Files.Rider;
  i : INTEGER;
BEGIN
  tmpName := ""; modName := "";  line := "";
  (* Open temp file *)
  GenTempName("o2m", "tmp", tmpName);
  GenTempFile(tmpName, r, f);

  (* Read the Oberon source from standard input echo the lines tmp file *)
  ProcessModuleDef(r, modName);

  (* Write remainder of file to standard out *)
  REPEAT
    In.Line(line);
    IF In.Done THEN
      Out.String(line);Out.Ln();
    END;
  UNTIL In.Done # TRUE;

  (* Write two new lines *)
  Out.Ln(); Out.Ln();
  (* Write heading `Source code for {NAME}` *)
  ClearString(line);
  line := "Source code for **";
  Strings.Append(modName, line);
  Strings.Append(".Mod**", line);
  Out.String(line); Out.Ln();
  FOR i := 0 TO Strings.Length(line) - 1 DO
    Out.String("-");
  END;
  Out.Ln();
  (* Write code fence *)
  Out.Ln();Out.String("~~~");Out.Ln();
  (* Reset rider to top of tmp file
     Write temp file to standard out
     cleanup demp file *)
  WriteModuleDef(tmpName, r, f);
  (* Write code fence *)
  Out.Ln();Out.String("~~~");Out.Ln();
  (* Write tailing line and exit procedure *)
  Out.Ln();
END OberonToMarkdown;

BEGIN
  endOfLine[0] := LF;
  endOfLine[1] := 0X;
  OberonToMarkdown();
END ObnToMd.

~~~

### Next, Previous

+ Next [Assembling Pages](../../10/19/Assemble-pages.html)
+ Previous [Portable Oberon 7](../../08/15/Portable-Oberon-7.html)
