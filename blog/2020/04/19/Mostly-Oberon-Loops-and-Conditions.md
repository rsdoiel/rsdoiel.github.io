---
title: "Oberon Loops and Conditions"
series: "Mostly Oberon"
number: 4
author: "R. S. Doiel"
date: "2020-04-19"
keywords: [ "Oberon", "programming" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---

Oberon Loops and Conditions
===========================

By R. S. Doiel, 2020-04-19

This is the four post in the [Mostly Oberon](../11/Mostly-Oberon.html) series. Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the various rabbit holes I will inevitably fall into.

## Data Flow

Oberon is a small systems language and while it is minimalist.
It provides you with the necessary primitives to get things done.
I've touched on code organization, basic types and basic type
extensions in the previous articles.  I have shown the basic
control statements but have not talked about them yet.

Oberon offers four basic control statements. 

IF, ELSIF, ELSE
: Basic condition test and execution

ASSERT
: A mechanism to trigger a program halt

WHILE DO, ELSIF DO
: The Loop structure in the language (aside from recursive procedures)

FOR TO, FOR TO BY
: A counting Loop where incrementing a counter by an integer value (e.g. 1 or by a specified constant).

## IF, ELSIF, ELSE

The first two provide for conditional statements of the form
if a condition is true do something. Almost ever computer language
has some form of a conditional express and the Oberon IF, ELSIF,
ELSE typical of what you find is more computer languages today.
Both ELSIF and ELSE are optional.

```Oberon
    IF (s = "Freda") OR (s = "Mojo") THEN
      Out.String("Wowie Zowie! I remember you from ZBS stories.");Out.Ln;
    ELSIF (s = "Bilbo") OR (s = "Gandolf") THEN
      Out.String("Greets, I remember from the Hobbit.");Out.Ln;
    ELSE
      Out.String("Glad to meet you ");Out.String(s);Out.Ln;
    END;
```

## ASSERT

The second expression, ASSERT, is a little different. If ASSERT
evaluates an expression that is FALSE then your program is halted.
This is like combining an "if EXPR is false then system exit".

```Oberon
    Out.String("Should I continue? Y/n ");
    In.Line(s);
    Out.Ln;
    ASSERT((s = "Y") OR (s = "y"));
    (* If you didn't enter Y or y the program will halt *)
```


## WHILE DO, ELSIF DO

Oberon 7 also provides two loop structures. These are very 
similar to other languages as well. The only expectation is that
a while loop may contain an ELSIF which continues the loop
execution until both clauses return FALSE.

The basic while loop, counting 1 to 10.

```Oberon
    i := 0;
    WHILE i < 10 DO
       i := i + 1;
       Out.Int(i, 1);Out.String(" ");
    END;
```

A while, elsif loop, counting 1 to 10, then 10 to 100 by 10.

```Oberon
    i := 0;
    WHILE i < 10 DO
       i := i + 1;
       Out.Int(i, 1); Out.String(" ");
    ELSIF i < 100 DO
       i := i + 10;
       Out.Int(i, 1);Out.String(" ");
    END;
```


## FOR Loops

The FOR loop in Oberon is very similar to modern FOR loops.
The FOR loop increments an integer value with in a range.
You the default increments the start value by 1 but if a 
BY clause is included you can control how the increment value
works.

Regular for loop, `i` is incremented by 1.

```Oberon
    FOR i := 1 TO 10 DO
       Out.Int(i, 1);Out.String(" ");
    END;
```

Using a BY clause incrementing `i` by 2.

```Oberon
    FOR i := 0 TO 20 BY 2  DO
       Out.Int(i, 1);Out.String(" ");
    END;
```


## Putting it all together

The following [module](LoopsAndConditions.Mod) demonstrates
the conditional and loop syntax.

```Oberon
    MODULE LoopsAndConditions;
      IMPORT In, Out;
    
    PROCEDURE IfElsifElseDemo;
      VAR s : ARRAY 128 OF CHAR;
    BEGIN
      Out.String("Enter your name: ");
      In.Line(s);
      Out.Ln;
      IF (s = "Freda") OR (s = "Mojo") THEN
        Out.String("Wowie Zowie! I remember you from ZBS stories.");Out.Ln;
      ELSIF (s = "Bilbo") OR (s = "Gandolf") THEN
        Out.String("Greets, I remember from the Hobbit.");Out.Ln;
      ELSE
        Out.String("Glad to meet you ");Out.String(s);Out.Ln;
      END;
    END IfElsifElseDemo;
    
    PROCEDURE AssertDemo;
      VAR s : ARRAY 128 OF CHAR;
    BEGIN
      Out.String("Should I continue? Y/n ");
      In.Line(s);
      Out.Ln;
      ASSERT((s = "Y") OR (s = "y"));
    END AssertDemo;
    
    PROCEDURE WhileDemo;
      VAR i : INTEGER;
    BEGIN
      Out.String("Basic WHILE counting from 1 to 10");Out.Ln;
      i := 0;
      WHILE i < 10 DO
         i := i + 1;
         Out.Int(i, 1);Out.String(" ");
      END;
      Out.Ln;
      Out.String("WHILE ELSIF, count 1 to 10 THEN 10 to 100");Out.Ln;
      i := 0;
      WHILE i < 10 DO
         i := i + 1;
         Out.Int(i, 1); Out.String(" ");
      ELSIF i < 100 DO
         i := i + 10;
         Out.Int(i, 1);Out.String(" ");
      END;
      Out.Ln;
      Out.String("Demo of while loop counting one to ten, then by tenths.");
    END WhileDemo;
    
    PROCEDURE ForDemo;
      VAR i : INTEGER;
    BEGIN
      Out.String("Basic FOR LOOP counting from 1 to 10");Out.Ln;
      FOR i := 1 TO 10 DO
         Out.Int(i, 1);Out.String(" ");
      END;
      Out.Ln;
      Out.String("FOR loop counting by twos 1 to 20");Out.Ln;
      FOR i := 0 TO 20 BY 2  DO
         Out.Int(i, 1);Out.String(" ");
      END;
      Out.Ln;
    END ForDemo;
    
    BEGIN
      IfElsifElseDemo;
      AssertDemo;
      WhileDemo;
      ForDemo;
    END LoopsAndConditions.
```


### Next and Previous

+ Next [Combining Oberon-7 and C with OBNC](../../05/01/Combining-Oberon-and-C.html)
+ Previous [Basic Types](../18/Mostly-Oberon-Basic-Types.html)

