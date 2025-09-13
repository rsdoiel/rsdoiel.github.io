---
title: Twitter's pending implosion
pubDate: 2022-11-11T00:00:00.000Z
byline: R. S. Doiel
author: rsdoiel@sdf.org (R. S. Doiel)
keywords:
  - small web
  - twtxt
  - micro blogging
  - social networks
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  It looks like Twitter continues to implode as layoffs and resignations
  continue. If bankers, investors and lenders call in the loans [bankruptcy
  appears to be
  possible](https://www.reuters.com/technology/twitter-information-security-chief-kissner-decides-leave-2022-11-10/).
  So what's next?



  Twitter has been troubled for some time. The advertising model corrodes
  content. Twitter is effectively a massive RSS-like distribution system. It has
  stagnated as the APIs became more restrictive. The Advertising Business Model
  via [Ad-tech](https://pluralistic.net/tag/adtech/ "per Cory Doctorow
  'ad-fraud'") encourages decay regardless of system.  Non-Twitter examples
  include commercial search engines (e.g. Google, Bing et el). Their usefulness
  usefulness declines over time. I believe this due to the increase in "noise"
  in the signal. The "noise" is driven be business models. That usually boils
  down to content who's function is to attract your attention so it can be sold
  for money. A corollary is [fear based
  journalism](https://medium.com/@oliviacadby/fear-mongering-journalisms-downfall-aac1f4f5756d).
  That has even caught the attention of a
  [Pope](https://www.9news.com.au/world/fear-based-journalism-is-terrorism-pope/4860b502-5dbb-4eef-abcf-57582445fc2c).
  Not fun.


  I suspect business models don't encourage great content. Business models are
  generally designed to turn a profit. They tend to get refined and tuned to
  that purpose. The evolution of Twitter and Google's search engine would make
  good case studies in that regard.



  ...
dateCreated: '2022-11-11'
dateModified: '2025-07-22'
datePublished: '2022-11-11'
postPath: 'blog/2022/11/11/Twitter-implosion.md'
---

Twitter's pending implosion
===========================

By R. S. Doiel, 2022-11-11

It looks like Twitter continues to implode as layoffs and resignations continue. If bankers, investors and lenders call in the loans [bankruptcy appears to be possible](https://www.reuters.com/technology/twitter-information-security-chief-kissner-decides-leave-2022-11-10/). So what's next?


The problem
-----------

Twitter has been troubled for some time. The advertising model corrodes content. Twitter is effectively a massive RSS-like distribution system. It has stagnated as the APIs became more restrictive. The Advertising Business Model via [Ad-tech](https://pluralistic.net/tag/adtech/ "per Cory Doctorow 'ad-fraud'") encourages decay regardless of system.  Non-Twitter examples include commercial search engines (e.g. Google, Bing et el). Their usefulness usefulness declines over time. I believe this due to the increase in "noise" in the signal. The "noise" is driven be business models. That usually boils down to content who's function is to attract your attention so it can be sold for money. A corollary is [fear based journalism](https://medium.com/@oliviacadby/fear-mongering-journalisms-downfall-aac1f4f5756d). That has even caught the attention of a [Pope](https://www.9news.com.au/world/fear-based-journalism-is-terrorism-pope/4860b502-5dbb-4eef-abcf-57582445fc2c). Not fun.

I suspect business models don't encourage great content. Business models are generally designed to turn a profit. They tend to get refined and tuned to that purpose. The evolution of Twitter and Google's search engine would make good case studies in that regard.


A small hope
------------

I don't know what is next but I know what I find interesting. I've looked at Mastodon a number of times. It's not going away but the W3C activity pub spec is horribly complex. Complexity slows adoption. It reminds me of SGML. Conceptually interesting but in practice was too heavy. It did form inspiration for HTML though, and that has proven successful. What gives me hope is that Mastodon has survived. I think casting a wide net is interesting. The wider net is something I've heard called the "small web".

The small web
-------------

For a number of years there has been a slowly growing  "small web" movement. I think it is relatively new term, I didn't find it in [Wikipedia](https://en.wikipedia.org/w/index.php?search=small+web&ns0=1 "today is 2022-11-11") when I looked today. As I see it the "small web" has been driven by a number of things. It is not a homogeneous movement but rather a collection of various efforts and communities.  I think it likely to continue to evolve. At times evolve rapidly. Perhaps it will coalesce at some point.  Here's what appears to me to be the common motivations as of 2022-11-11.

- desire for simplicity
- desire for authenticity
- lower resource footprint
- text as a primary but not exclusive medium
- hyperlinks encouraged
- a space where you're not a product
- desire for decentralization (so you're not a product)
- a desire to have room to grow (because you're not a product)

The "small web" is a term I've seen pop up in Gopherspace, among people who promote [Gemini](https://gemini.circumlunar.space/), [Micro blogging](https://micro.blog "as an example of micro blogging") and in the [Public Access Unix](https://sdf.org) communities."small web" as a term does not return useful results in the commercial search engines I've checked. Elements seem to be part of [DWeb](https://getdweb.net/) which Mozilla is [championing](https://wiki.mozilla.org/Dweb). Curiously in spite of the hype and marketing I don't see "small web" in [web 3.0](https://www.forbes.com/advisor/investing/cryptocurrency/what-is-web-3-0/). I think blockchain has proven environmentally dangerous and tends to compile down to various forms of [grift](https://pluralistic.net/2022/05/27/voluntary-carbon-market/).


Small web
---------

What does "small web" mean to me?  I think it means

- simple protocols that are flexible and friendly to tool creation
- built on existing network protocols with a proven track record (e.g. IPv4, IPv6)
- decentralized by design as was the early Internet
- low barrier to participation
    - e.g. a text editor, static site providing a URL to a twtxt file
- text centric (at least for the moment)
- integrated with the larger Internet, i.e. supports hyper links
- friendly to distributed personal search engines (e.g. LunrJS running over curated set of JSONfeeds or twtxt urls)
- "feed" oriented discovery based on simple formats (e.g. [RSS 2.0](https://cyber.harvard.edu/rss/rss.html), [JSONfeed](https://www.jsonfeed.org/), [twtxt](https://twtxt.readthedocs.io/en/latest/), [OPML](https://en.wikipedia.org/wiki/OPML), even [Gophermaps](https://en.wikipedia.org/wiki/Gopher_(protocol) "see Source code of a menu title"))
- sustainable and preservation friendly
    - example characteristics
        - clone-able (e.g. as easy as cloning a Git Repo)
        - push button update to Internet Archive's way back machine
        - human and machine readable metadata

I think the "small web" already exists. Examples include readable personal websites hosted as "static pages" via GitHub and S3 buckets are a good examples of prior art in a "small web".  Gopherspace is a good example of the "small web". I think the various [tilde communities](https://tilde.club) hosted on [Public Access Unix](https://en.wikipedia.org/wiki/SDF_Public_Access_Unix_System) are examples. Even the venerable "bloggosphere" of [Wordpress](https://wordpress.com) and the newer [Micro.blog](https://micro.blog/) is evidence that the "small web" already is hear. [Dave Winer](https://scripting.com)'s [Feedland](http://feedland.org/) is a good example of innovation in the "small web" happen today.  [Yarn.social](https://yarn.social) built on twtxt file format is very promising. I would argue right now the "small web" is the internet that already exists outside the walled gardens of Google, Meta/Facebook, Twitter, TikTok, Pinterest, Slack, Trello, Discord, etc.

I think it is significant that the "small web" existed before the Pandemic. It continued to thrive during it. It is likely to evolve beyond it. The pending shift has already happening as it is already populated by "early adopters" and appears to be growing into larger community participation.  For the "main stream" it is waiting to be "discovered" or perhaps "re-discovered" depending on your point of view.

How do you participate?
-----------------------

You may already be participating in the "small web".  Do you blog? Do your read feeds? Do you use a non-soloed social media platform like Mastodon? Do you use Gopher? The "small web" is defined by choice and is characterized by simplicity. It is a general term. You're the navigator not an algorithm tuned to tune someone a profit. If you are not sure where to start you can join a communities like [sdf.org](https://sdf.org) and get started there. You can explore [Gopherspace](https://floodgap.com) via a WWW proxy. You can create a static website and host a [twtxt](https://twtxt.readthedocs.io/en/latest/) file on GitHub or a [Yarn Pod](https://yarn.social). You can create a site via [Micro.blog](https://micro.blog) or [Feedland](http://feedland.org). You can blog. You can read RSS feeds or read twtxt feed with [twtxt](https://twtxt.readthedocs.io/en/latest/user/intro.html), [twet](https://github.com/quite/twet) or [yarn.social](https://yarn.social). You participate by stepping outside the walled gardens and seeing the larger "Internet".

I think the important thing is to realize the alternatives are already here, you don't need to wait for invention, invitation or permission. You can move beyond the silos today. You don't need to have your attention captured then bought and sold. It's not so much a matter of "giving up" a silo but rather stepping outside one and breathing some fresh air.

Things to watch
---------------

- [Feedland](https://feedland.org)
- [yarn.social](https://yarn.social) and [twtxt](https://twtxt.readthedocs.io/en/latest/)
- [Micro.blog](https://micro.blog/)
- [Mastodon](https://joinmastodon.org/)
- [Gopherspace](http://gopher.floodgap.com/gopher/gw?a=gopher%3A%2F%2Fgopher.floodgap.com%2F1%2Fworld), see [Gopherspace in 2020](https://cheapskatesguide.org/articles/gopherspace.html) as a nice orientation to see the internet through lynx and text
- Even [Project Gemini](https://gemini.circumlunar.space/)
