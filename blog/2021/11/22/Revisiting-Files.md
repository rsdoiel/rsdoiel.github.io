---
title: Revisiting Files
number: 20
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2021-11-12'
copyright: 'copyright (c) 2021, R. S. Doiel'
keywords:
  - Oberon
  - Files
  - plain text
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2021
copyrightHolder: R. S. Doiel
abstract: >
  In October I had an Email exchange with Algojack regarding a buggy example in
  [Oberon-07 and the file
  system](../../../2020/05/09/Oberon-07-and-the-filesystem.html). The serious
  bug was extraneous non-printable characters appearing a plain text file
  containing the string "Hello World". The trouble with the example was a result
  of my misreading the Oakwood guidelines and how **Files.WriteString()** is
  required to work. The **Files.WriteString()** procedure is supposed to write
  every element of a string to a file. This __includes the trailing Null
  character__. The problem for me is **Files.WriteString()** litters plain text
  files with tailing nulls. What I should have done was write my own
  **WriteString()** and **WriteLn()**. The program
  [HelloworldFile](./HelloworldFile.Mod) below is a more appropriate solution to
  writing strings and line endings than relying directly on **Files**. In a
  future post I will explorer making this more generalized in a revised "Fmt"
  module.


  ...
dateCreated: '2021-11-22'
dateModified: '2025-07-22'
datePublished: '2021-11-22'
postPath: 'blog/2021/11/22/Revisiting-Files.md'
series: |
  Mostly Oberon
seriesNo: 20
---

Revisiting Files
================

By R. S. Doiel, 2021-11-22

In October I had an Email exchange with Algojack regarding a buggy example in [Oberon-07 and the file system](../../../2020/05/09/Oberon-07-and-the-filesystem.html). The serious bug was extraneous non-printable characters appearing a plain text file containing the string "Hello World". The trouble with the example was a result of my misreading the Oakwood guidelines and how **Files.WriteString()** is required to work. The **Files.WriteString()** procedure is supposed to write every element of a string to a file. This __includes the trailing Null character__. The problem for me is **Files.WriteString()** litters plain text files with tailing nulls. What I should have done was write my own **WriteString()** and **WriteLn()**. The program [HelloworldFile](./HelloworldFile.Mod) below is a more appropriate solution to writing strings and line endings than relying directly on **Files**. In a future post I will explorer making this more generalized in a revised "Fmt" module.

~~~
MODULE HelloworldFile;

IMPORT Files, Strings;

CONST OberonEOL = 1; UnixEOL = 2; WindowsEOL = 3;

VAR
  (* holds the eol marker type to use in WriteLn() *)
  eolType : INTEGER;
  (* Define a file handle *)
    f : Files.File;
  (* Define a file rider *)
    r : Files.Rider;

PROCEDURE WriteLn(VAR r : Files.Rider);
BEGIN
  IF eolType = WindowsEOL THEN
    (* A DOS/Windows style line ending, LFCR *)
    Files.Write(r, 13);
    Files.Write(r, 10);
  ELSIF eolType = UnixEOL THEN
     (* Linux/macOS style line ending, LF *)
     Files.Write(r, 10);
  ELSE
    (* Oberon, RISC OS style line ending, CR *)
    Files.Write(r, 13);
  END;
END WriteLn;

PROCEDURE WriteString(VAR r : Files.Rider; s : ARRAY OF CHAR);
  VAR i : INTEGER;
BEGIN
  i := 0;
  WHILE i < Strings.Length(s) DO
    Files.Write(r, ORD(s[i]));
    INC(i);
  END;
END WriteString;

BEGIN
  (* Set the desired eol type to use *)
  eolType := UnixEOL;
  (* Create our file, New returns a file handle *)
  f := Files.New("helloworld.txt"); ASSERT(f # NIL);
  (* Register our file with the file system *)
  Files.Register(f);
  (* Set the position of the rider to the beginning *)
  Files.Set(r, f, 0);
  (* Use the rider to write out "Hello World!" followed by a end of line *)
  WriteString(r, "Hello World!");
  WriteLn(r);
  (* Close our modified file *)
  Files.Close(f);
END HelloworldFile.
~~~

I have two new procedures "WriteString" and "WriteLn". These mimic the parameters found in the Files module. The module body is a bit longer.

Compare this to a simple example of "Hello World" using the **Out** module.

~~~
MODULE HelloWorld;

IMPORT Out;

BEGIN
  Out.String("Hello World");
  Out.Ln;
END HelloWorld.
~~~

Look at the difference is in the module body. I need to setup our file and rider as well as pick the type of line ending to use in "WriteLn". The procedures doing the actual work look very similar, "String" versus "WriteString" and "Ln" versus "WriteLn".  


Line ends vary between operating systems. Unix-like systems usually use a line feed. DOS/Windows systems use a carriage return and line feed. Oberon Systems use only a carriage return. If we're going to the trouble of re-creating our "WriteString" and "WriteLn" procedures it also makes sense to handle the different line ending options.  In this case I've chosen to use an INTEGER variable global to the module called "eolType". I have a small set of constants to indicate which line ending is needed. In "WriteLn" I use that value as a guide to which line ending to use with the rider writing to the file.

The reason I chose this approach is because I want my writing procedures to use the same procedure signatures as the "Files" module. In a future post I will explore type conversion and a revised implementation of my "Fmt" module focusing on working with plain text files.

Aside from our file setup and picking an appropriate end of line marker the shape of the two programs look very similar.

References and resources
------------------------

You can see a definition of the [Files](https://miasap.se/obnc/obncdoc/basic/Files.def.html "My example module definition is based on the on Karl created in OBNC") at Karl Landström's documentation for his compiler along with the definitions for [In](https://miasap.se/obnc/obncdoc/basic/In.def.html) and [Out](https://miasap.se/obnc/obncdoc/basic/Out.def.html).


Next & Previous
---------------

- Next [Portable Conversions (Integers)](../../11/26/Portable-Conversions-Integers.html)
- Prev [Combining Oberon-07 with C using Obc-3](../../06/14/Combining-Oberon-07-with-C-using-Obc-3.html)
