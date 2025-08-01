---
title: PTTK and STN
pubDate: 2022-08-15T00:00:00.000Z
updated: 2022-09-26T00:00:00.000Z
author: R. S. Doiel
byline: 'R. S. Doiel, 2022-08-15'
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >

  This log is a proof of concept in using [simple timesheet
  notation](https://rsdoiel.github.io/stngo/docs/stn.html) as a source for very
  short blog posts. The tooling is written in Golang (though eventually I hope
  to port it to Oberon-07).  The implementation combines two of my personal
  projects, [stngo](https://github.com/rsdoiel/stngo) and my experimental
  writing tool [pttk](https://github.com/rsdoiel/pttk). Updating the __pttk__
  cli I added a function to the "blogit" action that will translates the simple
  timesheet notation (aka STN) to a short blog post.  My "short post" interest
  is a response to my limited writing time. What follows is the STN markup. See
  the
  [Markdown](https://raw.githubusercontent.com/rsdoiel/rsdoiel.github.io/main/blog/2022/08/15/golang-development.md)
  source for the unprocessed text.


  ...
dateCreated: '2022-08-15'
dateModified: '2025-07-22'
datePublished: '2022-08-15'
---

Pttk and STN
============

By R. S. Doiel, started 2022-08-15
(updated: 2022-09-26, pdtk was renamed pttk)

This log is a proof of concept in using [simple timesheet notation](https://rsdoiel.github.io/stngo/docs/stn.html) as a source for very short blog posts. The tooling is written in Golang (though eventually I hope to port it to Oberon-07).  The implementation combines two of my personal projects, [stngo](https://github.com/rsdoiel/stngo) and my experimental writing tool [pttk](https://github.com/rsdoiel/pttk). Updating the __pttk__ cli I added a function to the "blogit" action that will translates the simple timesheet notation (aka STN) to a short blog post.  My "short post" interest is a response to my limited writing time. What follows is the STN markup. See the [Markdown](https://raw.githubusercontent.com/rsdoiel/rsdoiel.github.io/main/blog/2022/08/15/golang-development.md) source for the unprocessed text.

2022-08-15

16:45 - 17:45; Golang; ptdk, stngo; Thinking through what a "post" from an simple timesheet notation file should look like. One thing occurred to me is that the entry's "end" time is the publication date, not the start time. That way the post is based on when it was completed not when it was started. There is an edge case of where two entries end at the same time on the same date. The calculated filename will collide. In the `BlogSTN()` function I could check for potential file collision and either issue a warning or append. Not sure of the right action. Since I write sequentially this might not be a big problem, not sure yet. Still playing with formatting before I add this type of post to my blog. Still not settled on the title question but I need something to link to from my blog's homepage and that "title" is what I use for other posts. Maybe I should just use a command line option to provide a title?

2022-08-14

14:00 - 17:00; Golang; pdtk, stngo; Today I started an experiment. I cleaned up stngo a little today, still need to implement a general `Parse()` method that works on a `io.Reader`. After a few initial false starts I realized the "right" place for rendering simple timesheet notation as blog posts is in the the "blogit" action of [pdtk](https://rsdoiel.github.io/pttk). I think this form might be useful for both release notes in projects as well as a series aggregated from single paragraphs. The limitation of the single paragraph used in simple timesheet notation is intriguing. Proof of concept is working in v0.0.3 of pdtk. Still sorting out if I need a title and if so what it should be.

2022-08-12

16:00 - 16:30; Golang; stngo; A work slack exchange has perked my interest in using [simple timesheet notation](https://rsdoiel.github.io/stngo/docs/stn.html) for very short blog posts. This could be similar to Dave Winer title less posts on [scripting](http://scripting.com). How would this actually map? Should it be a tool in the [stngo](https://rsdoiel.githubio/stngo) project?

2022-09-26

6:30 - 7:30; Golang; pttk; renamed "pandoc toolkit" (pdtk) to "plain text toolkit" (pttk) after adding gopher support to cli. This project is less about writing tools specific to Pandoc and more about writing tools oriented around plain text.