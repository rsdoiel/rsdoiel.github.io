{
    "markup": "mmark",
    "title": "Oberon Modules and Procedures",
    "number": 2,
    "byline": "R. S. Doiel",
    "date": "2020-04-12",
    "keywords": [ "Oberon", "programming" ],
    "copyright": "copyright (c) 2020, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}


# Oberon Modules and Procedures

By R. S. Doiel, 2020-04-12

This is the second post in the [Mostly Oberon](../11/Mostly-Oberon.html) series. Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the various rabbit wholes I inevitably fell into.

## Modules

The module is a primary code unit of Oberon language. Modules allow you to focus on functional units of code and can be readily composed into larger solutions.
A module's name should match the filename you are saving it under. A module starts with declaring it's name and ends the declaration with a semicolon
the statement separator in Oberon. Our simple "Hello World" example 
shows the basic code shape.


~~~

    MODULE HelloWorld;
      IMPORT Out;
    BEGIN
      Out.String("Hello World!"); Out.Ln;
    END HelloWorld.

~~~


Modules end with a `END` followed by the module's name and a period.
Any text following the `END` statement is ignored by the compiler. This
turns out to be very useful as a place to write up ideas about the code
you're working on. You can also write any additional special instructions 
there (e.g. document usage). You can even use it as a scratch pad knowing 
that the compiler will ignore it.

Here's an example


~~~

    MODULE HelloWorld;
      IMPORT Out;
    BEGIN
      Out.String("Hello World!"); Out.Ln;
    END HelloWorld.

    This program isn't very useful. It has no interactive ability.
    It'd be nice if it could be more specific about who it was saying
    hello to.

~~~


For a module to be really useful you want to have the capability
of including both private and public code. Public code
allows us to reuse our code in other modules while the private code 
keeps internal things inside the module safe from colliding with other
modules private code. This technique is classically known as 
"information hiding" and in computer sciences texts as "scope". Lets 
create a a more composable module called `SayingHi.Mod`.  In 
addition to display "Hello World!" we want a public method 
(procedure in Oberon terminology) that can ask for a name and print 
out a salutation. We will use the `SayingHi.Mod` module along with 
a newer version of `HelloWorld.Mod` named `HelloWorld2.Mod`.


## Procedures

How do we write methods in Oberon?  Methods are declared
using the keyword `PROCEDURE` followed by their name, a 
declaration of any parameters and if the procedure returns a
value (i.e. is a function) it also includes that declaration. 
Next we declare any internal variables needed by the procedure.
This is followed by the procedure's body.  The body of the 
procedure is defined by a `BEGIN` and `END` statement structure. 
The body contains the steps the procedure needs to execute.

We'll create a procedure called "HelloWorld" in our new module.
Since we will use this procedure from our new `HelloWorld2.Mod` 
our new "HelloWorld" procedure needs to be public.  A public 
procedure in `SayingHi.Mod` is available for use in our new 
`HelloWorld2.Mod` (or by another module).  Marking a procedure 
public in Oberon is a little different than in other languages. 
A Module's procedure is public if its name ends with an asterisk. 
Below is a sketch of our module `SayingHi.Mod` so far.

NOTE: This technique is also used to mark variables, records and constants as public and available to other modules. Public variables are "read only" in other modules.


~~~

    MODULE SayingHi;
      IMPORT Out;
    
      PROCEDURE HelloWorld*;
      BEGIN
        Out.String("Hello World!"); Out.Ln;
      END HelloWorld;
    END SayingHi.

~~~


This modules looks allot like `HelloWorld.Mod` with a couple key
differences. Rather than relying on the module's begin and end 
statements we declare a procedure with its own begin and end statements.
Notice the procedures end statement includes the procedure name and
is terminated by semicolon rather than a period.  Like `HelloWorld.Mod`
we import the `Out` module to display our greeting.

## Putting it all together

Let's create a new "Hello World" module called `HelloWorld2.Mod` and
use our `SayingHi` module instead of directly importing `Out`.


~~~

    MODULE HelloWorld2;
      IMPORT SayingHi;
    BEGIN
      SayingHi.HelloWorld;
    END HelloWorld2.

~~~


We can compile our module with OBNC using the command


~~~

    obnc HelloWorld2.Mod

~~~


We can run our new "Hello World" with the command


~~~

    ./HelloWorld2

~~~


At this point we have a way of saying "Hello World!" whenever
we need in our Oberon programs. But just printing "Hello World!"
to the screen isn't very interactive. It'd be nice if we could
have the computer ask our name and then respond with a greeting.

We'll modify our SayingHi to include a new procedure called "Greetings"
and that procedure needs to ask us our name and then display
an appropriate greeting. "Greetings" will be a public procedure
marked by an asterisk like "HelloWorld". 

"Greetings" has three tasks

1. Ask politely for our name
2. Get the name typed in with our keyboard
3. Assemble and display a polite greeting

To keep our "Greeting" procedure short we'll split this
up into some private procedures. These will not be available
outside `SayingHi.Mod`. Here's a sketch of our improved module.


~~~

    MODULE SayingHi;
      IMPORT In, Out;
    
      PROCEDURE HelloWorld*;
      BEGIN
        Out.String("Hello World!"); Out.Ln;
      END HelloWorld;
    
      PROCEDURE AskOurName;
      BEGIN
        Out.String("Excuse me, may I ask your name? ");
      END AskOurName;
    
      PROCEDURE GetName(VAR ourName : ARRAY OF CHAR);
      BEGIN
        In.Line(ourName);
      END GetName;
    
      PROCEDURE AssembleGreeting(ourName : ARRAY OF CHAR);
      BEGIN
        Out.String("Hello ");Out.String(ourName);
        Out.String (", very nice to meeting you."); Out.Ln;
      END AssembleGreeting;
    
      PROCEDURE Greetings*;
        VAR ourName : ARRAY 256 OF CHAR;
      BEGIN
        AskOurName;
        GetName(ourName);
        AssembleGreeting(ourName);
      END Greetings;
    END SayingHi.

~~~


Now let's add our Greetings procedure to `HelloWorld2.Mod`.


~~~

    MODULE HelloWorld2;
      IMPORT SayingHi;
    BEGIN
      SayingHi.HelloWorld;
      SayingHi.Greetings;
    END HelloWorld2.

~~~


We compile and run it the same way as before


~~~

    obnc HelloWorld2
    ./HelloWorld2

~~~


When you run `HelloWorld2` you should now see something like
(I've answered "Robert" and pressed return after the second line.


~~~

   Hello World!
   Excuse me, may I ask your name? Robert
   Hello Robert, very nice to meeting you.

~~~



## Reading our code

While our revised modules are still short they actually exercise
a number of language features. Let's walk through the code 
block by block and see what is going.

`HelloWorld2.Mod` is responsible for the general management of
our program namely say "Hello World!" and also for initiating
and responding with a more personal greeting.  It does this by
first importing our `SayingHi.Mod` module.


~~~

    IMPORT SayingHi;

~~~


[HelloWorld2.Mod](HelloWorld2.Mod) doesn't have any of its own 
procedures and like our original [HelloWorld.Mod](HelloWorld.Mod)
relies on the module's initialization block to run our two public 
procedures from `SayingHi`. It calls first `SayingHi.HelloWorld;` 
then `SayingHi.Greetings'` before existing. Other than using the 
`SayingHi` module it is similar in spirit to our first 
[HelloWorld.Mod](HelloWorld.Mod).

Our second module [SayingHi.Mod](SayingHi.Mod) does the heavy lifting.
It contains both public and private procedures.  If you tried to
use `GetName` from `SayingHi` in `HelloWorld2.Mod` you would get a
compiler error. As far as `HelloWorld2.Mod` is concerned `GetName`
does not exist. This is called information hiding and is an important
capability provided by Oberon's Modules system. 

### explore `SayingHi` more deeply

In `SayingHi.Mod` we introduce two important concepts.

1. Public and Private procedures
2. variables to hold user input

`SayingHi.Mod` imports two module, `In` which is for getting
text input from the keyboard, and `Out` which is used for displaying
text to standard output.


~~~

    IMPORT In, Out;

~~~


`In` and `Out` are to modules you will commonly use to either
receive input (`In`) from the keyboard or display output (`Out`)
to the terminal or shell. They provide simple methods for working
with variables and constants and built-in Oberon data types. 
This is a very useful as it lets us focus our procedures
on operating on data rather than the low level steps needed to
interact with the operating system and hardware.

NOTE: __basic types__, Oberon has a number of basic types, BYTE holds a byte as a series of bit, CHAR holds a single ASCII character, INTEGER holds a signed integer value, REAL holds a floating point number and BOOLEAN holds a True/False value.

The first procedure is `HelloWorld` and it's pretty straight forward.
It displays a "Hello World!" message in our terminal. It uses `Out`.
`Out.String` to display the "Hello World!" and `Out.Ln` to force a new
line. `Out.String` is responsible for displaying values that are of type
`ARRAY OF CHAR`. This includes text we provided in double quotes.


~~~

    PROCEDURE HelloWorld*;
    BEGIN
      Out.String("Hello World!"); Out.Ln;
    END HelloWorld;

~~~


The notable thing about `HelloWorld*` is its annotation `*`.
This asterisk indicates to the compiler that this is
a public procedure and should be made available to other modules.
Procedures, variables, constants, records (data structures) can be
made public with this simple annotation.  If we left off the `*`
then we would not be able to use `HelloWorld` procedure from other
module.

Our second procedure is `AskOurName`. It's private because it lacks
the `*`. It is invisible to `HelloWorld2.Mod`. It is visible within
`SayingHi` module and we'll use it later in `Greetings*`. Before
a procedure, variable, constant or record can be used it must be
declared. That is why we most define `AskOurName` before we define
`Greetings*`. `AskOurName` is in other respects very similar to 
`HelloWorld*`.


~~~

    PROCEDURE AskOurName;
    BEGIN
      Out.String("Excuse me, may I ask your name? ");
    END AskOurName;

~~~


Our third procedure `GetName` is a little more interesting.
It demonstrates several features of the Oberon language. Most
obvious is that it is the first procedure which contains a
parameter list.


~~~

    PROCEDURE GetName(VAR ourName: ARRAY OF CHAR);

~~~


There is allot packed in this single statement in addition
to putting a name to our procedure. Specifically it uses
a `VAR` in the parameter.  Oberon provides two kinds of parameters
in declaring procedures. The two are `VAR` and static.  A `VAR` 
parameter means that the procedure is allowed to up date the value 
in the memory location indicated by the name. A static variable 
(a parameter without the `VAR` prefix passes in a read only value. 
This allows us to distinguish between those procedures and variables
where that can be modified by the procedure and those which
will be left the same. Inside of `GetName` we call the 
`In` module using the `Line`. This retrieves a line of text
(a sequence of keyboard strokes ended with the return key).


~~~

    In.Line(ourName);

~~~


Because `ourName` was a variable parameter in `GetName` it
can be modified by `In.Line`.

Our next procedure `AssembleGreeting` is private like
`AskOurName` and `GetName`. Like `HelloWorld*` and `AskOurName`
it makes use of the `Out` module to display content.
Unlike `HelloWorld*` it has a parameter but this time
a static one. Notice the missing `VAR`. This indicates that
`AssembleGreeting` doesn't modify, cannot modify `ourName`.


~~~

    PROCEDURE AssembleGreeting(ourName : ARRAY OF CHAR);
    BEGIN
      Out.String("Hello ");Out.String(ourName);
      Out.String (", very nice to meeting you."); Out.Ln;
    END AssembleGreeting;

~~~


The use of `Out.String` is more elaborate then before. Notice how
we use trailing spaces to make the output more readable.

Our final procedure is public, `Greetings*`. It does not
have any parameters.  Importantly it does include a
variable for use inside the procedure called `ourName`. 
The `VAR` line declares `ourName` as an `ARRAY 256 OF CHAR`. 
This declaration tells the compiler to allocate memory 
for storing `ourName` while `Greetings*` is being executed. 
The declaration tells us three things. First the storage
is continuous block of memory, that is what `ARRAY` means.
The second is the size of this memory block is 256 `CHAR`
long and the that we will be storing `CHAR` values in it.

The memory for `ourName` will be populated when we pass
the variable to `GetName` based on what we type at the
keyboard. If we type more than 256 ASCII characters they
will be ignored. After `GetName` records the typed character
we use the memory associated with the `ourName` variable
we read that memory to display what we typed in 
the procedure named `AssembleGreeting`.


### Going a little deeper

Oberon is a typed language meaning that 
variables are declared, allocated and checked during compile time
for specific characteristics. The one variable we created `ourName`
in the `Greetings` procedure reserves the space for 256 
[ASCII](https://en.wikipedia.org/wiki/ASCII) characters. 
In Oberon we call a single ASCII character a `CHAR`.  Since it
would be useful to work with more than one `CHAR` in relationship
to others Oberon also supports a variable type called `ARRAY`. 
An `ARRAY` is represented as a block of memory that is allocated
by the Oberon run time. Because it is allocated ahead of time we
need to know its size (i.e. how many `CHAR` are we storing). In
our case we have declared `ARRAY 256 OF CHAR`. That means we can
hold names up to 256 ASCII characters. 

`Greetings*` does three things and the second thing, `GetName` 
receives the characters typed at the keyboard.  `GetName` has
a parameter list. In this case the only one parameter is declared
`VAR ourName : ARRAY OF CHAR`. Notice the similarity and
difference between the `VAR` statement in `Greetings` versions
the parameter list.  Our `GetName` can accept **any** length of
`ARRAY OF CHAR` and it **only** can accept an `ARRAY OF CHAR`.
If you try to pass another type of variable to `GetName` the
compiler will stop with an error message.

Why is this important?

We've minimized the memory we've used in our program.  Memory is 
typically allocated on the stack (a block of memory made available 
by the operating system to the program). We've told the operating 
system we need 256 `CHAR` worth of consecutive memory locations 
when we allocated room the variable `ourName` in `Greetings`. When 
we invoke `GetName` Oberon knows to use that same memory location 
for the value of `ourName` defined in the parameter.  In turn
when `In.String(ourName);` is called the module `In` knows
to store the name typed on the keyboard in that location of memory.
When `Out.String(outName);` is called the compiler knows to use
the same location of memory to send the contents to the display.
When we finally finish the `Greetings*` procedure the memory is 
released back to the operating system for re-use by this or
other programs.

### What we've explored

1. Using a module to break down a simple problem
2. Using a module's ability to have public and private procedures 
3. Touched on how memory is used in a simple interactive program



### Next and Previous

+ Next [Basic Types](../18/Mostly-Oberon-Basic-Types.html)
+ Previous [Mostly Oberon](../11/Mostly-Oberon.html)

