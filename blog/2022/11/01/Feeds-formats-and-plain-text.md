---
title: 'feeds, formats and plain text'
author: rsdoiel@gmail.com (R. S. Doiel)
pubDate: 2022-11-01T00:00:00.000Z
keywords:
  - plain text
  - small internet
  - rss
  - jsonfeed
  - gopher
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  There has been a proliferation of feed formats. My personal preferred format
  is RSS 2.0. It's stable and proven the test of type. Atom feeds always felt a
  little like, "not invented here so we're inventing it again", type of thing.
  The claim was they could support read/write but so can RSS 2.0 specially with
  the namespace possibilities. The innovative work [Dave
  Winer](https://scripting.com) has done in the past and is doing today with
  [Feedland](https://feedland.org) is remarkably impressive.


  In my experience the format of the feed is less critical than the how to
  author the metadata.  Over the last several years I've moved to static hosting
  as my preferred way of hosting a website. My writing is typically in Markdown
  or Fountain formats and frontmatter like used in RMarkdown has proven very
  convenient. The "blogit" command that started out from an idea in
  [mkpage](https://github.com/caltechlibrary/mkpage "Make Page, a Pandoc
  preprocessor and tool set") has been implemented in
  [pttk](https://github.com/rsdoiel/pttk "Plain Text Toolkit"). So for me
  metadata authoring makes sense in the front matter. That has the advantage
  that Pandoc can leverage the information in its templates (that is what I use
  to render HTML, man pages and the occasional PDF). It also is a food source
  for data to include in a feed.


  ...
dateCreated: '2022-11-01'
dateModified: '2025-07-22'
datePublished: '2022-11-01'
---

Feeds, formats, and plain text
==============================

By R. S. Doiel, 2022-11-01

There has been a proliferation of feed formats. My personal preferred format is RSS 2.0. It's stable and proven the test of type. Atom feeds always felt a little like, "not invented here so we're inventing it again", type of thing. The claim was they could support read/write but so can RSS 2.0 specially with the namespace possibilities. The innovative work [Dave Winer](https://scripting.com) has done in the past and is doing today with [Feedland](https://feedland.org) is remarkably impressive.

In my experience the format of the feed is less critical than the how to author the metadata.  Over the last several years I've moved to static hosting as my preferred way of hosting a website. My writing is typically in Markdown or Fountain formats and frontmatter like used in RMarkdown has proven very convenient. The "blogit" command that started out from an idea in [mkpage](https://github.com/caltechlibrary/mkpage "Make Page, a Pandoc preprocessor and tool set") has been implemented in [pttk](https://github.com/rsdoiel/pttk "Plain Text Toolkit"). So for me metadata authoring makes sense in the front matter. That has the advantage that Pandoc can leverage the information in its templates (that is what I use to render HTML, man pages and the occasional PDF). It also is a food source for data to include in a feed.

I've recently become aware of a really simple text format called [twtxt](https://twtxt.readthedocs.io/en/latest/). This simple format is meant for micro blogging but is also useful as a feed source and format. Especially in terms of rendering content for Gopherspace which I've re-engaged in recently. [Yarn.social](https://yarn.social) has built an entire ecosystem around it. Very impressive. The format is so simple it can be done with a pipe and the "echo" command in the shell.  It looks promising in terms for personal search ingest as well.

One of the formats that Dave Winer supports in Feedland and is used in the micro blogging community he has connected with is [jsonfeeds](https://www.jsonfeed.org/). It is lightweight and to me feels allot like RSS 2.0 without the XML-isms that go along with it.  I'm playing with the idea that in pttk it'll be the standard feed format and that from it I can then render our traditional feed friends of RSS 2.0 and Atom.

I've looked at the ActivityPub from the Mastodon community but like [James Mill](https://prologic.github.io/prologic/ "aka prologic") I find it too complex. What is needed is something simple, really simple.  That's why I've been looking closely at Gopherspace again. The Gophermap can function as a bookmark file, a "home page" a list of feeds. A little archaic but practical in its simplicity. The only challenges I've run into has been figuring out that expectations of the Gopher server software. Currently I've settled on [gophernicus](https://gophernicus.org) as that is was it supported at [sdf.org](https://sdf.org) where I have a gopher "hole".

As pttk grows and I explore where I can take simple text processing I'm not targeting Gopherspace, twtxt and static websites. I've looked at [Gemini](https://gemini.circumlunar.space/docs/specification.gmi) but haven't grokked the point yet.  Their choice of yet another markup for content seems problematic at best. For me gopher solves the problems that would make me look at Gemini and I can use most any structured text I want. The text just needs to be readable easily by humans. The Gophermap provides can be enhanced menus much like "index.html" pages have become (a trunk that branches and eventually leads to a leaf). 

[OPML](http://home.opml.org/) remains a really nice outline data format.  It's something I'd like to eventually integrate with pttk. It can be easily represented as JSON. Just need to figure what problem I am trying to solve by using it.  Share a list of feeds is the classic case but looking at twtxt as well as the [newsboat](https://newsboat.org/) URL list makes me think it is more than I need. We'll see.  It is certainly reasonable to generate from a simpler source. If I ever write a personal search engine (something I've been thinking about to nearly a decade) it'd be a good way to share curated indexes sources as well as sources to crawl.  I just need to think that through more.