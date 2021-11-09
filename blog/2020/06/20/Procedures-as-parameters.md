---
title: "Procedures as parameters"
series: "Mostly Oberon"
number: 9
author: "R. S. Doiel"
date: "2020-06-20"
keywords: [ "Oberon", "procedures", "passing procedures as parameters", "programming" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/" 
---


# Procedures as parameters

By R. S. Doiel, 2020-06-20

This is the ninth post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html) series.
Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the 
various rabbit holes I will inevitably fall into.

Oberon-07 supports the passing of procedures as parameters in a procedure. 
Let's create a module name [Noises.Mod](Noises.Mod) to explore this.

The key to supporting this is Oberon's type system.  We need to decide what our 
generic procedure will look like first. In our case our procedures that will display 
an animal noise will include the name of the animal speaking.  We'll call this type 
of procedure "Noise". It'll accept an ARRAY OF CHAR for the name as a parameter 
then use the standard Out module to display the animal name and noise they make.


~~~

    TYPE
      Noise = PROCEDURE (who : ARRAY OF CHAR);

~~~


The two "Noise" procedures will be "BarkBark" and "ChirpChirp". They will
implement the same parameter signature as describe in the "Noise" type.


~~~

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

~~~


We'll also create a procedure, MakeNoise, that accepts the animal name and
our "Noise" procedure name and it'll call the "Noise" type procedure 
passing in the animal name.


~~~

    PROCEDURE MakeNoise(name : ARRAY OF CHAR; noise : Noise);
    BEGIN
      (* Call noise with the animal name *)
      noise(name);
    END MakeNoise;

~~~


If we invoke MakeNoise with our animal name and pass the name of the 
procedure we want to do the MakeNoise procedure will generate our
noise output. Here' is what is looks like all together.


~~~

    MODULE Noises;
      IMPORT Out;
    
    TYPE 
      Noise = PROCEDURE(who : ARRAY OF CHAR);
    
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
    
    PROCEDURE MakeNoise(name : ARRAY OF CHAR; noise : Noise);
    BEGIN
      (* Call noise with the animal name *)
      noise(name);
    END MakeNoise;
    
    BEGIN
      MakeNoise("Fido", BarkBark);
      MakeNoise("Tweety", ChirpChirp);
      MakeNoise("Fido", ChirpChirp);
      MakeNoise("Tweety", BarkBark);
    END Noises.

~~~


Note when we pass the procedures we include their name **without** parenthesis.
Our type definition tells the compiler that the procedure can be a parameter,
any procedure with the same signature, e.g. `who : ARRAY OF CHAR` as the
only parameter will be treated as a "Noise" type procedures. 

### Next and Previous 

+ Next [Procedures in Records](../../07/07/Procedures-in-records.html)
+ Previous [Dynamic types](../../05/25/Dynamic-types.html) 


