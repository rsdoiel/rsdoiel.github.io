---
title: Dynamic types
series: Mostly Oberon
number: 8
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2020-05-25'
keywords:
  - Oberon
  - programming
  - type extension
  - dynamic data
copyright: 'copyright (c) 2020, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2020
copyrightHolder: R. S. Doiel
abstract: |
  This is the eighth post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html)
  series. Mostly Oberon documents my exploration of the Oberon Language, 
  Oberon System and the various rabbit holes I will inevitably fall into.

  ## Dynamic Types in Oberon

  Oberon-07 is a succinct systems language. It provides a minimal
  but useful set of basic static types. Relying on them addresses 
  many common programming needs. The Oberon compiler ensures 
  static types are efficiently allocated in memory. One of the 
  strengths of Oberon is this ability to extend the type system. 
  This means when the basic types fall short you can take 
  advantage of Oberon's type  extension features. This includes 
  creating dynamically allocated data structures. In Oberon-07 
  combining Oberon's `POINTER TO` and `RECORD` types allows us to
  create complex and dynamic data structures. 

  ...
dateCreated: '2020-05-25'
dateModified: '2025-07-22'
datePublished: '2020-05-25'
seriesNo: 8
---

# Dynamic types

By R. S. Doiel, 2020-05-25

This is the eighth post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html)
series. Mostly Oberon documents my exploration of the Oberon Language, 
Oberon System and the various rabbit holes I will inevitably fall into.

## Dynamic Types in Oberon

Oberon-07 is a succinct systems language. It provides a minimal
but useful set of basic static types. Relying on them addresses 
many common programming needs. The Oberon compiler ensures 
static types are efficiently allocated in memory. One of the 
strengths of Oberon is this ability to extend the type system. 
This means when the basic types fall short you can take 
advantage of Oberon's type  extension features. This includes 
creating dynamically allocated data structures. In Oberon-07 
combining Oberon's `POINTER TO` and `RECORD` types allows us to
create complex and dynamic data structures. 


## An example, dynamic strings 

Strings in Oberon-07 are typical declared as an `ARRAY OF CHAR` 
with a specific length. If the length of a string is not 
known a head of time this presents a challenge. One approach is 
to declare a long array but that would allocate allot of memory 
which may not get used. Another approach is to create a dynamic
data structure. An example is using a linked list of shorter 
`ARRAY OF CHAR`.  The small fixed strings can combine to 
represent much larger strings. When one fills up we add 
another. 

### Pointers and records, an Oberon idiom 

Our data model is a pointer to a record where the record 
contains an `ARRAY OF CHAR` and a pointer to the next record. 
A common idiom in Oberon for dynamic types is to declare a 
`POINTER TO` type and declare a `RECORD` type which contains
the `POINTER TO` type as an attribute.  If you see this idiom 
you are looking at some sort of dynamic data structure. The 
pointer type is usually named for the dynamic type you want 
work with and the record type is declared using the same name 
with a "Desc" suffix. In our case `DynamicString` will be the 
name of our `POINTER TO` type and our record type will be 
called `DynamicStringDesc` following the convention.  In our 
record structure we include a "value" to holding a short 
fixed length `ARRAY OF CHAR`  and a "next" to holding the 
pointer to our next record.

In our record the value is declared as a static type. We need
to know how long our "short" string should be? I.e. What length
is our `ARRAY OF CHAR`? It's a question of tuning. If it is too 
short we spend more time allocating new records, too long and 
we are wasting memory in each record. A way to make tuning a 
little simpler is to use a constant value to describe our array 
length. Then if we decide our array is too big 
or too small we can adjust the constant knowing that our record 
structure and the procedures that use that the length 
information will continue to work correctly. 

Let's take a look at actual code (NOTE: vSize is our constant value). 

~~~

    CONST
      vSize = 128; 
    
    TYPE
      DynamicString* = POINTER TO DynamicStringDesc;
      DynamicStringDesc* = RECORD 
        value : ARRAY vSize OF CHAR; 
        next : DymamicString; 
      END;

~~~

NOTE: Both `DynamicString` and `DynamicStringDesc` are defined 
using an `*`. These are public and will be available 
to other modules.  Inside our record `DynamicStringDesc` we 
have two private to our module attributes, `.value` and 
`.next`. They are private so that we can change our 
implementation in the future without requiring changes in 
modules that use our dynamic strings. Likewise our constant `vSize`
is private as that is an internal implementation detail. This
practice is called information hiding.

NOTE: The asterisk in Oberon decorates procedures, types, variables
and constants that are "public" to other modules.

NOTE: Variables are always exported read only.

NOTE: With information hiding some details of implementation allow us 
to keep a clean division between implementation inside the module and how
that implementation might be used. With out information hiding we often
have "leaky" abstractions that become brittle and hard to maintain and
rely on.



## Working with DynamicString

Our type definitions describe to the compiler how to layout our 
data in memory. The type system in Oberon-07 also ensures that 
access to that memory is restricted to assignments, operations 
and procedures compatible with that type. To be useful from 
other modules we need a few procedures to help work with
this new data type. What follows is a minimal set needed to be 
useful.

### `New*(VAR str : DynamicString)`

`New` will initialize a DynamicString object setting `.value` to 
an empty string. 


~~~

  PROCEDURE New*(VAR str : DynamicString);
  BEGIN NEW(str);
    str.value := ""; 
    str.next := NIL;
  END New;

~~~


### `Set*(VAR str : DynamicString; source : ARRAY OF CHAR)` 

`Set` copies an `ARRAY OF CHAR` into an existing DynamicString. 
This requires that we add and link additional records if the 
`source` is longer than our current dynamic string. Set is a 
bridge procedure between an existing datatype, `ARRAY OF CHAR` 
and our new data type, `DynamicString`.


~~~

  PROCEDURE Set*(VAR str : DynamicString; source : ARRAY OF CHAR); 
    VAR cur, next : DynamicString; tmp : ARRAY vSize OF CHAR; 
        i, l : INTEGER;
  BEGIN cur := str; cur.value := "";
    l := Strings.Length(source);
    i := 0; 
    WHILE i < l DO
      Strings.Extract(source, i, i + vSize, tmp);
      Strings.Append(tmp, cur.value);
      i := i + Strings.Length(tmp);
      IF (i < l) THEN
        IF cur.next = NIL THEN
          New(next); cur.next := next;
        END;
        cur := cur.next;
      END; 
    END;
  END Set;

~~~

### `ToCharArray*(str : DynamicString; VAR dest : ARRAY OF CHAR; VAR ok : BOOLEAN)`

`ToCharArray` copies the contents of our dynamic string into an array 
of char setting `ok` to TRUE on success or FALSE if truncated. 
Like `Set*` it is a bridge procedure to let us move data output 
our new dynamic string type.


~~~

  PROCEDURE ToCharArray*(str : DynamicString; 
                         VAR dest : ARRAY OF CHAR; 
                         VAR ok : BOOLEAN);
    VAR cur : DynamicString; i : INTEGER;
  BEGIN 
    ok := FALSE;
    cur := str; i := 0;
    WHILE cur # NIL DO
      i := i + Strings.Length(cur.value);
      Strings.Append(cur.value, dest);
      cur := cur.next;
    END;
    ok := (i = Strings.Length(dest));
  END ToCharArray;

~~~

Two additional procedures will likely be needed-- `Append` and 
`AppendCharArray`. This first one is trivial, if we want to add 
one dynamic string onto another all we need to do is link the 
last record of the first and point it to a copy of the second string we're appending.


### `Append*(extra : DynamicString; VAR dest : DynamicString);`

`Append` adds the `extra` dynamic string to `dest` dynamic string. Our 
"input" is `extra` and our output is a modified dynamic string 
named `dest`. This parameter order mimics the standard 
`Strings` module's `Append`.

NOTE: Oberon idiom is often input values, modified value and 
result values. Modified and result values are declared in the parameter
definition using `VAR`.

Algorithm:

1. Move to the end of `dest` dynamic string
2. Create a new record at `cur.next`.
3. Copy `extra.value` info.value `cur.next.value`
4. Advance `extra` and `cur`, repeating steps 2 to 4 as needed.

Implemented procedure.

~~~

  PROCEDURE Append*(extra: DynamicString; VAR dest : DynamicString);
    VAR cur : DynamicString;  
  BEGIN
    (* Move to the end of the dest DynamicString *)
    cur := dest;
    WHILE cur.next # NIL DO cur := cur.next; END;
    (* Starting initial pointer of `extra` copy its records
       input new records created in `cur`. *)
    WHILE extra # NIL DO
      (* Create a new record *)
      NEW(cur.next);
      cur.next.value := "";
      cur.next.next := NIL;
      (* Copy extra.value into new record *)
      Strings.Extract(extra.value, 0, vSize, cur.next.value);
      (* Advance to next record for both cur and extra *)
      extra := extra.next;
      cur := cur.next;
    END;
  END Append;

~~~

A second procedure for appending an `ARRAY OF CHAR` also 
becomes trivial. First convert the `ARRAY OF CHAR` to a dynamic 
string then append it with the previous procedure.

### `AppendCharArray*(src : ARRAY OF CHAR; VAR str : DynamicString);`

This procedure appends an ARRAY OF CHAR to an existing dynamic string.

~~~

  PROCEDURE AppendCharArray*(extra: ARRAY OF CHAR; VAR dest : DynamicString);
    VAR extraStr : DynamicString;    
  BEGIN
    (* Convert our extra ARRAY OF CHAR into a DynamicString *)
    New(extraStr); Set(extraStr, extra);
    (* Now we can append. *)
    Append(extraStr, dest);
  END AppendCharArray;

~~~

At some point we will want to know the length of our dynamic string.

### `Length(str : DynamicString) : INTEGER`

Our `Length` needs to go through our linked list and total up 
the length of each value. We will use a variable called `cur` 
to point at the current record and add up our total length as 
we walk through the list.

~~~

  PROCEDURE Length*( source : DynamicString) : INTEGER;
    VAR cur : DynamicString; total : INTEGER;
  BEGIN
    total := 0;
    cur := source;
    WHILE cur # NIL DO
      total := total + Strings.Length(cur.value);
      cur := cur.next;
    END; 
    RETURN total
  END Length;

~~~

## Extending DynamicStrings module

With these few procedures we have a basic means of working with 
dynamic strings. Moving beyond this we can look at the standard 
Oberon `Strings` module for inspiration.  If we use similar 
procedure signatures we can create a drop in replacement 
for `Strings` with `DynamicStrings`.

NOTE: Procedure signatures refer to procedures type along 
with the order and types of parameters. A quick review of the 
procedure signatures for the standard module [Strings](https://miasap.se/obnc/obncdoc/basic/Strings.def.html) is 
provided by the [OBNC](https://miasap.se/obnc) compiler docs. 

Let's look at recreating `Insert` as a potential guide to
a more fully featured ["DynamicStrings.Mod"](DynamicStrings.Mod). 
In our `Insert` we modify the procedure signature so the 
source and destinations are dynamic strings.


### `Insert(source : DynamicString; pos : INTEGER; VAR dest : DynamicString)`

The `Insert` procedure inserts a `source` dynamic string at the 
position provided into our `dest` dynamic string. We are implementing
the same signature  for our `DynamicStrings.Insert()` as 
`Strings.Insert()`. Only the parameters for source and destination
are changed to `DynamicString`.

Internally our procedure for `Insert` is a more complicated than
the ones we've written so far. It needs to do all the housing 
keeping for making sure we add the right content in the correct
spot.  The general idea is to find the record holding the split 
point. Split that record into two records. The first retains 
the characters before the insert position. The second holds the 
characters after the insert position and points to next record 
in the dynamic string. Once the split is accomplished it then 
is a matter of linking everything up. The record before the 
insert position is set to point at the dynamic string to be 
inserted, the inserted dynamic string is set to point at the 
record that contained the rest of the characters after the 
split.

It is easy to extract a sub-string from an `ARRAY OF CHAR` 
using the standard `Strings` module.  We can store the characters
in the `.value` of the record after the split in a temporary 
`ARRAY OF CHAR`.  The temporary `ARRAY OF CHAR` can be used to 
create a new dynamic string record which will be linked to the 
rest of our destination dynamic string. The record which held 
the characters before the insert position needs to be truncated 
and it needs to be linked to the dynamic string we want to 
insert. NOTE: This will leave a small amount of unused 
memory.

NOTE: If conserving memory is critical then re-packing the 
dynamic string could be implemented as another procedure. The 
cost would be complexity and time to shift characters between 
later records and earlier ones replacing excess NULL values.

We need to find the record where the split will occur. In the 
record to be split we need to calculate a relative 
split point. We then can copy the excess characters in that 
split record to a new record and truncate the `.value`'s 
`ARRAY OF CHAR` to create our split point. Truncating is easy 
in that we replace the CHAR in the `.values` that are not 
needed with a NULL character. We can do that with a 
simple loop. Likewise calculating the relative insertion 
position can be done by taking the modulo of the `vSize` of 
`.value`.

NOTE: In Oberon stings are terminated with a NULL 
character. A NULL character holds the ASCII value `0X`.

Our algorithm:

1. Set `cur` to point to the start of our destination dynamic string
2. Move `cur` to the record in the link list where the insertion will take place
3. Calculate the relative split point in `cur.value`
4. Copy the characters in `cur.value` from relative split point to end of `.value` into a temporary `ARRAY OF CHAR`
5. Make a new record, `rest`, using the temporary `ARRAY OF CHAR` and update the value of `.next` to match that of `cur.next`
6. Truncate the record (cur) at the relative split point
7. Set `cur.next` to point to our `extra` dynamic string.
8. Move to the end of extra with `cur`
9. Set the `cur.next` to point at `rest`

Our procedure:

~~~

  PROCEDURE Insert*(extra : DynamicString; 
                    pos : INTEGER; 
                    VAR dest : DynamicString);
    VAR cur, rest : DynamicString;
        tmp : ARRAY vSize OF CHAR;
        i, splitPos : INTEGER; continue : BOOLEAN;
  BEGIN
    (* 1. Set `cur` to the start of our `dest` dynamic string *)
    cur := dest;

    (* 2. Move to the record which holds the split point *)
    i := 0;
    continue := (i < pos);
    WHILE continue DO
      i := i + Strings.Length(cur.value);
      continue := (i < pos);
      IF continue & (cur.next # NIL) THEN
        cur := cur.next;
      ELSE
        continue := FALSE;
      END;
    END;

    (* 3. Copy the characters in `cur.value` from relative
          split point to end of `.value` into a 
          temporary `ARRAY OF CHAR` *)
    splitPos := pos MOD vSize;
    Strings.Extract(cur.value, splitPos,
                    Strings.Length(cur.value), tmp);

    (* 4. Make a new record, `rest`, using the temporary 
          `ARRAY OF CHAR` and update the value of `.next` to
          match that of `cur.next` *)
    New(rest); Set(rest, tmp);
    rest.next := cur.next;

    (* 5. Truncate `cur.value` at the relative split point *)
    i := splitPos;
    WHILE i < LEN(cur.value) DO
      cur.value[i] := 0X;
      INC(i);
    END;

    (* 6. Set `cur.next` to point to our `extra`
          dynamic string. *)
    cur.next := extra;

    (* 7. Move to the end of extra with `cur` *)
    WHILE cur.next # NIL DO cur := cur.next; END;

    (* 8. Set the `cur.next` to point at `rest` *)
    cur.next := rest;
  END Insert;

~~~

While our `Insert` is the longest procedure so far the steps 
are mostly simple. Additionally we can easily extend this to 
support inserting a more traditional `ARRAY OF CHAR` using our
previously established design pattern of converting a basic type
into our dynamic type before calling the dynamic version of the
function.

~~~

  PROCEDURE InsertCharArray*(source : ARRAY OF CHAR; 
                             pos : INTEGER; 
                             VAR dest : DynamicString);
    VAR extra : DynamicString;
  BEGIN
    New(extra); Set(extra, source);
    Insert(extra, pos, dest);
  END InsertCharArray;

~~~

## Where to go next

It is possible to extend our "DynamicStrings.Mod" into a drop 
in replacement for the standard `Strings`.  I've included a 
skeleton of that module as links at the end of this article 
with stubs for the missing implementations such as `Extract`, 
`Replace`, `Pos`, and `Cap`.  I've also included a 
"DynamicStringsTest.Mod" for demonstrating how it works.

The procedure I suggest is to mirror `Strings` replacing the 
parameters that are `ARRAY OF CHAR` with `DynamicString`. It 
will be helpful to include some bridging procedures that accept 
`ARRAY OF CHAR` as inputs too. These will use similar names 
with a suffix of `CharArray`.

## Parameter conventions and order

Oberon is highly composable. The trick to creating a drop in 
replacement module is use the same parameter signatures so 
you only need to make minor changes like updating the `IMPORT` 
statement and using a module alias to map the old module to the
new one.  The parameter signatures in `Strings` follow a 
convention you'll see in other Oberon modules. The parameter
order is based on the "inputs", "modify parameters", and 
"output parameters". Inputs are non-`VAR` parameters. The 
remaining are `VAR` parameters. I think of "modify parameters" 
as those objects who reflect side effects. I think of "output" 
as values that in other languages would be returned by 
functions.  This is only a convention. A variation I've 
read in other Oberon modules is "object", "inputs", "outputs". 
"object" and "outputs" are `VAR` parameters and "inputs" are 
not. This ordering makes sense when we think of records as 
holding an object. In both cases ordering is a convention 
and not enforced by the language.  Convention and consistency is 
helpful but readability is the most important.  Oberon is a 
readable language. It does not reward obfuscation. Readability is 
a great virtue in a programming language. When creating your own 
modules choose readability based on the concepts you want to
emphasize in the module (e.g. procedural, object oriented).

## The modules so far

You can read the full source for the module discussed along
with a test module in the links that follow.

+ [DynamicStrings.Mod](DynamicStrings.Mod)
+ [DynamicStringsTest.Mod](DynamicStringsTest.Mod)


### Next and Previous 

+ Next [Procedures as parameters](../../06/20/Procedures-as-parameters.html)
+ Previous [Oberon-07 and the file system](../09/Oberon-07-and-the-filesystem.html)