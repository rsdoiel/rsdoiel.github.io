---
title: Skimmer
pubDate: 2023-10-06T00:00:00.000Z
keywords:
  - feeds
  - reader
  - rss
  - atom
  - jsonfeed
author: R. S. Doiel
copyrightYear: 2023
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >2
   have a problem. I like to read my feeds in newsboat but I can't seem to get it working on a few machines I use.
  I miss having access to read feeds. Additionally there are times I would like
  to read my feeds in the same way

  I read twtxt feeds using `yarnc timeline | less -R`. Just get a list of all
  items in reverse chronological order.


  I am not interested in reinventing newsboat, it does a really good job, but I
  do want an option where newsboat isn't

  available or is not not convenient to use.  This lead me to think about an
  experiment I am calling skimmer

  . Something that works with RSS, Atom and jsonfeeds in the same way I use
  `yarnc timeline | less -R`.  

  I'm also inspired by Dave Winer's a river of news site and his outline
  tooling. But in this case I don't want

  an output style output, just a simple list of items in reverse chronological
  order. I'm thinking of a more

  ephemeral experience in reading.


  This has left me with some questions.


  ...
dateCreated: '2023-10-06'
dateModified: '2025-07-22'
datePublished: '2023-10-06'
---

# skimmer

By R. S. Doiel, 2023-10-06

I have a problem. I like to read my feeds in newsboat but I can't seem to get it working on a few machines I use.
I miss having access to read feeds. Additionally there are times I would like to read my feeds in the same way
I read twtxt feeds using `yarnc timeline | less -R`. Just get a list of all items in reverse chronological order.

I am not interested in reinventing newsboat, it does a really good job, but I do want an option where newsboat isn't
available or is not not convenient to use.  This lead me to think about an experiment I am calling skimmer
. Something that works with RSS, Atom and jsonfeeds in the same way I use `yarnc timeline | less -R`.  
I'm also inspired by Dave Winer's a river of news site and his outline tooling. But in this case I don't want
an output style output, just a simple list of items in reverse chronological order. I'm thinking of a more
ephemeral experience in reading.

This has left me with some questions.

- How simple is would it be to write skimmer?
- How much effort would be required to maintain it?
- Could this tool incorporate support for other feed types, e.g. twtxt, Gopher, Gemini?

There is a Go package called [gofeed](https://github.com/mmcdole/gofeed). The README describes it
as a "universal" feed reading parser. That seems like a good starting point and picking a very narrowly
focus task seems like a way to keep the experiment simple to implement.

## Design issues

The reader tool needs to output to standard out in the same manner as `yarnc timeline` does. The goal isn't
to be newsboat, or river of news, drummer, or Lynx but to present a stream of items usefully formatted to read
from standard output.

Some design ideas

1. Feeds should be fetched by the same tool as the reader but that should be done explicitly (downloads can take a while)
2. I want to honor that RSS does not require titles! I need to handle that case gracefully
3. For a given list of feed URLs I want to save the content in a SQLite3 database (useful down the road)
4. I'd like the simplicity of newsboat's URL list but I want to eventually support OPML import/export

# Skimmer, a thin wrapper around gofeed

In terms of working with RSS, Atom and JSON feeds the [gofeed](https://github.com/mmcdole/gofeed) takes care of
all the heavy lifting in parsing that content. The go http package provides a reliable client.
There is a pure Go package, [go-sqlite](), for integrating with SQLite 3 database. The real task is knitting this
together and a convenient package.

Here's some ideas about behavior.

To configure skimmer you just run the command. It'll create a directory at `$HOME/.skimmer` to store configuration
much like newsboat does with `$HOME/.newsboat`.

~~~
skimmer
~~~

A default URL list to be created so when running the command you have something to fetch and read.

Since fetching feed content can be slow (this is true of all news readers I've used) I think you should have to
explicitly say fetch.

~~~
skimmer -fetch
~~~

This would read the URLs in the URL list and populate a simple SQLite 3 database table. Then running skimmer again 
would display any harvested content (or running skimmer in another terminal session).

Since we're accumulating data in a database there are some house keep chores like prune that need to be supported.
Initial this can be very simple and if the experiment move forward I can improve them over time. I want something
like saying prune everything up to today.

~~~
skimmer -prune today
~~~

There are times I just want to limit the number of items displayed so a limit options makes sense

~~~
skimmer -limit 10
~~~

Since I am displaying to standard out I should be able to output via Pandoc to pretty print the content.

~~~
skimmer -limit 50 | pandoc -t markdown -f plain | less -R
~~~

That seems a like a good set of design features for an initial experiment.

## Proof of concept implementation

Spending a little time this evening. I've release a proof of concept on GitHub
at <https://github.com/rsdoiel/skimmer>, you can read the initial documentation
at [skimmer](https://rsdoiel.github.io/skimmer).