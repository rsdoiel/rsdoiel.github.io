---
title: "Procedures in records"
series: "Mostly Oberon"
number: 10
author: "R. S. Doiel"
date: "2020-07-07"
keywords: [ "Oberon", "procedures", "record procedures", "programming" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/" 
---


# Procedures in records

By R. S. Doiel, 2020-07-07

This is the tenth post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html) series.
Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the 
various rabbit holes I will inevitably fall into.

In my last post I looked at how Oberon-07 supports the passing of procedures as parameters in a procedure. In this one I am looking at how we can
include procedures as a part of an Oberon RECORD. 

Let's modify our module name [Noises.Mod](Noises.Mod) to explore this.
Copy "Noises.Mod" to "Creatures.Mod". Replace the "MODULE Noises;" line with
"MODULE Creatures;" and the final "END Noises." statement with "END Creatures.".


~~~

    MODULE Creatures;
    
    (* rest of code here *)

    END Creatures.

~~~


The key to supporting records with procedures as record attributes is once again Oberon's type system.  The type `Noise` we created in the previous post can also be used to declare a record attribute similar to how we use this new type to pass the procedure. In this exploration will create a linked list of "Creature" types which include a "MakeNoise" attribute.

First let's define our "Creature" as a type as well as a 
`CreatureList`. Add the following under our `TYPE` 
definition in [Creatures.Mod](Creatures.Mod).


~~~

    Creature = POINTER TO CreatureDesc;
    CreatureDesc = RECORD
                     name : ARRAY 32 OF CHAR;
                     noises : Noises;
                   END;

~~~


Let's create a new `MakeCreature` procedure that will create
a populate a single `Creature` type record.


~~~

    PROCEDURE MakeCreature(name : ARRAY OF CHAR; noise : Noise; VAR creature : Creature);
    BEGIN
      NEW(creature);
      creature.name := name;
      creature.noise := noise;
    END MakeCreature;

~~~


Now lets modify `MakeNoise` to accept the `Creature` type RECORD
rather than a name and a noise procedure parameter.


~~~

    PROCEDURE MakeNoise(creature : Creator);
    BEGIN
      creature.noise(creature.name);
    END MakeNoise;

~~~


How does this all work?  The two "Noise" procedures 
"BarkBark" and "ChirpChirp" remain as in our original 
"Noises" module. But our new `MakeNoise` procedure
looks takes a `Creature` record rather than accepting a
name and procedure as parameters. This makes the code 
a little more concise as well as lets you evolve the
creature record type using an object oriented approach.

Our revised module should look like this.


~~~

    MODULE Noises;
      IMPORT Out;
    
    TYPE 
      Noise = PROCEDURE(who : ARRAY OF CHAR);

      Creature = RECORD
                   name : ARRAY 32 OF CHAR;
                   noises : Noises;
                 END;
    
    VAR
      dog, bird : Creature;

    PROCEDURE BarkBark(who : ARRAY OF CHAR);
    BEGIN
      Out.String(who);
      Out.String(": Bark, bark");Out.Ln();
    END BarkBark;
    
    PROCEDURE ChirpChirp(who : ARRAY OF CHAR);
    BEGIN
      Out.String(who);
      Out.String(": Chirp, chirp");Out.Ln();
    END ChirpChirp;
    
    PROCEDURE MakeNoise(creature : Creature);
    BEGIN
      (* Call noise with the animal name *)
      creature.noise(creature.name);
    END MakeNoise;

    PROCEDURE MakeCreature(name : ARRAY OF CHAR; noise : Noise; VAR creature : Creature);
    BEGIN
      NEW(creature);
      creature.name := name;
      creature.noise := noise;
    END MakeCreaturel
    
    BEGIN
      MakeCreature("Fido", BarkBark, dog);
      MakeCreature("Tweety", ChirpChirp, bird);
      MakeNoise(dog);
      MakeNoise(bird);
    END Noises.

~~~


Where to go from here? Think about evolving [Creatures](Creatures.Mod) so
that you can create a dynamic set of creatures that mix and match their
behaviors. Another idea would be to add a "MutateCreature" procedure
that would let you change the noise procedure to something new.


### Next and Previous 

+ Next [Portable Oberon 7](../../08/15/Portable-Oberon-07.html)
+ Previous [Procedures as parameters](../../06/20/Procedures-as-parameters.html) 


