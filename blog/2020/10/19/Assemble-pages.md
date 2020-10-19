{
	"title": "Assembling Pages",
	"series": "Mostly Oberon",
	"number": 13,
	"author": "R. S. Doiel",
	"date": "2020-10-19",
	"keywords": [ "Oberon-7", "portable", "markdown", "pandoc", "frontmatter" ],
	"copyright": "copyright (c) 2020, R. S. Doiel",
	"license": "https://creativecommons.org/licenses/by-sa/4.0/"
}

Assembling pages
================

This is the thirteenth post in the [Mostly Oberon](https://rsdoiel.github.io/blog/2020/04/11/Mostly-Oberon.html) series. Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the various rabbit holes I will inevitably fall into.

Pandoc and JSON
---------------

I use [Pandoc](https://pandoc.org) to process Markdown documents. I like to keep my
front matter in JSON rather than Pandoc's YAML. Fortunately Pandoc
does support working with JSON as a metadata file include. Normally I would
manually split the JSON front matter and the rest of the markup into two
separate files, then process with Pandoc and other tooling like
[LunrJS](https://lunrjs.com). [AssemblePage](AssemblePage.Mod) automates this
process.

Example shell usage:

~~~

   AssemblePage MyText.txt \
      metadata=document.json \
      document=document.md
   pandoc --from markdown --to html \
      --metadata-file document.json \
      --standalone \
      document.md >MyText.html

~~~

Source code for **AssemblePage.Mod**
------------------------------------

~~~

MODULE AssemblePage;
  IMPORT Out, Strings, Files, Args := extArgs;

VAR
  srcName, metaName, docName : ARRAY 1024 OF CHAR;

(* FrontMatter takes a "read" Rider, r, and a "write" Rider "w".
If the first character read by r is an opening curly bracket
(the start of the front matter) it writes it out with w, until
it finds a matching closing curly bracket or the file ends. *)
PROCEDURE FrontMatter*(VAR r : Files.Rider; VAR w : Files.Rider);
  VAR c : BYTE; cCnt : INTEGER;
BEGIN
  (* Scan for opening JSON front matter *)
  cCnt := 0;
  REPEAT
    Files.Read(r, c);
    IF r.eof = FALSE THEN
      IF c = ORD("{") THEN
        cCnt := cCnt + 1;
      ELSIF c = ORD("}") THEN
        cCnt := cCnt - 1;
      END;
      Files.Write(w, c);
    END;
  UNTIL (r.eof = TRUE) OR (cCnt = 0);
  IF cCnt # 0 THEN
    Out.String("ERROR: mis matched '{' and '}' in front matter");
    ASSERT(FALSE);
  END;
END FrontMatter;

(* CopyIO copies the characters from a "read" Rider to a "write" Rider *)
PROCEDURE CopyIO*(VAR r : Files.Rider; VAR w: Files.Rider);
  VAR c : BYTE;
BEGIN
  REPEAT
    Files.Read(r, c);
    IF r.eof = FALSE THEN
      Files.Write(w, c);
    END;
  UNTIL r.eof = TRUE;
END CopyIO;

PROCEDURE ProcessParameters(VAR sName, mName, dName : ARRAY OF CHAR);
  VAR
    arg : ARRAY 1024 OF CHAR;
    i, res : INTEGER;
BEGIN
  mName := "document.json";
  dName := "document.txt";
  arg := "";
  FOR i := 0 TO (Args.count - 1) DO
    Args.Get(i, arg, res);
    IF Strings.Pos("metadata=", arg, 0) = 0 THEN
      Strings.Extract(arg, 9, Strings.Length(arg), mName);
    ELSIF Strings.Pos("document=", arg, 0) = 0 THEN
      Strings.Extract(arg, 9, Strings.Length(arg), dName);
    ELSE
      Strings.Extract(arg, 0, Strings.Length(arg), sName);
    END;
  END;
END ProcessParameters;

PROCEDURE AssemblePage(srcName, metaName, docName : ARRAY OF CHAR);
VAR
  src, meta, doc : Files.File;
  reader, writer : Files.Rider;
BEGIN
  src := Files.Old(srcName);
  IF src # NIL THEN
    Files.Set(reader, src, 0);
    IF metaName # "" THEN
      meta := Files.New(metaName);
      Files.Register(meta);
      Files.Set(writer, meta, 0);
      FrontMatter(reader, writer);
      Files.Close(meta);
    END;
    IF docName # "" THEN
      doc := Files.New(docName);
      Files.Register(doc);
      Files.Set(writer, doc, 0);
      CopyIO(reader, writer);
      Files.Close(doc);
    END;
  ELSE
    Out.String("ERROR: Could not read ");Out.String(srcName);Out.Ln();
    ASSERT(FALSE);
  END;
  Files.Close(src);
END AssemblePage;

BEGIN
  ProcessParameters(srcName, metaName, docName);
  AssemblePage(srcName, metaName, docName);
END AssemblePage.

~~~

### Previous

+ Previous [Oberon To Markdown](../../10/03/Oberon-to-markdown.html)
