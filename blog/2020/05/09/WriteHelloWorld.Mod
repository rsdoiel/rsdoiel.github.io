PROCEDURE WriteHelloWorld;
  VAR
    (* Define a file handle *)
    f : Files.File;
    (* Define a file rider *)
    r : Files.Rider;
BEGIN
  (* Create our file, New returns a file handle *)
  f := Files.New("HelloWorld.txt");
  (* Register our file with the file system *)
  Files.Register(f);
  (* Set the position of the rider to the beginning *)
  Files.Set(r, f, 0);
  (* Use the rider to write out "Hello World!" *)
  Files.WriteString(r, "Hello World!");
  (* Write a end of line *)
  Files.Write(r, 10);
  (* Close our modified file *)
  Files.Close(f);
END WriteHelloWorld;
