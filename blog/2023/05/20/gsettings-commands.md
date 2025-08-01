---
title: gsettings command
author: R. S. Doiel
pubDate: 2023-05-20T00:00:00.000Z
keywords:
  - Ubuntu Desktop
  - Gnome
  - gsettings
copyrightYear: 2023
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >+

  # gsettings command


  One of the things I find annoying about Ubuntu Desktop defaults is that when I
  open a new application it opens in the upper left corner. I then drag it to
  the center screen and start working. It's amazing how a small inconvenience
  can grind on you over time.  When I've search the net for changing this
  behavior the usual suggestions are "install gnome-tweaks". This seems
  ham-handed. I think continue searching and eventually find the command below.
  So I am making a note of the command here in my blog so I can find it latter.


  ~~~

  gsettings set org.gnome.mutter center-new-window true

  ~~~


dateCreated: '2023-05-20'
dateModified: '2025-07-22'
datePublished: '2023-05-20'
---

# gsettings command

One of the things I find annoying about Ubuntu Desktop defaults is that when I open a new application it opens in the upper left corner. I then drag it to the center screen and start working. It's amazing how a small inconvenience can grind on you over time.  When I've search the net for changing this behavior the usual suggestions are "install gnome-tweaks". This seems ham-handed. I think continue searching and eventually find the command below. So I am making a note of the command here in my blog so I can find it latter.

~~~
gsettings set org.gnome.mutter center-new-window true
~~~