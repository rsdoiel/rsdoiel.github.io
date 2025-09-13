---
title: 'RISC OS 5.30, GCC 4.7 and Hello World'
created: 2024-06-08T00:00:00.000Z
pubDate: 2024-06-08T00:00:00.000Z
abstract: |
  These are my notes on learning to program a Raspberry Pi Zero W
  under RISC OS using GCC 4.7 and RISC OS 5.30
keywords:
  - RISC OS
  - Raspberry Pi
  - GCC
  - C Programming
references:
  - 'Steve Fryatt''s tutorial <https://www.stevefryatt.org.uk/risc-os/wimp-prog>'
  - James Hobson's YouTUBE Video showing a summary of Steve Fryatt's tutorial
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2024-06-08'
dateModified: '2025-07-23'
datePublished: '2024-06-08'
postPath: 'blog/2024/06/08/riscos_gcc_and_hello.md'
---

# RISC OS 5.30, GCC 4.7 and Hello World

By R. S. Doiel, 2024-06-08 (updated: 2024-06-16)

Presently am I learning RISC OS 5.30 on my Raspberry Pi Zero W. I want to write some programs and I learned C back in University. I am familiar with C on POSIX systems but not on RISC OS. These are my notes to remind myself how things work differently on RISC OS.

I found two resources helpful. First James Hobson had a YouTUBE series on RISC OS and C programming. From this I learned about allocating more space in the Task Window via the Tasks window display of Next and Free memory. Very handy to know. Watching his presentation it became apparent he was walking through some
one's tutorial. This lead to some more DuckDuckGo searches and that is when I stumbled on Steve Fryatt's [Wimp Programming In C](https://www.stevefryatt.org.uk/risc-os/wimp-prog). James Hobson's series (showing visually) help and the detail of Steve Fryatt's tutorial helped me better understanding how things work on RISC OS.

I think these both probably date from around 2016. Things have been evolving in RISC OS since then. I'm not certain that OSLib today plays the same role it played in 2016. Also in the case of Steve Fryatt's tutorial I'm not certain that the DDE and Norcroft compilers are essential in the say way. Since I am waiting on the arrival of the ePic SD Card I figured I'd get started using the
GCC and tools available via Packman and see how far I can get.

## Getting oriented

What I think I need.

1. Editor
2. C compiler
3. Probably some libraries

You need an editor fortunately RISC OS comes with two, `!Edit` and `!StrongED`. You can use both to create C files since they are general purpose text edits.

You need a C compiler, GCC 4.7.4 is available via Packman. That is a click,
and download away so I installed that.

I had some libraries already installed so I skipped installing additional ones since I wasn't sure what was currently required.

## Pick a simple goal

When learning a new system I find it helpful to set simple goals. It helps from feeling overwhelmed.

My initial goal is to understand how I can compile a program and run it in the Task Window of RISC OS. The Task Window is a command line environment for RISC OS much like a DOS Window was for MS Windows or the Terminal is for modern macOS.  My initial program will only use standard in and out. Those come with the standard library that ships with the compiler. Minimal dependencies simplifies things. That goes my a good simple intial goal.

> I want to understand the most minimal requirements to compile a C program and run it in Task Window

## Getting started

The program below is a simple C variation on the "Hello World"  program tought to beginner C programers.  I've added a minimal amount of parameter handlnig to se how that works in the Task Window environment. This program will say "Hello World!" but if you include parameters it will say "Hi" to those too.

The code looks like this.

~~~C
#include <stdio.h>

int main(int argc, char *argv[]) {
  int i = 0;
  printf("Hello World!\n");
  for (i = 1; i < argc; i++)  { 
       printf("Hi %s\n", argv[i]);
  }
  return 0;
}
~~~

In a POSIX system I would name this "HelloWorld.c". On RISC OS the "." (dot)
is a directory delimiter. There seems to be two approaches to translating POSIX paths to RISC OS. Samba mounted resources seem to have a simple substitution translatio. A dot used for file extensions in POSIX becomes a slash. The slash directory delimiter becomes a dot. Looking at it from the POSIX side the translation is flipped. A POSIX path like "Project/HelloWorld/HelloWorld.c" becomes "Project.HelloWorld.HelloWorld/c" in RISC OS.

In reading of the RISC OS Open forums I heard discussions about a different approach that is more RISC OS centric. It looks like the convention in RISC OS is to put the C files in a directory called "c" and the header files in a directory called "h". Taking that approach I should instead setup my directory paths like "Project.HelloWorld.c" which in POSIX would be "Project/HelloWorld/c". It seems to make sense to follow the RISC OS convensions in this case as I am not planning to port my RISC OS C code to POSIX anytime soon and if I did I could easily write a mappnig program to do that. My path to "HelloWorld" C source should look like `$.Projects.C_Programming.c.HelloWorld`.

After storting this bit out it is time to see if I can compile a simple program with GCC and run it in a Task Window. This is a summary of my initial efforts.

First attempt steps

1. Open Task Window
2. run `gcc --version`

This failed. GCC wasn't visible to the task window. Without understanding what I was doing I decided maybe I need to launch `!GCC` in `$.Apps.Development` directory. I then tried `gcc --version` again in the Task Window and this time
the error was about not enough memory available. I looked the "Tasks" window and saw plenty of memory was free. I did NOT realise you could drag the red bar for "next" and increase the memory allocation for the next time you opened a Task Window. I didn't find that out until I did some searching and stumbled on James Hobson's videos after watching the recent WROCC Wakefield Show held in Bedford (2024).

> A clever thing about RISC OS is the graphical elements are not strictly informational. Often they are actionable. Dragging is not limited to icons.

Second attempt steps

1. Open the Tasks window, drag the memory (red bar) allocation to be more than 16K
2. Open a new Task Window
3. Find and Click on `!GCC`
4. In the task window check the GCC version number
5. Change the directory in the Task Window to where I saved "HelloWorld"
6. Check the directory with "cat"
7. Try to compile with `gcc HelloWorld -o app`, fails
8. Check GCC options with `--help`
9. Try to compiled with `gcc -x c HelloWorld -o app`, works

This sequence was more successful. I did a "cat" on the task window and saw I was not in the right folder where my "HelloWorld" was saved.  Fortunately James Hobson video shows any easy way of setting the working directory. I brought the window forward that held "HelloWorld". Then I used the middle mouse button (context menu) to "set directory". I then switched back to the Task Window and low and behold when I did a "cat" I could see my HelloWorld file.

I  tried to compile "HelloWorld". In James Hobson video he shows how to do this but I couldn't really see what he typed.  When I tried this I got an error
about the file type not being determined.  Doing `gcc --help` listed the options
and I spotted `-x` can be used to explicitly set the type from the GCC point of view. This is something to remember when using GCC. It's a POSIX program running
on RISC OS which is not a POSIX system.  GCC will expect files to have a POSIX references in some case and not others. There's a bit of trial and error around
this for me.

Next I tried using the `-x c` option. I try recompiling and after a few moments
GCC creates a "app" file in the current directory. On initial creation it is a Textfile but then the icon quickly switches to a "App/ELF" icon.  Double clicking the App icon displays hex code in the Task Window. Not what I was expected. Back in the Task Window I type the following.

~~~shell
app Henry Mable
~~~

And I get out put of

~~~shell
Hello World!
Hi Henry
Hi Mable
~~~

My program works at the CLI level in a Task Window. My initial goal has been met.

## What I learned

1. Remember that RISC OS is a fully GUI system, things you do in windows can change what happens in the whole environment
2. Remember that the display elements in the GUI maybe actionable
3. When I double clicked on `!GCC` what it did is add itself to the search path.

I remember something from the Hobson video about setting that in `!Configure`, `!Boot` and picking the right boot configuration action.  I'll leave that for next time. I should also be able to script this in an Obey file and that might be a better approach.

There are some things I learned about StrongED that were surprising. StrongED's C mode functions like a "folding" editor. I saw a red arrow next to my "main" functions. If I click it the function folds up except for the function signature and opening curly bracket. Click it again the the arrow changes direction and the full function is visible again.

The "build" icon in StrongED doesn't invoke GCC at the moment. I think the build icon in the ribbon bar maybe looking for a Makefile. If so I need to install Make from Packman. This can be left for next time.

I'd really like to change the editor colors as my eyes have trouble with white background. This too can be left for another day to figure out.

## Next Questions

1. How do I have the GCC compiled "app" so that I can double click in the file window and have it run without manually starting the Task Window and running it from there.  Is this a compiler option or do I need an Obey file?
2. Which libraries do I need to install while I wait on the DDE from ePic to arrive so that I can write a graphical version of Hello World?

## Updates

I got a chance to read more about [Obey files](https://www.riscosopen.org/wiki/documentation/show/CLI%20Basics) and also clicked through the examples in the `SDSF::RISCOSPi.$.Apps.Development.!GCC` directory (shift double click to open the GCC directory. In that directory is an examples
folder which contains a Makefile for compile C programs in various forms.
From there it was an easy stop to see how a simple Obey file could be used
to create a `!Build` and `!Cleanup` scripts.
where all the GCC setup lives). What follows are the two Obey files in the directory holding the "c" folder of HelloWorld.

Here's `!build`

~~~riscos
| !Build will run GCC on c.HelloWorld to create !HelloWorld
Set HelloWord$Dir <Obey$Dir>
WimpSlot -min 16k
gcc -static -O3 -s -O3 -o !HelloWorld c.HelloWorld
~~~

and `!Cleanup`

~~~riscos
| !Cleanup removes the binaries created with !Build
Set HelloWorld$Dir <Obey$Dir>
Delete !HelloWorld
~~~
