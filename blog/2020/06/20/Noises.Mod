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

