---
title: Exploring RISC OS 5.30 on a Raspberry Pi Zero W
byline: 'R. S. Doiel, 2024-06-04'
pubDate: 2024-06-04T00:00:00.000Z
abstract: |
  In this post I talk about my exploration of using a Raspberry Pi Zero W
  as a desktop computer. This was made possible by the efficiency of 
  RISC OS 5.30 which includes native WiFi support for Raspberry Pi computers.
keywords:
  - RISC OS
  - Raspberry Pi
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2024-06-04'
dateModified: '2025-07-23'
datePublished: '2024-06-04'
---

# Exploring RISC OS 5.30 on a Raspberry Pi Zero W

By R. S. Doiel, 2024-06-04

Back on April, 27, 2024 [RISC OS Open](https://riscosopen.org) [announced](https://www.riscosopen.org/news/articles/2024/04/27/risc-os-5-30-now-available) the release of RISC OS 5.30. This release includes WiFi support for the Raspberry Pi Zero W. This may sound like a small thing. WiFi is taken for granted on many other operating systems.  This is the news I've been waiting for before diving into RISC OS. My Pi Zero W running RISC OS **just works** with my wireless network. That is wonderful.

## RISC OS and Pi Zero W gives you a personal networked computer

Here's my setup.

- First generation Raspberry Pi Zero W (running RISC OS 5.30 with Pinboard2)
- Raspberry Pi Keyboard and Mouse (the keyboard provides a nice USB hub for the Zero)
- A powered portable monitory (the monitor provides power to the Pi Zero)

For additional disk storage I have a old Pi 3B+ with a 3.14G Western Digital hard drive. It is configured as a Samba file server running the bookworm release of Raspberry Pi OS[^1].

[^1]: RISC OS 5.3 only supports SMB with LANMAN1. LANMAN1 is turned off by default for Samba on R-Pi OS bookworm.

## Quick summary

I've been playing around with RISC OS 5.30  on my Pi Zero for a couple weeks now. I've really come to enjoy using it. RISC OS is different from macOS and Windows in its approach to the graphical user interface. Like with the Oberon Operating System you need to accept that difference and shed your assumptions about how things should and do work. I've found the difference invigorating. My Pi Zero with RISC OS has become my "fun desktop" for recreational computing.

## Diving in

RISC OS is a small single user operating system. It requires minimal resources. It provides a rich graphical environment. Currently RISC OS 5.30 only runs on one core of an ARM CPU. The Raspberry Pi Zero has only one core so that's a nice fit.

There is a fair amount of information regarding RISC OS online. There are active user groups and communities too.
Some of the documentation is quite good. One of the things to keep in mind if you search for "RISC OS" on the Internet is that RISC OS has forked. This is a little like the old Unix fork of BSD versus System V. They come from the same origins but have taken different paths and approaches.

>RISC OS's closed fork runs on vintage hardware and emulators only. It does not appear to be actively developed and the version numbers associated include version four and six.
>
> The [RISC OS Open](https://www.riscosopen.org) (i.e. RISC OS 5.x) fork is Open Source. It is being actively developed. It is licensed using the Apache 2 Open Source license. It runs on most versions of the Raspberry Pi. It actually runs on many single board computers. See <https://www.riscosopen.org> for details. Today it seems to be a well run Open Source project.

The reasons for the fork are complicated. From what I've read they are due to how Acorn was broken up when the company ceased to operate as Acorn.  RISC OS as intellectual property wound up in two different companies. They had two different business models and were driven by maximizing profit in the diminished Acorn market. The net resulted was a divided RISC OS community. The division included a level of acrimony. Somehow RISC OS survived this. RISC OS 5 branch even survived a bumpy road to becoming a true Open Source operating system. Today RISC OS 5.30 is licensed under the widely used Apache 2.0 Open Source license. RISC OS 5 even have a small community of commercial software developers writing and updating software for it!

If, like me, you're starting your RISC OS 5.30 on a Raspberry Pi then you're in luck. The dust seems to have settled. I highly recommend first reading the User Guide found at the bottom of the [common](https://www.riscosopen.org/content/downloads/common) page in the downloads section of the RISC OS Open website. You can also buy a printed version of the User Guide. From there head over and explore RISC OS Open community forums at <https://www.riscosopen.org/forum/>. There is also a more general Acorn enthusiast community at [stardot.co.uk](https://www.stardot.org.uk/forums/). I found this particularly helpful in understanding the historical evolution of RISC OS. Stardot even has a presence of [GitHub](https://github.com/stardot).

What follows are a semi-random set of points that I had to wrap my head around in getting oriented on RISC OS 5.30 on the Raspberry Pi Zero W.

## Visibly different

When I search for RISC OS on the [Raspberry Pi Forums](https://forums.raspberrypi.com/search.php?keywords=RISC+OS) many of the questions seemed to have more to do with user assumptions about how RISC OS works than about things actually not working. RISC OS is different. It comes from a different era. It was designed with a vastly different set of assumptions than POSIX systems like macOS, Linux, BSD, or Windows. Check your assumptions at the door.

### The mouse and its pointer

RISC OS is a three button mouse oriented system. The left and middle mouse buttons play very specific roles.  The left button is for "action" and the middle button provides a "context menu". RISC OS does not use "application menu" at the top of the screen or top of the window frame like macOS, Windows or Raspberry Pi OS. The "context menu" provides that functionality.

When you point your mouse at a screen element and press the middle button you get the context menu for that thing.  If you single or double click on an item with the left button you are taking an action.

- The left mouse button takes a action. Sometimes you use a single click and at others a double click
- The middle mouse button brings up the context menu, on RISC OS this is replaces the need for an application menu

### The Iconbar and Pinboard

When you start RISC OS you will see two main visual elements. The desktop is called the "Pinboard". This is analogous to desktops on Windows, macOS and Raspberry Pi OS.  It contains a background image and icons.

The Iconbar is the other big visible element. It is found at the bottom of the screen. The Iconbar predates Window's task bar and may have inspired it.  The Iconbar is responsibly for allowing you to access system resources and the loaded applications and modules.

On the left side of the Iconbar are icons representing system resources. This includes the SD card holding RISC OS. On the right side of the Iconbar you'll find icons that represent running applications or modules.

RISC OS is a single user operating system and relies on cooperative multitasking. An application or module can be loaded into memory and left in memory for fast reuse.  When you "launch" an application it loads into memory. To use the application you can either left double click on the icon in the Iconbar or open a file associated with the application. If you do the later then the application will automatically get added to the Iconbar if it was not already present. When you close an application's window you're not removing the application. To close an application you need to go to the Iconbar and use the context menu (remember that middle mouse button) to "quit" it.

On the left, system resources side, data storage is manipulated via the filer windows. You open a filer window by left double clicking on the resource in the Iconbar. The filer window on RISC OS plays a role similar to the file manager on Windows or a finder window on macOS.

### Iconbar and file resources

The filer maintains metadata about files. This includes the file type and the last application used to save the file. The file type is explicit with RISC OS and is NOT based on a file extension like with macOS, Windows and Raspberry Pi OS. The file path notation is also significantly different from the POSIX path syntax.

Double click on a storage resource in the Iconbar opening a filer window. The window will list files, folders and applications. The file system is hierarchical.  An icon will indicate the file type. Some icons are folders, these are sub directories of the current filer window. Most files will have other icons associated based on file type. There are special "files" that begin with an exclamation symbol, "!". In POSIX this is referred as a "bang" symbol but in RISC OS it is called a "pling".  Filenames starting with the pling hold applications. Applications are implemented as a directory containing resources. Resources might be application's visual assets, configuration, scripts or executable binaries. Directories as application will be familiar to people running modern versions of macOS or who have used NeXTStep. RISC OS usage predated both those systems. As an end user you just click on the pling name to launch the application. It will then show up in the Iconbar ready for use.

On the right side of the Iconbar are your running applications. When you first startup RISC OS you'll see two running. First, on the far right is an icon representing the hardware you're running on. If you're on a Raspberry Pi it'll be raspberry icon.  If you're running on a Pine64 Pinebook it'll be a pine cone. Since I'm on a Raspberry Pi Zero I will called it a Raspberry icon. Use your mouse and move the mouse pointer over the Raspberry icon. Left double click on the icon. This starts up a dialog box containing information about system resources. If you single click the middle button on the Raspberry icon you will get a operating system context menu. In the context menu you'll see items for "Configure" and "Task Window". The Task window provides a command line interface for RISC OS. The configure menu lets you configure how RISC OS runs. This includes things like setting the desktop theme and configuring network services.

Pointing your mouse to the left of the Raspberry will place the cursor over an icon that looks like a computer monitor.  Double left clicking on this icon will open a dialog that lets you set the resolution of your monitory. Similarly a single middle click on the icon will open a context menu.  This is a major pattern in interacting with RISC OS on the Iconbar. In fact this is the general pattern of using the mouse through out the system. It's take an action (left) or select an action to take (middle).

The Now you should see it in the Iconbar towards the right.  Note it is only visible in the Iconbar right now. This is very different than double clicking on macOS Or Windows. If you move your mouse over the icon in the Iconbar and Left double click it'll open your applications main dialog or window (just like what happened when we click on the monitor or Raspberry icons). It's a two step process.

How do you get more applications on the Iconbar?

Use the filer. The default applications are in the "Apps" icon visible on the Iconbar. Left double click on it. It'll open a filer window with an abbreviate list of applications. In that filer window look for an application called "!Alarm" (pling alarm). Double left click on that application's icon will cause it to appear in the Iconbar towards the right side. Congratulation you've loaded your first RISC OS application.

You will find more applications by looking at the contents of the SD Card. To do that double left click on the SD Card icon in the Iconbar. It'll open a filer window. You'll see a folder icon labeled "Apps". This is an actual directory on the file system. It is where applications are usually installed on RISC OS. Open that folder by double left clicking on it. You can low launch additional application by left double clicking on their pling names. These like Alarm will show up on the right side of the Iconbar.

Having things running on the Iconbar is convenient.  If you want to start a new document associated with one of the running application you just left double the icon on the Iconbar.  If you want an application to be processed by something running in the Iconbar you can draft the document from the filer window to the icon on the Iconbar. If you want to save that new document start the application from the Iconbar then use the context menu in the application window or press F3 to get the save dialog box. In the dialog box give your document a name and drag the icon of the file from the dialog box to a filer window where you want to store the document. That last step is important to note. Icons are actionable even when they appear in a dialog box! This is very unlike Windows, macOS or Raspberry Pi OS. The dragging the icon is what links data storage with the application. The next time you want to edit the file you just fine the file and left double click on it to open it. If the application isn't running then it'll be launched and added to the Iconbar automatically.

Remember when you close your application's main window or dialog box it doesn't close the application. It only close the file you were working on. To actually unload the application (and free up additional memory) point your mouse at the icon in the Iconbar and middle click to see the context menu. One of the context menu items will be "Quit", this is how you fully shutdown the application.

### Context menus

What's all this about context menus? On other operating systems the context menu is called an application menu. It might be at the top of the application window (e.g. Windows) or at the top of the screen (e.g. macOS). On Windows and macOS the words "context menu" usually mean a special sub-menu in the application (e.g. like when you use a context menu to copy a link in your web browser). In RISC OS the context menu is the application menu. It is always accessed via the middle mouse button just as we saw in introduction to the Iconbar.

Some applications like the "!StrongEd" editor do include a ribbon of icons that will make it easy to do various things. That's just a convenience. Other applications like "!Edit" don't provide this convenience. Personally I'm ambivalent to ribbon bars. I think they are most useful where you'd have to navigate down a level or two from the context menu to reach a common action you wanted to perform. There are things I don't like about the ribbon button approach. You loose window space to the ribbon. The second you are increasing the distance of mouse travel to take the action. On the other hand it beats traveling down three levels of nesting in the context menu. It's a trade off.

What ever the case remember the middle button as picking an action and the left mouse button as taking the action.

### Window frames

When you open an application from the Iconbar it'll become a window (a square on the screen containing a dialog or application content). Looking at the top of of the window frame there is are some buttons and application title area. In the upper left of the window frame you see two buttons. From left to right, the first button you see will look like two squares overlaid. Reminds me of the symbols often used when copying text.  That button is not a copy button. The two overlapping squares indicate that the current window can be sent to the bottom (furthest behind) of the stack of overlapping windows. If you think of a bunch of paper loosely stack and being read it's like taking the top paper and putting it at the back of the stack as you finish reading it. I found this very intuitive and a better experience than how you would take similar actions on macOS and Windows.

Next to the back window button is an button with an "X" on it. This button closes the window.

To the right of the close window button is the title bar. This usually shows the path to the document or data you the application is managing. You'll notice the path doesn't resemble a POSIX path or even a path as you'd find on DOS or CP/M.  I'll circle back to the RISC OS path notation in a bit. The path maybe followed by an asterisk. If the asterisk is present it indicates the data has been modified. If you try to close the window without saving a filer dialog will pop up giving a choice to discard changes, cancel closing or saving the changes. A heads up is saving is approach differently in RISC OS than on macOS or Windows.

To the right of the title bar you'll see minimize button which looks like a dash and a maximize button that looks like a square. These work similar to what you'd expect on macOS or Windows.

A scroll bar is visible on the right side and bottom. These are nice and wide. Very easy to hit using the mouse unlike modern macOS and Windows scroll bars which are fickle. There is one on the bottom the lower right of the window. The lower right that you can use to stretch or squeeze the window easily.

Along with the middle mouse button presenting the context menu you'll also notice that RISC OS makes extensive use of dialog boxes to complete actions. If you see an Icon in the dialog it's not there as a branding statement. That icon can be dragged to another window such as the Filer window to save a document. This is a significant difference between RISC OS and other operating systems. The Icon has a purpose beyond identification and branding. Moving the Icon and dropping it usually tells the OS to link two things.

### Some historical context and web browsing

RISC OS has a design philosophy and historical implementation. As I understand it the original RISC OS was written in ARM assembly language with BBC BASIC used to orchestrate the pieces written in assembly. That was how it achieved a responsive fluid system running on minimal resources. Looking back at it historically I kinda of think of BBC BASIC as a scripting language for a visual interface built from assembly language modules. The fast stuff was done in assembly but the high level bits were BBC BASIC. Today C has largely taken over the assembly language duties. It even has taken over some of the UI work too (e.g. Pinboard2 is written in C). The nice thing is BBC BASIC remains integrated and available.

> BBC BASIC isn't the BASIC I remember seeing in college.  BBC BASIC appears more thorough. It includes an inline ARM assembly language support. Check out Bruce Smith's books on ARM Assembly Language on RISC OS if you want to explore that.

Even through RISC OS was originally developed with BBC BASIC and assembler it wasn't developed in a haphazard fashion. A very modular approach was taken. Extending the operating system often means writing a module.  The clarity of the approach as much as the tenacity of the community has enable RISC OS to survive long past the demise of Acorn itself. It has also meant that as things have shifted from assembly to C that the modularity has remained strong aspect of RISC OS design and implementation.

RISC OS in spite of its over 30 years of evolution has a remarkably consistent feel. This is in part a historical accident but also a technical one in how the original system was conceived. That consistency is also one is one of its strengths. Humans tend to prefer consistency when they can get it. It is also the reasons you don't see allot of direct ports of applications from Unix, macOS (even single user system 7) or Windows. When I work on a Linux machine I expect the GUI to be inconsistent. The X Window systems was designed for flexibility and experimentation. The graphical experience only becomes consistent within the specific Linux distribution (e.g. Raspberry Pi OS). Windows also has a history of being pretty lose about it user interface. Windows user seem much happier to accept a Mac ported application then Mac users using a Windows ported one.

Why do I bring this up? Well like WiFi many people presume availability of evergreen browsers. Unlike WiFi I think I can live without Chrome and friends.  There is a browser called NetSurf that comes with RISC OS 5.30. You can view forums and community website with targeting RISC OS with it. If you're a follower of the Tidleverse you'll find NetSurf sufficient too. It's nice not running JavaScript. If you visit GitHub though it'll look very different. Some of it will not work.  Fortunately there is a new browser on the horizon called Iris. I suspect like the addition of native WiFi support you'll see a bump in usability for RISC OS when it lands.

### Access external storage

RISC OS supports access to external storage services. There are several file server types supported but I found SMB the easiest to get setup. I have a Raspberry Pi 3B+ file server running Samba on Raspberry Pi OS (bookworm). The main configuration change I needed to support talking to RISC OS was to enable LANMAN1 protocol. By default the current Samba shipping with bookworm has LANMAN1 protocol turned off (they are good reasons for this). This is added in the global section of the smb.conf file. I added the following line to turn on the protocol.

~~~shell
server min protocol = LANMAN1
~~~

Because of the vintage nature of the network calls supported and problems of WiFi being easy to sniff I opted to remove my personal directory from Samba services. I also used a different password to access Samba from my user account (see the smbpasswd manual page for how to do that).

I don't store secret or sensitive stuff on RISC OS nor do I access it from RISC OS. Like running an DOS machine security on RISC OS isn't a feature of the operating system. For casual writing, playing retro games, not a big problem but I would not do my banking on it.

### Connecting to my Raspberry Pi File Server

Once I had Samba configured to support LANMAN1 I was able to connect to it from RISC OS on the Pi Zero but it was tricky to figure out how at first.  The key was to remember to use the context menu and to use the `!OMNI` application found in the "Apps" folder on the Iconbar.

First open the Apps folder, then right double click on `!OMNI`.  This will create what looks like a file server on the left side of the Iconbar (where other disk resources are listed).  If you place your mouse pointer over it and middle click the context menu will pop up. Then navigate to the protocol menu, followed by LanMan. Clicking on LanMan should bring up a dialog box that will let you set the connection name, the name of the file server as well as the login credentials for that server.  There is no OK button. When you press enter after entering your password the dialog box knows you're done and OMNI will try to make the connection. You'll see the mouse pointer turn into an hour glass as it negotiates the connection. If the connection is successful you'll see a new window open with the resource's available from that service.

You can save yourself time by "saving" the protocol setup via the context menu. To do that you point to the OMNI icon, pull up the context menu, select protocol then select save protocol.

### RISC OS Paths

The RISC OS path semantics are NOT the same as POSIX.  The RISC OS file system is hierarchical but does not have a common root like POSIX. Today RISC OS supports several types of file systems and protocols. As a result the path has a vague resemblance to a URI.

The path starts with the protocol. This is followed by a double colon then the resource name. The resource name is followed by a period (a.k.a. dot) and then the dollar sign. The dot and dollar sign represents the root of the file system resource. The dot (period) is used as a path delimiter. It appears to be a practice to use a slash to indicate a file extension. This is important to remember. A path like `myfile.txt` on RISC OS means there is a folder called "myfile" and a file called "txt" in side it. On the other hand `myfile/txt` would translate to the POSIX form of `myfile.txt`. Fortunately the SMB client provided by OMNI handles this translation for us.

## first impressions

I find working on RISC OS refreshing. It is proving to be a good writing platform for me. I do have a short wish list. RISC OS seems like a really good platform for exploring the text oriented internet.  I would like to see both a gopher client and server implemented on RISC OS. Similarly I think Gemini protocol makes sense too.  I miss not having Pandoc available as I use that to render my writing to various formats on POSIX systems (e.g. html, pdf, ePub).

What might I build in RISC OS?  I'm not sure yet though I have some ideas. I really like RISC OS as a writing platform. The OS itself reminds me of some of the features I like in Scrivener. I wonder if Scrivener's Pinboard got its inspiration from RISC OS?

I've written Fountain, Open Screen Play, Final Draft conversion tools in Go. I'd like to have similar tools available along with a nice editor available on RISC OS. Not sure what the easiest approach to doing that is. I've ordered the [ePic](https://www.riscosopen.org/content/sales/risc-os-epic/epic-overview) SD card and that'll have the [DDE](https://www.riscosopen.org/content/sales/dde) for Raspberry Pi. It might be interesting to port OBNC Oberon-07 compiler to RISC OS and see if I could port my Go code to Oberon-07 in a sensible way.