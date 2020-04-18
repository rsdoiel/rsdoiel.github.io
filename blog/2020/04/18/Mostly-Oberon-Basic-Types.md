{
    "markup": "mmark",
    "title": "Oberon Basic Types",
    "number": 3,
    "byline": "R. S. Doiel",
    "date": "2020-04-18",
    "copyright": "copyright (c) 2020, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}

# Oberon Basic Types


By R. S. Doiel, 2020-04-18

This is the third post in the [Mostly Oberon](../11/Mostly-Oberon.html) series. Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the various rabbit wholes I inevitably fell into.

## Simple Types

Oberon is a small systems language. It provides a useful but 
limited umber of basic types[^basic-types]. These can be be
thought of as simple types mapping to specific memory locations
and more complex types composed of multiple memory locations.

[^basic-types]: INTEGER, REAL, CHAR, ARRAY, RECORD and POINTER TO

### INTEGER

Integers are easiest to be thought of as whole numbers. They may be
positive numbers or negative numbers. Declaring an integer
variable `i` it would look something like

```Oberon
    VAR i : INTEGER;
```

Setting `i`'s value to seven would look like

```Oberon
    i := 7;
```


### REAL

Real holds real numbers. Real numbers contain a fractional 
component. We normally notate them with
a decimal value e.g. "0.01". Like integers they can also be 
positive or negative.

Declaring a real number variable `a` would look like

```Oberon
    VAR a : REAL;
```

Setting the value of `a` to seven and one tenth (7.1) would
look like

```Oberon
    a := 7.1;
```

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

```Oberon
    VAR c: CHAR;
```

Setting the value of `c` to capital Z would look like

```Oberon
    c := "Z";
```

Note: Oberon expects double quotes to notate a character.


### More complex types

The simplest types would prove problematic when addressing
more complex data representations if Oberon lacked two three built-in
types - ARRAY, RECORD and POINTER TO. 

### ARRAY

An array is a sequence of memory locations which contain a common
type.  In Oberon 7 all arrays have to have a known link. This is
because the Oberon compiler is responsible for pre-allocating
memory when the program starts to hold the array.  While this
seems restrictive our next data type, RECORD, lets us move
into more dynamic memory structures.  Pre-allocating the array
size also has the advantage that we can re-use those locations
easily in a type safe manner[^type-safety]. 

Declaring a variable "name" as an array of twelve characters would 
look like and declaring a variable "scores" as an array of ten
integers would look like

```Oberon
    VAR 
      name : ARRAY 12 OF CHAR;
      scores : ARRAY 10 OF INTEGER;
```

The length of the array immediately follows the keyword "ARRAY" and
the "OF CHAR" or "OF INTEGER" phrases describes the types that can be 
contained in the array. In the "OF CHAR" the type is "CHAR" the 
"OF INTEGER" is the type "INTEGER". 

Setting an array value can be done using an index. In this example
the zero-th element (first element of the array) is set to the value
102. 

```Oberon
    scores[0] := 102;
```

In the case of CHAR arrays the whole array can be set in a simple 
single assignment.

```Oberon
    name := "Ada Lovelace";
```

Two key points of arrays in Oberon are a known length and a single 
type of data associated with them. Arrays can have more than
one dimension but the cells of the array most contain the same type.

[^type-safety]: Type safe means the compiler or run time verify that the data stored at that location conforms to the program defined, this is helpful in maintaining program correctness.

### RECORD

The RECORD is Oberon's secret sauce. The record is used to
create new types if data representations. It extend Oberon's basic 
types creating structured data representation. In this example we'll 
create a record that holds an game's name, a list of three player names 
and a list of three scores. We'll call this record type 
"TopThreeScoreboard". 

```Oberon
    TYPE
      TopThreeScoreboard = RECORD
        gameName : ARRAY 24 OF CHAR;
        playerNames : ARRAY 3, 24 OF CHAR;
        scores : ARRAY 3 OF INTEGER
      END;
```

Now that we have describe a record of type "TopThreeScoreboard" we can
declare it with our "VAR" statement.

```Oberon
    VAR
      scoreboard : TopThreeScoreboard;
```

Setting the element values in a record uses a dot notation
and if those elements are themselves. In this case we'll set
the game name to "Basketball", the three players are
"Ada Lovelace", "Blaise Pascal", and "John McCarthy", with
the scores 102, 101, 100.

```Oberon
   scoreboard.gameName := "Basketball";
   scoreboard.playerNames[0] := "Ada Lovelace";
   scoreboard.scores[0] := 102;
   scoreboard.playerNames[1] := "Blaise Pascal";
   scoreboard.scores[0] := 101;
   scoreboard.playerNames[2] := "John McCarthy";
   scoreboard.scores[0] := 100;
```

Records are also used to create dynamic memory structures such as lists, trees and maps[^ad].  The dynamic nature of records is achieved with
our next type "POINTER TO".

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
of characters. Let's call it a dynamic string and we will implement
it using a single link list. The list can be implemented by
defining a RECORD type that holds a single character and a pointer
to the next character.  If there is no next character
we assume we're at the end of the string.

```Oberon
    TYPE
      String = RECORD
        value : CHAR;
        next : POINTER TO String
      END;
```

RECORD types are permitted to use recursive definition so our 
"next" value is itself a type "String".  Declaring a 
dynamic string type is as easy as declaring our scoreboard.

```Oberon
  VAR
    VAR s : String;
```

Setting our dynamic string is a little trickier. This is where
Oberon's procedures come into play. We can pass our variable "s"
to a procedure to build out our dynamic string from an simple
array of characters. Note "s" is declared as a "VAR" parameter
in our procedure heading. Our `SetString` will also need to handle
creating new elements in our dynamic string. That is what Oberon's
built-in `NEW()` procedure does. It allocates new memory of our
record.

```Oberon
    PROCEDURE SetString(VAR s : String; src : ARRAY OF CHAR);
      VAR i : INTEGER; c : CHAR; cur, tmp : String;
    BEGIN
      cur := s;
      i := 0;
      WHILE (c[i] # 0X) DO
        cur.value := c[i];
        IF cur.next = NIL THEN
          NEW(tmp);
          cur.value := 0X;
          cur.next := tmp;
        END;
        cur := cur.next;
        i := i + 1;
      END;
    END SetString;
```

We can move our string back into a fixed length array of char
with a similar procedure.

```Oberon
  PROCEDURE StringToCharArray(s : String; VAR src : ARRAY OF CHAR);
    VAR cur := String; i, l : INTEGER;
  BEGIN
    l := LEN(src);
    i := 0;
    cur := s;
    WHILE (i < l) & (cur # NIL) DO
      src[i] := cur.C; 
      cur := cur.next;
      i := i + 1;
    END;
    (* Zero out the rest of the string. *)
    WHILE (i < l) DO
      src[i] := 0X;
      i := i + 1;
    END;
  END;
```

At this stage we have the basics of data organization. Modules
allow us to group operations and data into cohesive focused units.
Procedures allow us to define consistent ways of interacting with
out data, and types singularly and collectively allow us to structure
data in a way that is useful to solving problems.

## Putting it all together

Here is a [module demoing our basic type](BasicTypeDemo.Mod). In it
we can define procedures to demo our assignments and then show their
values in the module's initialization block.

```Oberon
```

[^ad]: Prof. Wirth wrote an excellent text on [Algorithms and Data structures](https://inf.ethz.ch/personal/wirth/AD.pdf) available in PDF format.
