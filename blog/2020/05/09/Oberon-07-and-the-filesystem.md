---
title: Oberon-07 and the file system
series: Mostly Oberon
number: 7
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2020-05-09'
updated: '2021-10-29'
keywords:
  - Oberon
  - programming
copyright: 'copyright (c) 2020, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2020
copyrightHolder: R. S. Doiel
abstract: >+
  This is the seventh post in the [Mostly
  Oberon](../../04/11/Mostly-Oberon.html) series. Mostly Oberon documents my
  exploration of the Oberon Language, Oberon System and the various rabbit holes
  I will inevitably fall into.

dateCreated: '2020-05-09'
dateModified: '2025-07-22'
datePublished: '2020-05-09'
seriesNo: 7
---

# Oberon-07 and the file system

By R. S. Doiel, 2020-05-09 (updated: 2021-10-29)

This is the seventh post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html) series. Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the various rabbit holes I will inevitably fall into.

## Working with files in Oberon-07

In a POSIX system we often talk of opening files,
writing and reading files and close files. The Oberon
language reflects a more Oberon System point of view.

The Oberon System generally avoids modality in favor
of action. Modality is where a context must be set
before a set of actions are possible. The `vi` 
text editor is a "modal" editor. You are in either
edit (typing) mode or command mode. At the function
level POSIX's `open()`, is also modal. You can 
open a file for reading, open a file for writing,
you can open a file for appending, etc. The Oberon
language and base modules avoids modality.

The Oberon System is highly interactive but
has a very different idea about code, data and computer
resources. In POSIX the basic unit of code is a program
and the basic unit of execution is a program. In Oberon
the basic unit of code is the module and the basic unit
of execution is the procedure.  Modules are brought into 
memory and persist. As a result it is common in 
the Oberon System to need to have file representations 
that can persist across procedure calls. It provides
a set of abstractions that are a little bit like views
and cursors found in database systems. In taking
this approach Oberon language eschews modality at the
procedure level. 

NOTE: Modules can be explicitly unload otherwise they persist until the computer is turned off

## Key Oberon Concepts

The following are exported in the `Files` module.

File
: is a handle to the representation of a file, a File and Rider form a view into a file.

Rider
: similar to a database cursor, it is the mechanism that lets you navigate in a file

New
: Creates a new file (in memory but not on disc).

Registration
: Associates a file handle created with New with the file system. A file must be registered to persist in the file system.

Old
: Opens an existing file for use.

Set
: Set the position of a rider in a file

Pos
: Gets the position of a rider in a file

Close
: Writes out unwritten buffers in file to disc, file handle is still value as is the rider.

Purge
: Sets a file's length to zero.

Delete
: Unregister the filename with the file system.

In the Oberon Systems a file can be "opened" many
times with only one copy maintained in memory. This allows
efficient operations across a module's procedures.
Likewise a file can have one or more Riders associated with
it. Each rider can move through the file independently operating on
the common in memory file. If a file is created with `New` but
not registered it can be treated like an in-memory temp file.
Closing a file writes its buffers but the file remains accessible
through it handle and riders. If a file is not modified it
doesn't need to be closed.

In POSIX we generally want to explicitly close the file when
we're through. In the Oberon language we only need to close
a file if we've modified it.

The behavior of files and riders in Oberon creates interesting
nuances around deleting files.  The Delete operation can in
principle happen multiple times before the file is deleted on
disc.  That is because the file handles and riders may still
be operating on it.  To know when a file is finally deleted 
when `Delete` procedure is called it includes a results
parameter. When that value is set to zero by the `Delete`
procedure you know your file has been deleted.

The `Files` module provides a number of methods
to read and write basic Oberon types. These use the rider
rather than the file handle. Calling them automatically
updates the riders position. The procedures themselves
map to what we've seen in the modules `In` and `Out`.  
There are a few additional commands for file system house 
keeping such as `Length`, `GetDate`, `Base`.
See the OBNC documentation for the `Files` module for
details <https://miasap.se/obnc/obncdoc/basic/Files.def.html>.

In the following examples we'll be using the `Files`
module to create, update and delete a file called 
`HelloWorld.txt`.

### Creating a file

The recipe we want to follow for creating a file is
New (creates an empty file in memory), Register
(associations the filename with the file system), 
Set the rider position, with the rider write our
content and with the file call close because we've
have changed the file.

Like our origin `SayingHi` we'll demonstrate this code
in a new module called `TypingHi.Mod`. Below is
a procedure called `WriteHelloWorld`. It shows how
to create, write and close the new file called
"HelloWorld.txt".


~~~

  PROCEDURE WriteHelloWorld;
    VAR
      (* Define a file handle *)
      f : Files.File;
      (* Define a file rider *)
      r : Files.Rider;
  BEGIN
    (* Create our file, New returns a file handle *)
    f := Files.New("HelloWorld.txt");
    (* Register our file with the file system *)
    Files.Register(f);
    (* Set the position of the rider to the beginning *)
    Files.Set(r, f, 0);
    (* Use the rider to write out "Hello World!" *)
    Files.WriteString(r, "Hello World!");
    (* Write a end of line *)
    Files.Write(r, 10);
    (* Close our modified file *)
    Files.Close(f);
  END WriteHelloWorld;

~~~


#### Receipt in review

+ New, creates our file
+ Register, associates the file handle with the file system 
+ Set initializes the rider's position
+ WriteString, writes our "Hello World!" to the file
+ Close, closes the file, flushing unwritten content to disc


### Working with an existing file

If we're working with an existing file we swap `New` for 
a procedure named `Old`. We don't need to register the
file because it already exists.  We still need to set
our rider and we want to read back the string we previously wrote.
We don't need to close it because we haven't
modified it. To demonstrate a new procedure is added to
our module called `ReadHelloWorld`.


~~~

  PROCEDURE ReadHelloWorld;
    VAR
      f : Files.File;
      r : Files.Rider;
      (* We need a string to store what we have read *)
      src : ARRAY 256 OF CHAR;
  BEGIN
    (* Create our file, New returns a file handle *)
    f := Files.Old("HelloWorld.txt");
    (* Set the position of the rider to the beginning *)
    Files.Set(r, f, 0);
    (* Use the rider to write out "Hello World!" *)
    Files.ReadString(r, src);
    (* Check the value we read, if it is not the name, 
       halt the program with an error *)
    ASSERT(src = "Hello World!");
  END ReadHelloWorld;

~~~


#### Receipt in review

+ Old, gets returns a file handle for an existing file
+ Set initializes the rider's position
+ ReadString, read our "Hello World!" string from the file
+ Check the value we read with an ASSERT

### Removing a file

Deleting the file only requires knowing the name of the file.
Like in `ReadHelloWorld` we'll use the built-in ASSERT
procedure to check if the file was successfully removed.


~~~

  PROCEDURE DeleteHelloWorld;
    VAR
      result : INTEGER;
  BEGIN
    (* Delete our file *)
    Files.Delete("HelloWorld.txt", result);
    (* Check our result, if not zero then halt program with error *)
    ASSERT(result = 0);
  END DeleteHelloWorld;

~~~


#### Receipt in review

+ Delete the file setting a result value
+ Check the value with ASSERT to make sure it worked

## Putting it all together.

Here is the full listing of our module.


~~~

    MODULE TypingHi;
      IMPORT Files;
    
      PROCEDURE WriteHelloWorld;
        VAR
          (* Define a file handle *)
          f : Files.File;
          (* Define a file rider *)
          r : Files.Rider;
      BEGIN
        (* Create our file, New returns a file handle *)
        f := Files.New("HelloWorld.txt");
        (* Register our file with the file system *)
        Files.Register(f);
        (* Set the position of the rider to the beginning *)
        Files.Set(r, f, 0);
        (* Use the rider to write out "Hello World!" *)
        Files.WriteString(r, "Hello World!");
        (* Write a end of line *)
        Files.Write(r, 10);
        (* Close our modified file *)
        Files.Close(f);
      END WriteHelloWorld;
    
      PROCEDURE ReadHelloWorld;
        VAR
          f : Files.File;
          r : Files.Rider;
          (* We need a string to store what we have read *)
          src : ARRAY 256 OF CHAR;
      BEGIN
        (* Create our file, New returns a file handle *)
        f := Files.Old("HelloWorld.txt");
        (* Set the position of the rider to the beginning *)
        Files.Set(r, f, 0);
        (* Use the rider to write out "Hello World!" *)
        Files.ReadString(r, src);
        (* Check the value we read, if it is not the name, 
           halt the program with an error *)
        ASSERT(src = "Hello World!");
      END ReadHelloWorld;
    
      PROCEDURE DeleteHelloWorld;
        VAR
          result : INTEGER;
      BEGIN
        (* Delete our file *)
        Files.Delete("HelloWorld.txt", result);
        (* Check our result, if not zero then halt program with error *)
        ASSERT(result = 0);
      END DeleteHelloWorld;
    
    BEGIN
        WriteHelloWorld();
        ReadHelloWorld();
        DeleteHelloWorld();
    END TypingHi.

~~~

## Post Script, 2021-10-29

On October 29, 2021 I had an email conversation with Jules. It pointed out a problem in this implementation of Hello World.  I had incorrectly coded the end of line with `Files.WriteString(r, 0AX);` this is wrong.  At best it should have been `Files.Write(r, 10);`. There remains an issues with `Files.WriteString("Hello World!");`. The Oakwood module `Files` defines "WriteString" to include the trailing NULL character. This will be output in the file. It all depends on how close to the Oakwood specification that your compiler implements the `Files` module.



### Next and Previous

+ Next [Dynamic Types](../25/Dynamic-types.html)
+ Previous [Compiling OBNC on macOS](../06/Compiling-OBNC-on-macOS.html)