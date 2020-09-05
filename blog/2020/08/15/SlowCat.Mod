MODULE SlowCat;
  IMPORT In, Out, Input, Args := extArgs, Convert := extConvert;

CONST
  MAXLINE = 1024;

VAR
  count: INTEGER;

PROCEDURE Usage();
BEGIN
  Out.String("USAGE:");Out.Ln();
  Out.Ln();
  Out.String("SlowCat outputs lines of text delayed by");Out.Ln();
  Out.String("a number of seconds. It takes one parameter,");Out.Ln();
  Out.String("an integer, which is the number of seconds to");Out.Ln();
  Out.String("delay a line of output.");Out.Ln();
  Out.String("SlowCat works on standard input and output.");Out.Ln();
  Out.Ln();
  Out.String("EXAMPLE:");
  Out.Ln();
  Out.String("    SlowCat 15 < README.md");Out.Ln();
  Out.Ln();  
END Usage;

PROCEDURE ProcessArgs() : BOOLEAN;
  VAR i : INTEGER; ok : BOOLEAN; arg : ARRAY MAXLINE OF CHAR;
      res : BOOLEAN;
BEGIN
  res := FALSE;
  IF Args.count = 1 THEN
    Args.Get(0, arg, i);
    Convert.StringToInt(arg, i, ok);
    IF ok THEN
       (* convert seconds to microseconds of clock *)
       count := (i * 1000);
       res := TRUE;
    END;
  END;
  RETURN res
END ProcessArgs;

PROCEDURE Delay*(count : INTEGER);
  VAR start, current, delay : INTEGER;
BEGIN
   start := Input.Time();
   REPEAT
     current := Input.Time();
     delay := (current - start);
   UNTIL delay >= count;
END Delay;

PROCEDURE SlowCat(count : INTEGER);
  VAR text : ARRAY MAXLINE OF CHAR;
BEGIN
  REPEAT
    In.Line(text);
    IF In.Done THEN
      Out.String(text);Out.Ln();
      (* Delay by count *)
      Delay(count);
    END;
  UNTIL In.Done = FALSE;
END SlowCat;

BEGIN
  count := 0;
  IF ProcessArgs() THEN
    SlowCat(count);
  ELSE
    Usage();
  END;
END SlowCat.

# PROGRAM: SlowCat

## DESCRIPTION

SlowCat is like the Unix cat command except it accepts a time
delay (measured in seconds) to output each line input like a 
teleprompter. In this way you have can have a slow "cat" experience
giving you more time to read the output while not hitting the space 
bar everyone screen full. SlowCat works on standard input and output 
leveraging Unix file redirection.

## EXAMPLE

In this example we use "SlowCat" to output a new line of text from
"README.md" every five seconds -

	SlowCat 5 < README.md

## COMPILATION

SlowCat is written in Oberon 7 and compiled with Karl Landstrom's
OBNC compiler. It uses Karl's extensions to process the command
line arguments as well as his implementation of portable Oberon
modules "In" and "Out".

	obnc SlowCat.Mod

Running the compiled binary on this Oberon source file.

	SlowCat 5 < SlowCat.Mod


