---
title: Thinking about Gopher
pubDate: 2022-09-28T00:00:00.000Z
author: rsdoiel@gmail.com (R. S. Doiel)
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  Last weekend I visited the [Gophersphere](gopher://gopher.floodgap.com
  "Floodgap is a good starting point for Gopher") for the first time in a very
  long time. I'm happy to report it is still alive an active. It remains fast,
  lower resource consuming. This resulted in finding a Gopher protocol package
  in Go and adding light weight Gopher server to
  [pttk](https://rsdoiel.github.io/pttk) my current vehicle for experimenting
  with plain text writing tools.


  I've been thinking allot this past half week about where to explore in Gopher.
  The biggest issue I ran into turned out to be easily solve. Gopher protocol is
  traditionally served over port 70 but if you're running a \*nix if you are
  just experimenting on localhost it is easier to use port 7000 (analogous to
  port 80 becoming 8000 or 8080 in the websphere). But some Gopher clients will
  only serve port 70. Two clients work very well at 7000 and they are Lynx (the
  trusty old console web browser) and one written in Rust called
  [ncgopher](https://github.com/jansc/ncgopher). The latter I find I use most of
  the time. It also supports Gemini sites though I am less interested in Gemini
  at the movement.  Gopher has a really nice sweet spot of straight forward
  implementation for both client and server. It would be a good exercise for
  moving from beginner to intermediate programming classes as you would be
  introducing network programming, a little parsing and the client server
  application models. It's a really good use case of looking back (Gopher is
  venerable in Internet age) and looking forward (a radical simplification of
  distributing readable material and related files).


  ...
dateCreated: '2022-09-28'
dateModified: '2025-07-22'
datePublished: '2022-09-28'
keywords:
  - Gopher
---

Thinking about Gopher
=====================

By R. S. Doiel, 2022-09-28

Last weekend I visited the [Gophersphere](gopher://gopher.floodgap.com "Floodgap is a good starting point for Gopher") for the first time in a very long time. I'm happy to report it is still alive an active. It remains fast, lower resource consuming. This resulted in finding a Gopher protocol package in Go and adding light weight Gopher server to [pttk](https://rsdoiel.github.io/pttk) my current vehicle for experimenting with plain text writing tools.

I've been thinking allot this past half week about where to explore in Gopher. The biggest issue I ran into turned out to be easily solve. Gopher protocol is traditionally served over port 70 but if you're running a \*nix if you are just experimenting on localhost it is easier to use port 7000 (analogous to port 80 becoming 8000 or 8080 in the websphere). But some Gopher clients will only serve port 70. Two clients work very well at 7000 and they are Lynx (the trusty old console web browser) and one written in Rust called [ncgopher](https://github.com/jansc/ncgopher). The latter I find I use most of the time. It also supports Gemini sites though I am less interested in Gemini at the movement.  Gopher has a really nice sweet spot of straight forward implementation for both client and server. It would be a good exercise for moving from beginner to intermediate programming classes as you would be introducing network programming, a little parsing and the client server application models. It's a really good use case of looking back (Gopher is venerable in Internet age) and looking forward (a radical simplification of distributing readable material and related files).

Constraints and creativity
--------------------------

The simplicity and limitations of Gopher are inspiring. The limitations are particularly important as they are good constraints that help focus where to innovate. Gopher is a protocol ripe for software innovation precisely because of it's constraints.

Gophermaps is a good example. The Go package [git.mills.io/prologic/go-gopjer](https://git.mills.io/prologic/go-gopher) supports easily building servers that have Gophermaps the way of structuring the Gopher menus (aka selectors in Gopher parlance). A Gophermaps is a plain text file where you have lines that start with a Gopher supported document type (see [Gopher protocol](https://en.wikipedia.org/wiki/Gopher_(protocol) for details) a label followed by a tab character, a relative path followed by a tab character, a hostname followed by a tab character and a port number.  Very simple to parse.  The problem is Gopher clients expect all the fields for them to interpret them as a linked resource (e.g. a text file, binary file, image, or another Gopher selector). When I first encountered Gopher at USC so many years ago (pre-Mosaic, pre-Netscape) Gophermaps selectors are trivial to setup and you could build a service that supported ftp and Gopher in the same directory structure. All the "development" of a gopher site was done directly on the server in the directories where the files would live. Putting in all values seemed natural. Today I don't develop on a "production server" if I can avoid it. My writing is done on a small pool of machines at home, each with its own name. Explicitly writing a hostname and port with the eye to publishing to a public site then becomes a game of running `sed` to correct hostname and ports across the updated Gophermap files.

> Gopher selectors form "links" to navigate through a Gopher site or through the Gophersphere depending on what they point at

Without changing the protocol you could modify the go-gopher package's function for presenting a Gophermap where the hostname port is assumed to the gopher server name and port if it was missing. Another approach would be to translate a place holder value. This would facilitate keeping your Gopher site under version control (e.g. Git and GitHub) while allowing you to easily deploy a version of the site in a public setting or in your development setting.  The constraint of the Gophermap definition as needed by the protocol doesn't mean it forces a cumbersome choice on your writing process.

Similarly the spaces versus tabs (invisible by default in many editors) because a non-issue by adopting editors that support [editorconfig](https://editorconfig.org) or even making the server slightly more complex in correctly identifying when to convert spaces to tabs expanding them out to a Gopher selectors.

Client sites there are also many opportunities.  [Little Gopher Client](http://runtimeterror.com/tools/gopher/) pulls out the selectors its finds into a nice tree (like a bookmark tree) in a left panel and puts the text in the main window.  ncgopher let's you easily bookmark things and has a very clean, easy on the eyes reading experience in the console. In principle you the client could look at the retrieved selector and choose to display different file types based on the file extension as well as the selector type retrieved. This would let you include a richer experience in the Gophersphere for light weight markup like Commonmark files while still running nicely on Gopher protocol. Lots of room to innovate because the protocol is simple, limited and stable after all these years.