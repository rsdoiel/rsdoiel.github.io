---
title: 'PowerShell and Edit for macOS, Linux and Windows'
author: R. S. Doiel
dateCreated: '2025-06-05'
pubDate: 2025-06-05T00:00:00.000Z
keywords:
  - Windows
  - macOS
  - Linux
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  One of the challenges of multi platform support is the variance in tools. Unix
  and related operating systems are pretty unified these days. The differences
  are minor today as opposed to twenty years ago. If you need to support Windows
  too it's a whole different story. You can jump to Linux Subsystem for Windows
  but that is really like using a container inside Windows and doesn't solve the
  problem when you need to work across the whole system. 


  Windows' shell experience is varied. Originally it was command com,
  essentially a enhanced CP/M shell. Much later as Windows moved beyond then
  replaced MS-DOS they invented PowerShell. Initially a Windows only system.
  Fast forward today things have change. PowerShell runs across Windows, macOS
  and Linux. It is even licensed under an MIT style license.


  ...
dateModified: '2025-07-23'
datePublished: '2025-06-05'
---

# PowerShell and Edit on Windows, macOS and Linux

By R. S. Doiel, 2025-06-05

One of the challenges of multi platform support is the variance in tools. Unix and related operating systems are pretty unified these days. The differences are minor today as opposed to twenty years ago. If you need to support Windows too it's a whole different story. You can jump to Linux Subsystem for Windows but that is really like using a container inside Windows and doesn't solve the problem when you need to work across the whole system. 

Windows' shell experience is varied. Originally it was command com, essentially a enhanced CP/M shell. Much later as Windows moved beyond then replaced MS-DOS they invented PowerShell. Initially a Windows only system. Fast forward today things have change. PowerShell runs across Windows, macOS and Linux. It is even licensed under an MIT style license.

- <https://github.com/PowerShell/PowerShell>

PowerShell is intended as a system scripting language and as such is focused on the types of things you need too to manage a system. It has vague overtones of Java, .NET and F#. If you are familiar with those it probably feels familiar for me it wasn't familiar. Picking up PowerShell has boiled down to my thinking I can do X in Bash then doing a search to find out the equivalent in PowerShell 7 or above.  There are something examples out there that are Windows specific because there isn't a matching service under that other operating systems but if you focus on PowerShell itself rather than Windows particular feature it is very useful. It also means while you're picking up how Windows might approach something you can re-purpose that knowledge on the other operating systems. That's really handy for admin type tasks.

One of the things I've been playing with is creating a set of scripts that have a common name but deal with the specifics of the target OS. That way when I need to run a generalized task I can deploy the OS specific version to the platform but then start thinking about managing the heterogeneous environments in a unified way. E.g. scripts like "require-reboot.ps1", "safe-to-reboot.ps1", "disk-is-used-by.ps1".

Once you start getting serious about learning a system admin script language you also learn you need to vet the quality of your the scripts you are writing. On Unix I use a program called [shellcheck](https://www.shellcheck.net/) and [shfmt](https://github.com/patrickvane/shfmt) to format my scripts. How do you do that for Powershell?

Recently I discovered recently is PSScriptAnalyzer. Like shellcheck it will perform static analysis on your script and let you know of lurking issues to be aware of. The beauty of it is I can evaluate a script in PowerShell on macOS and know that I've caught issues that would have pinched me if I ran it Linux or Windows.  That's kinds of sweet.

You need to [install PSScriptAnalyzer](https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/overview?view=ps-modules) but it is easy to do under PowerShell.

~~~pwsh
Install-Module -Name PSScriptAnalyzer -Force
~~~

or

~~~pwsh
Install-PSResource -Name PSScriptAnalyzer -Reinstall
~~~

If I want [run the analyzer](https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/using-scriptanalyzer?view=ps-modules&source=recommendations) on a script called `installer.ps1` I'd run lit like

~~~psh
Invoke-ScriptAnalyzer -Path ./installer.ps1 -Settings PSGallery -Recurse
~~~

Formatting PowerShell scripts I am currently testing out [PowerShell-Beautifier](https://github.com/DTW-DanWard/PowerShell-Beautifier). It's a "cmdlet" and an easy install into PSGallery following the instructions in the GitHub repo.

Here's an example of formatting the previous example so it uses tabs instead of spaces.

~~~pwsh
Edit-DTWBeautifyScript ./installer.ps1 -IndentType Tabs
~~~

# Now that I got a shell running across systems, what about an editor?

MS-DOS acquired an editor called "edit" at some point in time (version 4 or 5?).  I remember it was a simple full screen non model editor. Recently Microsoft has created a similar editor that runs in a terminal on Windows and Linux. Like PowerShell it arrived as an Open Source Project. You don't mind some rough edges I have compiled it successfully on macOS. A few features are not implemented but it can open and save files.  It builds with the latest Rust (e.g. run `rustup update` if you haven't in a while) and generates an installable executable using Cargo. While I'm not likely to switch editors it's nice to have one that is really cross platform in doesn't require odd Unix adapter libraries to be installed to compile it. It's just a Rust program so like Go the build process is pretty consistent when you compile on Windows, Linux or macOS.

- <https://github.com/Microsoft/edit>

So you have an administrative shell environment and a common editor. If you happen to have to document admin chores across systems at least now you can document one admin language and editor and know it'll run if installed.