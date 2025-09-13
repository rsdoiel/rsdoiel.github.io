---
title: Browser based site search
pubDate: 2022-11-18T00:00:00.000Z
author: rsdoiel@sdf.org (R. S. Doiel)
byline: 'R. S. Doiel, 2022-11-18'
keywords:
  - search
  - web browser
  - dweb
  - static site
  - lunrjs
  - pagefind
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  I recently read Brewster Kahle’s 2015 post about his vision for a [distributed
  web](https://brewster.kahle.org/2015/08/11/locking-the-web-open-a-call-for-a-distributed-web-2/).
  Many of his ideas have carried over into
  [DWeb](https://wiki.mozilla.org/Dweb), [Indie Web](https://indieweb.org/),
  [Small Web](https://benhoyt.com/writings/the-small-web-is-beautiful/), [Small
  Internet](https://cafebedouin.org/2021/07/28/the-small-internet/) and the
  like. A point he touches on is site search running in the web browser.


  I've use this approach in my own website relying on
  [LunrJS](https://lunrjs.com) by Oliver Nightingale. It is a common approach
  for small sites built using Markdown and [Pandoc](https://pandoc.org).  In the
  Brewster article he mentions [js-search](https://github.com/cebe/js-search),
  an implementation I was not familiar with. Like LunrJS the query engine runs
  in the browser via JavaScript but unlike LunrJS the indexes are built using
  PHP rather than JavaScript. The last couple of years I've used
  [Lunr.py](https://github.com/yeraydiazdiaz/lunr.py) to generating indexes for
  my own website site while using LunrJS for the browser side query engine.
  Today I check to see what the [Hugo](https://gohugo.io/tools/search/)
  community is using and found
  [Pagefind](https://github.com/cloudcannon/pagefind). Pagefind looks
  impressive. There was a presentation on at [Hugo Conference
  2022](https://hugoconf.io/). It takes building a Lucene-like index several
  steps further. I appears to handle much larger indexes without requiring the
  full indexes to be downloaded into the browser.  It seems like a good
  candidate for prototyping personal search engine.


  ...
dateCreated: '2022-11-18'
dateModified: '2025-07-22'
datePublished: '2022-11-18'
postPath: 'blog/2022/11/18/browser-side-site-search.md'
---

Browser based site search
=========================

By R. S. Doiel, 2022-11-18

I recently read Brewster Kahle’s 2015 post about his vision for a [distributed web](https://brewster.kahle.org/2015/08/11/locking-the-web-open-a-call-for-a-distributed-web-2/). Many of his ideas have carried over into [DWeb](https://wiki.mozilla.org/Dweb), [Indie Web](https://indieweb.org/), [Small Web](https://benhoyt.com/writings/the-small-web-is-beautiful/), [Small Internet](https://cafebedouin.org/2021/07/28/the-small-internet/) and the like. A point he touches on is site search running in the web browser.

I've use this approach in my own website relying on [LunrJS](https://lunrjs.com) by Oliver Nightingale. It is a common approach for small sites built using Markdown and [Pandoc](https://pandoc.org).  In the Brewster article he mentions [js-search](https://github.com/cebe/js-search), an implementation I was not familiar with. Like LunrJS the query engine runs in the browser via JavaScript but unlike LunrJS the indexes are built using PHP rather than JavaScript. The last couple of years I've used [Lunr.py](https://github.com/yeraydiazdiaz/lunr.py) to generating indexes for my own website site while using LunrJS for the browser side query engine. Today I check to see what the [Hugo](https://gohugo.io/tools/search/) community is using and found [Pagefind](https://github.com/cloudcannon/pagefind). Pagefind looks impressive. There was a presentation on at [Hugo Conference 2022](https://hugoconf.io/). It takes building a Lucene-like index several steps further. I appears to handle much larger indexes without requiring the full indexes to be downloaded into the browser.  It seems like a good candidate for prototyping personal search engine.

How long have been has browser side search been around? I do not remember when I started using. I explored seven projects on GitHub that implemented browser side site search. This is an arbitrary selection projects but even then I had no idea that this approach dates back a over decade!

| Project | Indexer | query engine | earliest commit[^1] | recent commit[^2] |
|---------|---------|--------------|:-------------------:|:-----------------:|
| [LunrJS](https://github.com/olivernn/lunr.js) | JavaScript | JavaScript | 2011 | 2020 |
| [Fuse.io](https://github.com/krisk/Fuse) | JavaScript/Typescript | JavaScript/Typescript | 2012 | 2022 |
| [search-index](https://github.com/fergiemcdowall/search-index) | JavaScript | JavaScript | 2013 | 2016 |
| [js-search](https://github.com/cebe/js-search) (cebe) | PHP | JavaScript | 2014 | 2022 |
| [js-search](https://github.com/bvaughn/js-search) (bvaughn)| JavaScript | JavaScript | 2015 | 2022 |
| [Lunr.py](https://github.com/yeraydiazdiaz/lunr.py) | Python | Python or JavaScript | 2018 | 2022 |
| [Pagefind](https://github.com/cloudcannon/pagefind) | Rust | WASM and JavaScript | 2022 | 2022 |

[^1]: Years are based on checking reviewing the commit history on GitHub as of 2022-11-18.

[^2]: Years are based on checking reviewing the commit history on GitHub as of 2022-11-18.
