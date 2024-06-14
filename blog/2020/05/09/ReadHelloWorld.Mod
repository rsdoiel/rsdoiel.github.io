PROCEDURE ReadHelloWorld;
  VAR
    f : Files.File;
    r : Files.Rider;
    (* We need a string to store what we have read *)
    src : ARRAY 256 OF CHAR;
BEGIN
  (* Create our file, New returns a file handle *)
  f := Files.Old("HelloWorld.txt");
  (* Set the position of the rider to the beginning *)
  Files.Set(r, f, 0);
  (* Use the rider to write out "Hello World!" *)
  Files.ReadString(r, src);
  (* Check the value we read, if it is not the name, 
     halt the program with an error *)
  ASSERT(src = "Hello World!");
END ReadHelloWorld;
