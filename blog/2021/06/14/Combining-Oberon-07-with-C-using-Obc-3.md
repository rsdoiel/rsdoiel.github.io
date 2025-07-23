---
title: Combining Oberon-07 with C using Obc-3
number: 19
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2021-06-14'
copyright: 'copyright (c) 2021, R. S. Doiel'
keywords:
  - Oberon
  - Obc-3
  - C
  - extArgs
  - extEnv
  - extConvert
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2021
copyrightHolder: R. S. Doiel
abstract: >
  This post explores integrating C code with an Oberon-07 module use

  Mike Spivey's Obc-3 Oberon Compiler.  Last year I wrote a similar post

  for Karl Landström's [OBNC](/blog/2020/05/01/Combining-Oberon-and-C.html).

  This goal of this post is to document how I created a version of Karl's

  Extension Library that would work with Mike's Obc-3 compiler.

  If you want to take a shortcut you can see the results on GitHub

  in my [obc-3-libext](https://github.com/rsdoiel/obc-3-libext) repository.


  From my time with OBNC I've come to rely on three modules from Karl's

  extension library. When trying to port some of my code to use with

  Mike's compiler. That's where I ran into a problem with that dependency.

  Karl's modules aren't available. I needed an
  [extArgs](http://miasap.se/obnc/obncdoc/ext/extArgs.def.html),

  an [extEnv](http://miasap.se/obnc/obncdoc/ext/extEnv.def.html) and

  [extConvert](http://miasap.se/obnc/obncdoc/ext/extConvert.def.html).


  ...
dateCreated: '2021-06-14'
dateModified: '2025-07-22'
datePublished: '2021-06-14'
series: |
  Mostly Oberon
seriesNo: 19
---

Combing Oberon-07 with C using Obc-3
===================================

By R. S. Doiel, 2021-06-14

This post explores integrating C code with an Oberon-07 module use
Mike Spivey's Obc-3 Oberon Compiler.  Last year I wrote a similar post
for Karl Landström's [OBNC](/blog/2020/05/01/Combining-Oberon-and-C.html).
This goal of this post is to document how I created a version of Karl's
Extension Library that would work with Mike's Obc-3 compiler.
If you want to take a shortcut you can see the results on GitHub
in my [obc-3-libext](https://github.com/rsdoiel/obc-3-libext) repository.

From my time with OBNC I've come to rely on three modules from Karl's
extension library. When trying to port some of my code to use with
Mike's compiler. That's where I ran into a problem with that dependency.
Karl's modules aren't available. I needed an [extArgs](http://miasap.se/obnc/obncdoc/ext/extArgs.def.html),
an [extEnv](http://miasap.se/obnc/obncdoc/ext/extEnv.def.html) and
[extConvert](http://miasap.se/obnc/obncdoc/ext/extConvert.def.html).

Mike's own modules that ship with Obc-3 cover allot of common ground
with Karl's. They are organized differently. The trivial solution is
to implement wrapping modules using Mike's modules for implementation.
That takes case of extArgs and extEnv.

The module extConvert is in a another category. Mike's `Conv` module is
significantly minimalist. To solve that case I've create C code to perform
the needed tasks based on Karl's examples and used Mike's share library
compilation instructions to make it available inside his run time.

Background material
-------------------

- [Obc-3 website](https://spivey.oriel.ox.ac.uk/corner/Oxford_Oberon-2_compiler)
    - [Installing Obc-3](https://spivey.oriel.ox.ac.uk/corner/Installing_OBC_release_3.1)
    - [Adding primitives to Obc-3](https://spivey.oriel.ox.ac.uk/corner/How_to_add_primitives_to_OBC), this is how you extend Obc-3 with C
    - [Obc-3.1 Manual](https://spivey.oriel.ox.ac.uk/wiki/images-corner/c/ce/Obcman-3.1.pdf)
- [Obc-3 at GitHub](http://github.com/Spivoxity/obc-3)


Differences: OBNC and Obc-3
---------------------------

The OBNC compiler written by Karl takes the approach of translating
Oberon-07 code to C and then calling the C tool chain to convert that
into a   executable.  Karl's compiler is largely written in C
with some parts written in Oberon.

Mike's takes a different approach. His compiler uses a run time JIT
and is written mostly in OCaml with some C parts and shell scripting.
When you compile an Oberon program (either Oberon-2 or Oberon-07) using
Mike's compiler you get a bunch of "*.k" files that the object code
for Mike's thunder virtual machine and JIT.  This can in turn be used
to create a executable.

For implementing Oberon procedures in C Karl's expects an empty
procedure body. e.g.

```oberon
PROCEDURE DoMyThing();
BEGIN
END DoMyThing;
```

While Mike has added a "IS" phrase to the procedure signature to
indicate what the C implementation is known as. There is no procedure
body in Mike's implementation and the parameters need to map
directly into a C data type.

```oberon
PROCEDURE DoMyThing() IS "do_my_thing";
```

Of course both compilers have completely different command line options
and when you're integrating C shared libraries in Mike's you need to
call your local CC (e.g. GCC, clang) to create a share library file.
Mike has extended Oberon-07 SYSTEM to include `SYSTEM.LOADLIB()` which
takes a string containing the path to the compiler shared library.

In Karl's own Oberon-07 modules he uses the `.obn` file extension but
also accepts `.Mod`.  In Mike's he uses `.m` and also accepts `.Mod`.
In this article I will be using `.m` as that simplified the recipe
of building and integrating the shared C libraries.


Similarities of OBNC and Obc-3
------------------------------

Both compilers provide for compiling Oberon-07 code, Mike's requires
the `-07` option to be used to switch from Oberon-2. Both offer the
ability to extend reach into the host POSIX system by wrapping
C shared libraries. Both run on a wide variety of POSIX systems and
you can read the source code at your leisure. This last bit is
important.

Args, extArgs and extEnv.
-------------------------

Mike provides two features in his Args module. The first is access
to the command line arguments of the compiled program. The
second feature is to provide access to the host environment variables.
In Karl's implementation he separates Mikes `Args.GetEvn()` into
a module called `extEnv`. Here's Mike's module definition looks like ---

```oberon
DEFINITION Args;

VAR argc* : INTEGER; (* this is equavilent to extArgs.count *)

PROCEDURE GetArg*(n: INTEGER; VAR s: ARRAY OF CHAR);

PROCEDURE GetEnv*(name: ARRAY OF CHAR; VAR s: ARRAY OF CHAR);

END Args.
```

My implementation of Karl's `extArgs` needs to look like ---

```oberon
DEFINITION extArgs;

VAR count*: INTEGER; (* this is the same as Args.argc *)

PROCEDURE Get*(n: INTEGER; VAR arg: ARRAY OF CHAR; VAR res: INTEGER);

END extArgs.
```

This leaves us with a very simple module mimicking Karl's.

```oberon
MODULE extArgs;

IMPORT Args;

VAR
  count*: INTEGER;

PROCEDURE Get*(n: INTEGER; VAR arg: ARRAY OF CHAR; VAR res: INTEGER);
BEGIN
  Args.GetArg(n + 1, arg);  res := 0;
END Get;

BEGIN
  count := Args.argc - 1;
END extArgs.
```

NOTE: In Mike's approach the zero-th arg is the program name.
In Karl's the zero-th arg is the first argument after the program
name. To get Karl's behavior with Mike's `GetArg()` I need to
adjust the offsets.

So far so good. How about implementing Karl's `extEnv`?

We've already seen Mike's Args so he doesn't have a matching
definition.  Karl's `extEnv` looks like

```oberon
DEFINITION extEnv;

PROCEDURE Get*(name: ARRAY OF CHAR; VAR value: ARRAY OF CHAR; VAR res: INTEGER);

END extEnv.
```

And again a simple mapping of features and you have

```oberon
MODULE extEnv;

IMPORT Args, Strings;

PROCEDURE Get*(name : ARRAY OF CHAR; VAR value : ARRAY OF CHAR; VAR res : INTEGER);
  VAR i, l1, l2 : INTEGER; val : ARRAY 512 OF CHAR;
BEGIN
  l1 := LEN(value) - 1; (* Allow for trailing 0X *)
  Args.GetEnv(name, val);
  l2 := Strings.Length(val);
  IF l2 <= l1 THEN
    res := 0;
  ELSE
    res := l2 - l1;
  END;
  i := 0;
  WHILE (i < l2) & (val[i] # 0X) DO
      value[i] := val[i];
      INC(i);
  END;
  value[i] := 0X;
END Get;

END extEnv.
```

extConvert requires more work
-----------------------------

Mike provides a module called `Conv.m` for converting numbers
to strings.  It is a little minimal for my current purpose.
That is easy enough to solve as Mike, like Karl provides a means
of extending Oberon code with C.  That means I need to write
`extConvert` as both `extConvert.m` (the Oberon-07 part) and
`extConvert.c` (the C part).

Here's Karl's definition

```oberon
DEFINITION extConvert;

PROCEDURE IntToString*(i: INTEGER; VAR s: ARRAY OF CHAR; VAR done: BOOLEAN);

PROCEDURE RealToString*(x: REAL; VAR s: ARRAY OF CHAR; VAR done: BOOLEAN);

PROCEDURE StringToInt*(s: ARRAY OF CHAR; VAR i: INTEGER; VAR done: BOOLEAN);

PROCEDURE StringToReal*(s: ARRAY OF CHAR; VAR x: REAL; VAR done: BOOLEAN);

END extConvert.
```

I have implement my `extConvert` as a hybrid of Oberon-07 and calls
to a C shared library I will create called `extConvert.c`.

The Oberon file (i.e. extConvert.m)

```oberon
MODULE extConvert;

IMPORT SYSTEM;

PROCEDURE IntToString*(i: INTEGER; VAR s: ARRAY OF CHAR; VAR done: BOOLEAN);
  VAR l : INTEGER;
BEGIN
  l := LEN(s); done := TRUE;
  IntToString0(i, s, l);
END IntToString;

PROCEDURE IntToString0(i : INTEGER; VAR s : ARRAY OF CHAR; l : INTEGER) IS "conv_int_to_string";

PROCEDURE RealToString*(x: REAL; VAR s: ARRAY OF CHAR; VAR done: BOOLEAN);
  VAR l : INTEGER;
BEGIN
  l := LEN(s);
  RealToString0(x, s, l);
END RealToString;

PROCEDURE RealToString0(x: REAL; VAR s: ARRAY OF CHAR; l : INTEGER) IS "conv_real_to_string";

PROCEDURE StringToInt*(s: ARRAY OF CHAR; VAR i: INTEGER; VAR done: BOOLEAN);
BEGIN
  done := TRUE;
  StringToInt0(s, i);
END StringToInt;

PROCEDURE StringToInt0(s : ARRAY OF CHAR; VAR i : INTEGER) IS "conv_string_to_int";

PROCEDURE StringToReal*(s: ARRAY OF CHAR; VAR x: REAL; VAR done: BOOLEAN);
BEGIN
  done := TRUE;
  StringToReal0(s, x);
END StringToReal;

PROCEDURE StringToReal0(s: ARRAY OF CHAR; VAR x : REAL) IS "conv_string_to_real";

BEGIN
  SYSTEM.LOADLIB("./extConvert.so");
END extConvert.
```

If you review Mike's module code you'll see I have followed a similar pattern. Before calling out to C I take care of what house keeping I can in Oberon, then I call a "0" version of the function implemented in C. The C implementation are not exported only the wrapping Oberon procedures are.

Notice how the initialization block calls `SYSTEM.LOADLIB("./extConvert.so");` this loads the C shared library so that the Oberon module can call out it it.

The C code in `extConvert.c` looks very traditional without the macros
you'd see in OBNC's implementation. Here's what the C code look like.

```C
#include <stdlib.h>
#include <stdio.h>

void conv_int_to_string(int i, char *s, int l) {
  snprintf(s, l, "%d", i);
}

void conv_real_to_string(float r, char *s, int l) {
  snprintf(s, l, "%f", r);
}

void conv_real_to_exp_string(float r, char *s, int l) {
  snprintf(s, l, "%e", r);
}

void conv_string_to_int(char *s, int *i) {
    *i = atoi(s);
}

void conv_string_to_real(char *s, float *r) {
    *r = atof(s);
}
```

The dance to compile the module and C shared library is very different
between OBNC and Obc-3.  With Obc-3 we compile and skip linking
the wrapping Oberon module `extConvert.m`. We compile using CC
our C shared library. We can then put it all together to test
everything out in `ConvertTest.m`.

```shell
obc -07 -c extConvert.m
gcc -fPIC -shared extConvert.c -o extConvert.so
```

Our test code program looks like.

```oberon
MODULE ConvertTest;

IMPORT T := Tests, Convert := extConvert;

VAR ts : T.TestSet;

PROCEDURE TestIntConvs() : BOOLEAN;
  VAR test, ok : BOOLEAN;
      expectI, gotI : INTEGER;
      expectS, gotS : ARRAY 128 OF CHAR;
BEGIN test := TRUE;
  gotS[0] := 0X; gotI := 0;
  expectI := 101;
  expectS := "101";

  Convert.StringToInt(expectS, gotI, ok);
  T.ExpectedBool(TRUE, ok, "StringToInt('101', gotI, ok) true", test);
  T.ExpectedInt(expectI, gotI, "StringToInt('101', gotI, ok)", test);

  Convert.IntToString(expectI, gotS, ok);
  T.ExpectedBool(TRUE, ok, "IntToString(101, gotS, ok) true", test);
  T.ExpectedString(expectS, gotS, "IntToString(101, gotS, ok)", test);

  RETURN test
END TestIntConvs;

PROCEDURE TestRealConvs() : BOOLEAN;
  VAR test, ok : BOOLEAN;
      expectR, gotR : REAL;
      expectS, gotS : ARRAY 128 OF CHAR;
BEGIN test := TRUE;
  gotR := 0.0; gotS[0] := 0X;
  expectR := 3.1459;
  expectS := "3.145900";

  Convert.StringToReal(expectS, gotR, ok);
  T.ExpectedBool(TRUE, ok, "StringToReal('3.1459', gotR, ok) true", test);
  T.ExpectedReal(expectR, gotR, "StringToReal('3.1459', gotR, ok)", test);

  Convert.RealToString(expectR, gotS, ok);
  T.ExpectedBool(TRUE, ok, "RealToString(3.1459, gotS; ok) true", test);
  T.ExpectedString(expectS, gotS, "RealToString(3.1459, gotS, ok)", test);

  RETURN test
END TestRealConvs;

BEGIN
  T.Init(ts, "extConvert");
  T.Add(ts, TestIntConvs);
  T.Add(ts, TestRealConvs);
  ASSERT(T.Run(ts));
END ConvertTest.
```

We compile and run our test program use the following commands
(NOTE: Using Obc-3 you list all the dependent modules to possibly
be compiled one the command line along with your program module).

```shell
obc -07 -o converttest extConvert.m Tests.m ConvertTest.m
./converttest
```

Source code for these modules is available on GitHub at
[github.com/rsdoiel/obc-3-libest](https://github.com/rsdoiel/obc-3-libext)


Next & Previous
---------------

- Next [Revisiting Files](../../11/22/Revisiting-Files.html)
- Previous [Beyond Oakwood, Modules and Aliases](../../05/16/Beyond-Oakwood-Modules-and-Aliases.html)