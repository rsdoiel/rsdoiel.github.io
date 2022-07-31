---
title: "Oberon Basic Types"
number: 3
series: "Mostly Oberon"
author: "rsdoiel@gmail.com (R. S. Doiel)"
date: "2020-04-18"
keywords: [ "Oberon", "programming" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---


Oberon Basic Types
==================


By R. S. Doiel, 2020-04-18

This is the third post in the [Mostly Oberon](../11/Mostly-Oberon.html) series. Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the various rabbit wholes I inevitably fell into.

## Simple Types

Oberon is a small systems language. It provides a useful but 
limited umber of basic types. These can be be
thought of as simple types mapping to specific memory locations
and more complex types composed of multiple memory locations.

NOTE: __basic types__, INTEGER, REAL, CHAR, ARRAY, RECORD and POINTER TO

### INTEGER

Integers are easiest to be thought of as whole numbers. They may be
positive numbers or negative numbers. Declaring an integer
variable `i` it would look something like


~~~{.oberon}

    VAR i : INTEGER;

~~~


Setting `i`'s value to seven would look like


~~~{.oberon}

    i := 7;

~~~



### REAL

Real holds real numbers. Real numbers contain a fractional 
component. We normally notate them with
a decimal value e.g. "0.01". Like integers they can also be 
positive or negative.

Declaring a real number variable `a` would look like


~~~{.oberon}

    VAR a : REAL;

~~~


Setting the value of `a` to seven and one tenth (7.1) would
look like


~~~{.oberon}

    a := 7.1;

~~~


### CHAR

A CHAR is a single ASCII character. Oberon, unlike more recent
languages like Go or Julia, predates the wide adoption of UTF-8.
The character is represented in memory as one 8 bit byte.
If you need to work with an extended character set then you need
to either re-encode the values into ASCII. At this time[^now] there
is no standard way of handling None ASCII character systems natively.
If you need to work directly with an encoding such as UTF-8 you'll
need to develop your own modules and procedures for handily their
encoding, decoding and other operations.

Declaring a CHAR variable `c` would look like


~~~{.oberon}

    VAR c: CHAR;

~~~


Setting the value of `c` to capital Z would look like


~~~{.oberon}

    c := "Z";

~~~


Note: Oberon expects double quotes to notate a character.


### More complex types

The simplest types would prove problematic when addressing
more complex data representations if Oberon lacked two three built-in
types - ARRAY, RECORD and POINTER TO. 

### ARRAY

An array is a sequence of memory locations which contain a common
type.  In Oberon-07 all arrays have to have a known link. This is
because the Oberon compiler is responsible for pre-allocating
memory when the program starts to hold the array.  While this
seems restrictive our next data type, RECORD, lets us move
into more dynamic memory structures.  Pre-allocating the array
size also has the advantage that we can re-use those locations
easily in a type safe manner.

Declaring a variable "name" as an array of twelve characters would 
look like and declaring a variable "scores" as an array of ten
integers would look like


~~~{.oberon}

    VAR 
      name : ARRAY 24 OF CHAR;
      scores : ARRAY 10 OF INTEGER;

~~~


The length of the array immediately follows the keyword "ARRAY" and
the "OF CHAR" or "OF INTEGER" phrases describes the types that can be 
contained in the array. In the "OF CHAR" the type is "CHAR" the 
"OF INTEGER" is the type "INTEGER". 

Setting an array value can be done using an index. In this example
the zero-th element (first element of the array) is set to the value
102. 


~~~{.oberon}

    scores[0] := 102;

~~~


In the case of CHAR arrays the whole array can be set in a simple 
single assignment.


~~~{.oberon}

    name := "Ada Lovelace";

~~~


Two key points of arrays in Oberon are a known length and a single 
type of data associated with them. Arrays can have more than
one dimension but the cells of the array most contain the same type.

NOTE: __type safety__, Type safe means the compiler or run time verify that the data stored at that location conforms to the program defined, this is helpful in maintaining program correctness.

### RECORD

The RECORD is Oberon's secret sauce. The record is used to
create new types if data representations. It extend Oberon's basic 
types creating structured data representation. In this example we'll 
create a record that holds an game's name, a list of three player names 
and a list of three scores. We'll call this record type 
"TopThreeScoreboard". 


~~~{.oberon}

    TYPE
      TopThreeScoreboard = RECORD
        gameName : ARRAY 24 OF CHAR;
        playerNames : ARRAY 3, 24 OF CHAR;
        scores : ARRAY 3 OF INTEGER
      END;

~~~


Now that we have describe a record of type "TopThreeScoreboard" we can
declare it with our "VAR" statement.


~~~{.oberon}

    VAR
      scoreboard : TopThreeScoreboard;

~~~


Setting the element values in a record uses a dot notation
and if those elements are themselves. In this case we'll set
the game name to "Basketball", the three players are
"Ada Lovelace", "Blaise Pascal", and "John McCarthy", with
the scores 102, 101, 100.


~~~{.oberon}

   scoreboard.gameName := "Basketball";
   scoreboard.playerNames[0] := "Ada Lovelace";
   scoreboard.scores[0] := 102;
   scoreboard.playerNames[1] := "Blaise Pascal";
   scoreboard.scores[0] := 101;
   scoreboard.playerNames[2] := "John McCarthy";
   scoreboard.scores[0] := 100;

~~~


Records are also used to create dynamic memory structures such as lists, trees and maps (see note on "AD").  The dynamic nature of records is achieved with
our next type "POINTER TO".

NOTE: __AD__, Prof. Wirth wrote an excellent text on [Algorithms and Data structures](https://inf.ethz.ch/personal/wirth/AD.pdf) available in PDF format.
### POINTER TO

Oberon is a type safe language. To keep things safe in a type
safe language you need to place constraints around random
memory access. Memory can be thought of a list of locations and
we can go to those locations if we know their address. A pointer
in most languages holds an address. Oberon has pointers but they
must point at specific data types. So like array you have to indicate
the type of the thing you are pointing at in a declaration. 
E.g. `VAR a : POINTER TO CHAR;` would declare a variable 'a' 
that points to a memory location that holds a CHAR. The more common 
case is we use "POINTER TO" in records to create dynamic data 
structures such as linked lists.

Here's a simple data structure representing a dynamic list
of characters. Let's call it a DString and we will implement
it using a single link list. The list can be implemented by
defining a RECORD type that holds a single character and a pointer
to the next record. We can then also define a pointer to this type
of record.  If there is no next character record
we assume we're at the end of the string.


~~~{.oberon}

    TYPE
      DStringDesc = RECORD
        value : CHAR;
        next : POINTER TO DStringDesc
      END;

      DString : POINTER TO DStringDesc;

~~~


RECORD types are permitted to use recursive definition so our 
"next" value is itself a type "DStringDesc".  Declaring a 
DString variable is as easy as declaring our scoreboard type variable.


~~~{.oberon}

  VAR
    VAR s : DString;

~~~


Setting our DString is a little trickier. This is where
Oberon's procedures come into play. We can pass our variable "s"
of type DString to a procedure to build out our DString from an simple
array of characters. Note "s" is declared as a "VAR" parameter
in our procedure heading. Our `SetDString` will also need to handle
creating new elements in our dynamic string. That is what Oberon's
built-in `NEW()` procedure does. It allocates new memory for our
list of records.


~~~{.oberon}

    PROCEDURE SetDString(VAR s : DString; buf : ARRAY OF CHAR);
        VAR i : INTEGER; cur, tmp : DString;
    BEGIN
      (* Handle the case where s is NIL *)
      IF s = NIL THEN
        NEW(s);
        s.value := 0X;
        s.next := NIL;
      END;
      cur := s;
      i := 0;
      (* check to see if we are at end of string or array *)
      WHILE (buf[i] # 0X) & (i < LEN(buf)) DO
        cur.value := buf[i];
        IF cur.next = NIL THEN
          NEW(tmp);
          tmp.value := 0X;
          tmp.next := NIL;
          cur.next := tmp;
        END;
        (* Advance our current pointer to the next element *)
        cur := cur.next;
        i := i + 1;
      END;
    END SetDString;

~~~


We can move our string back into a fixed length array of char
with a similar procedure.


~~~{.oberon}

    PROCEDURE DStringToCharArray(s : DString; VAR buf : ARRAY OF CHAR);
      VAR cur : DString; i, l : INTEGER;
    BEGIN
      l := LEN(buf);
      i := 0;
      cur := s;
      WHILE (i < l) & (cur # NIL) DO
        buf[i] := cur.value; 
        cur := cur.next;
        i := i + 1;
      END;
      (* Zero out the rest of the string. *)
      WHILE (i < l) DO
        buf[i] := 0X;
        i := i + 1;
      END;
    END DStringToCharArray;

~~~


At this stage we have the basics of data organization. Modules
allow us to group operations and data into cohesive focused units.
Procedures allow us to define consistent ways of interacting with
out data, and types singularly and collectively allow us to structure
data in a way that is useful to solving problems.

## Putting it all together

Here is a [module demoing our basic type](BasicTypeDemo.Mod). In it
we can define procedures to demo our assignments, display their results
all called from inside the module's initialization block.


~~~{.oberon}

    MODULE BasicTypeDemo;
      IMPORT Out;
    
      (* These are our custom data types definitions. *)
      TYPE
          TopThreeScoreboard = RECORD
            gameName : ARRAY 24 OF CHAR;
            playerNames : ARRAY 3, 24 OF CHAR;
            scores : ARRAY 3 OF INTEGER
          END;
    
          DStringDesc = RECORD
            value : CHAR;
            next : POINTER TO DStringDesc
          END;
    
          DString = POINTER TO DStringDesc;
    
      (* Here are our private variables. *)
      VAR 
        i : INTEGER;
        a : REAL;
        c: CHAR;
        name : ARRAY 24 OF CHAR;
        scores : ARRAY 10 OF INTEGER;
        scoreboard : TopThreeScoreboard;
        s : DString;
    
    
      PROCEDURE SimpleTypes;
      BEGIN
        i := 7;
        a := 7.1;
        c := "Z";
      END SimpleTypes;
    
      PROCEDURE DisplaySimpleTypes;
      BEGIN
        Out.String(" i: ");Out.Int(i, 1);Out.Ln;
        Out.String(" a: ");Out.Real(a, 1);Out.Ln;
        Out.String(" c: ");Out.Char(c);Out.Ln;
      END DisplaySimpleTypes;
    
    
      PROCEDURE MoreComplexTypes;
      BEGIN
        scores[0] := 102;
        name := "Ada Lovelace";
        scoreboard.gameName := "Basketball";
        scoreboard.playerNames[0] := "Ada Lovelace";
        scoreboard.scores[0] := 102;
        scoreboard.playerNames[1] := "Blaise Pascal";
        scoreboard.scores[0] := 101;
        scoreboard.playerNames[2] := "John McCarthy";
        scoreboard.scores[0] := 100;
      END MoreComplexTypes;
    
      PROCEDURE DisplayMoreComplexTypes;
        VAR i : INTEGER;
      BEGIN
        i := 0;
        Out.String(" Game: ");Out.String(scoreboard.gameName);Out.Ln;
        WHILE i < LEN(scoreboard.playerNames) DO
          Out.String("    player, score: ");
          Out.String(scoreboard.playerNames[i]);Out.String(", ");
          Out.Int(scoreboard.scores[i], 1);
          Out.Ln;
          i := i + 1;
        END;
      END DisplayMoreComplexTypes;
    
      PROCEDURE SetDString(VAR s : DString; buf : ARRAY OF CHAR);
          VAR i : INTEGER; cur, tmp : DString;
      BEGIN
        (* Handle the case where s is NIL *)
        IF s = NIL THEN
          NEW(s);
          s.value := 0X;
          s.next := NIL;
        END;
        cur := s;
        i := 0;
        (* check to see if we are at end of string or array *)
        WHILE (buf[i] # 0X) & (i < LEN(buf)) DO
          cur.value := buf[i];
          IF cur.next = NIL THEN
            NEW(tmp);
            tmp.value := 0X;
            tmp.next := NIL;
            cur.next := tmp;
          END;
          cur := cur.next;
          i := i + 1;
        END;
      END SetDString;
    
      PROCEDURE DStringToCharArray(s : DString; VAR buf : ARRAY OF CHAR);
        VAR cur : DString; i, l : INTEGER;
      BEGIN
        l := LEN(buf);
        i := 0;
        cur := s;
        WHILE (i < l) & (cur # NIL) DO
          buf[i] := cur.value; 
          cur := cur.next;
          i := i + 1;
        END;
        (* Zero out the rest of the string. *)
        WHILE (i < l) DO
          buf[i] := 0X;
          i := i + 1;
        END;
      END DStringToCharArray;
    
    BEGIN
      SimpleTypes;
      DisplaySimpleTypes;
      MoreComplexTypes;
      DisplayMoreComplexTypes;
      (* Demo our dynamic string *)
      Out.String("Copy the phrase 'Hello World!' into our dynamic string");Out.Ln;
      SetDString(s, "Hello World!");
      Out.String("Copy the value of String s into 'name' our array of char");Out.Ln;
      DStringToCharArray(s, name);
      Out.String("Display 'name' our array of char: ");Out.String(name);Out.Ln;
    END BasicTypeDemo.

~~~


## Reading through the code

There are some nuances in Oberon syntax that can creep up on you.
First while most statements end in a semi-colon there are noticeable
exceptions. Look at the record statements in particular.  The last
element of your record before the `END` does not have a semicolon.
In that way it is a little like a `RETURN` value in a function
like procedure.

In creating our `DString` data structure the Oberon idiom is to first
create a description record, `DStringDesc` then create a pointer to
the descriptive type, i.e. `DString`. This is a very common
idiom in building out complex data structures. A good place to learn
about implementing algorithms and data structures in Oberon-07 is 
Prof. Wirth's 2004 edition of [Algorithms and Data Structures](https://inf.ethz.ch/personal/wirth/AD.pdf) which
is available from his personal website in PDF.


### Next and Previous

+ Next [Loops and Conditions](../19/Mostly-Oberon-Loops-and-Conditions.html)
+ Previous [Modules and Procedures](../12/Mostly-Oberon-Modules.html)

