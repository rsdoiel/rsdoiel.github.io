MODULE Creatures;
  IMPORT Out;

TYPE 
  Noise = PROCEDURE(who : ARRAY OF CHAR);

  Creature = POINTER TO CreatureDesc;
  CreatureDesc = RECORD
               name : ARRAY 32 OF CHAR;
               noise : Noise
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
END MakeCreature;

BEGIN
  (* Make our dog and bird creatures *)
  MakeCreature("Fido", BarkBark, dog);
  MakeCreature("Tweety", ChirpChirp, bird);
  (* Let our creatures make some noise *)
  MakeNoise(dog);
  MakeNoise(bird);
END Creatures.

