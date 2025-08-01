---
title: 'Artemis Project Status, 2022'
author: rsdoiel@gmail.com (R. S. Doiel)
date: 2022-07-27T00:00:00.000Z
keywords:
  - Oberon
  - Oberon-07
  - Artemis
copyright: 'copyright (c) 2022, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
series: Mostly Oberon
number: 22
copyrightYear: 2022
copyrightHolder: R. S. Doiel
abstract: >
  t's been a while since I wrote an Oberon-07 post and even longer since I've
  worked on Artemis. Am I done with Oberon-07 and abandoning Artemis?  No. Life
  happens and free time to just hasn't been available. I don't know when that
  will change.


  What's the path forward? ...
dateCreated: '2022-07-27'
dateModified: '2025-07-22'
datePublished: '2022-07-27'
seriesNo: 22
---

Artemis Project Status, 2022
============================

It's been a while since I wrote an Oberon-07 post and even longer since I've worked on Artemis. Am I done with Oberon-07 and abandoning Artemis?  No. Life happens and free time to just hasn't been available. I don't know when that will change.

What's the path forward?
------------------------

Since I plan to continue working Artemis I need to find a way forward in much less available time. Time to understand some of my constraints. 

1. I work on a variety of machines, OBNC is the only compiler I've consistently been able to use across all my machines
2. Porting between compilers takes energy and time, and those compilers don't work across all my machines
3. When I write Oberon-07 code I quickly hit a wall for the things I want to do, this is what original inspired Artemis, so there is still a need for a collection of modules
4. Oberon/Oberon-07 on Wirth RISC virtual machine is not sufficient for my development needs
5. A2, while very impressive, isn't working for me either (mostly because I need to work on ARM CPUs)

These constraints imply Artemis is currently too broadly scoped. I think I need to focus on what works in OBNC for now. Once I have a clear set of modules then I can revisit portability to other compilers.

What modules do I think I need? If I look at my person projects I tend to work allot with text, often structured text (e.g. XML, JSON, CSV). I also tend to be working with network services. Occasionally I need to interact with database (e.g. SQLite3, MySQL, Postgres).  Artemis should provide modules to make it easy to write code in Oberon-07 that works in those areas. Some of that I can do by wrapping existing C libraries. Some I can simply write from scratch in Oberon-07 (e.g. a JSON encoder/decoder). That's going to me my focus as my hobby time becomes available and then.