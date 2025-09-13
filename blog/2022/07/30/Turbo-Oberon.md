---
title: 'Turbo Oberon, the dream'
author: rsdoiel@gmail.com (R. S. Doiel)
date: 2022-07-30T00:00:00.000Z
byline: R. S. Doiel
keywords:
  - Oberon
  - Wirth
  - ETH
  - dreams
  - compilers
  - operating systems
copyright: 'copyright (c) 2020, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2022
copyrightHolder: R. S. Doiel
abstract: >
  Sometimes I have odd dreams and that was true last night through early this
  morning. The dream was set in the future. I was already retired. It was a
  dream about "Turbo Oberon".


  "Turbo Oberon" was an Oberon language. The language compiler was named "TO" in
  my dream. A module's file extension was ".tom", in honor of Tom Lopez
  (Meatball Fulton) of ZBS. There were allot of ZBS references in the dream.


  "TO" was very much a language in the Oberon-07 tradition with minor extensions
  when it came to bringing in modules. It allowed for a multi path search for
  module names. You could also express a Module import as a string allowing
  providing paths to the imported module.


  Compilation was similar to Go. Cross compilation was available out of the box
  by setting a few environment variables. I remember answering questions about
  the language and its evolution. I remember mentioning in the conversation
  about how I thought Go felling into the trap of complexity like Rust or C/C++
  before it. The turning point for Go was generics. Complexity was the siren
  song to be resisted in "Turbo Oberon". Complexity is seductive to language
  designers and implementers. I was only an implementer.


  ...
dateCreated: '2022-07-30'
dateModified: '2025-07-22'
datePublished: '2022-07-30'
postPath: 'blog/2022/07/30/Turbo-Oberon.md'
---

Turbo Oberon, the dream
=======================

by R. S. Doiel, 2022-07-30

Sometimes I have odd dreams and that was true last night through early this morning. The dream was set in the future. I was already retired. It was a dream about "Turbo Oberon".

"Turbo Oberon" was an Oberon language. The language compiler was named "TO" in my dream. A module's file extension was ".tom", in honor of Tom Lopez (Meatball Fulton) of ZBS. There were allot of ZBS references in the dream.

"TO" was very much a language in the Oberon-07 tradition with minor extensions when it came to bringing in modules. It allowed for a multi path search for module names. You could also express a Module import as a string allowing providing paths to the imported module.

Compilation was similar to Go. Cross compilation was available out of the box by setting a few environment variables. I remember answering questions about the language and its evolution. I remember mentioning in the conversation about how I thought Go felling into the trap of complexity like Rust or C/C++ before it. The turning point for Go was generics. Complexity was the siren song to be resisted in "Turbo Oberon". Complexity is seductive to language designers and implementers. I was only an implementer.

Evolution wise "TO" was built initially on the Go tool chain. As a result it featured easily cross-compiled binaries and had a rich standard set of Modules like Go but also included portable libraries for implementing graphic user interfaces. "Turbo Oberon" evolved as a conversation between Go and the clean simplicity of Oberon-07. Two example applications "shipped" with the "TO" compiler. They were an Oberon like Operating System (stand alone and hosted) and a Turbo Pascal like IDE. The IDE was called "toe" for Turbo Oberon Editor. I don't remember the name of the OS implementation but it might have been "toos". I remember "TO" caused problems for search engines and catalog systems.

I remember remarking in the dream that programming in "Turbo Oberon" was a little like returning to my roots when I first learned to program in Turbo Pascal. Except I could run my programs regardless of the operating system or CPU architecture. ""TO" compiler supported cross compilation for Unix, macOS, Windows on ARM, Intel, RISC-V. The targets were inherited from Go implementation roots.

In my dream I remember forking Go 1.18 and first replacing the front end of the compiler. I remember it was a challenge understanding the implementation and generate a Go compatible AST. The mapping between Oberon-07 and Go had its challenges. I remember first sticking to a strict Oberon-07 compiler targeting POSIX before enhancing module imports. I remember several failed attempts at getting module imports "right". I remember being on the fence about a map data type and going with a Maps module.  I don't remember how introspection worked but saying it was based on an ETH paper for Oberon 2.  I remember the compiler, like Go, eventually became self hosting. It supported a comments based DSL to annotating RECORD types making encoding and decoding convenient, an influence of Go and it's tool chain.

I believe the "Turbo Oberon Editor" came first and that was followed by the operating system implementation.

I remember talking about a book that influenced me called, "Operating Systems through compilers" but don't know who wrote it. I remember a discussion about the debt owed to Prof. Wirth. I remember that the book showed how once you really understood building the compile you could then build the OS. There was a joke riffing on the old Lisp joke but rephrased, "all applications evolve not to a Lisp but to an embedded OS".

It was a pleasant dream, in the dream I was older and already retired but still writing "TO" code and having fun with computers. I remember a closing video shot showing me typing away at what looked like the old Turbo Pascal IDE. As Mojo Sam said in **Somewhere Next Door to Reality**, "it was a sorta a retro future".
