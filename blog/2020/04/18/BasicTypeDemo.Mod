MODULE BasicTypeDemo;
  IMPORT Out;

  (* These are our custom data types definitions. *)
  TYPE
      TopThreeScoreboard = RECORD
        gameName : ARRAY 24 OF CHAR;
        playerNames : ARRAY 3, 24 OF CHAR;
        scores : ARRAY 3 OF INTEGER
      END;

      String = RECORD
        value : CHAR;
        next : POINTER TO String
      END;

  (* Here are examples of some basic type. We've declared them
     private to our module BasicTypeDemo. *)
  VAR 
    i : INTEGER;
    a : REAL;
    c: CHAR;
    b : BYTE;
    name : ARRAY 12 OF CHAR;
    scores : ARRAY 10 OF INTEGER;
    scoreboard : TopThreeScoreboard;
    s : String;


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
    WHILE i < LEN(scoreboard.placeNames) DO
      Out.String("    player, score: ");
      Out.String(scoreboard.playerNames[i]);Out.String(", ");
      Out.Int(scoreboard.scores[i]);
      Out.Ln;
    END;
  END DisplayMoreComplexTypes;

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

BEGIN
  SimpleTypes;
  DisplaySimpleTypes;
  MoreComplexTypes;
  DisplayMoreComplexTypes;
  (* Demo our dynamic string *)
  Out.String("Copy the phrase 'Hello World!' into our dynamic string");Out.Ln;
  SetString(s, "Hello World!");
  Out.String("Copy the value of String s into C our array of char");Out.Ln;
  StringToCharArray(s, c);
  Out.String("Display 'c' our array of char: );Out.String(c);Out.Ln;
END BasicTypeDemo.

