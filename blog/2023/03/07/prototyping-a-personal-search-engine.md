---
title: Prototyping a personal search engine
pubDate: 2023-03-07T00:00:00.000Z
updated: 2023-11-29T00:00:00.000Z
series: Personal Search Engine
number: 1
author: R. S. Doiel
keywords:
  - personal search engine
  - search
  - indexing
  - web
  - pagefind
copyrightYear: 2023
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  > Do we really need a search engine to index the "whole web"? Maybe a curated
  subset is better.


  Alex Schreoder's post [A Vision for
  Search](https://alexschroeder.ch/wiki/2023-03-07_A_vision_for_search) prompted
  me to write up an idea I call a "personal search engine".   I've been thinking
  about a "a personal search engine" for years, maybe a decade.


  With the current state of brokenness in commercial search engines, especially
  with the implosion of the commercial social media platforms, we have an
  opportunity to re-think search on a more personal level.


  The tooling around static site generation where a personal search is an
  extension of your own website suggests a path out of the quagmire of
  commercial search engines.  Can techniques I use for my own site search, be
  extended into a personal search engine?


  ...
dateCreated: '2023-03-07'
dateModified: '2025-07-22'
datePublished: '2023-03-07'
seriesNo: 1
---

# Prototyping a personal search engine

By R. S. Doiel, 2023-03-07

> Do we really need a search engine to index the "whole web"? Maybe a curated subset is better.

Alex Schreoder's post [A Vision for Search](https://alexschroeder.ch/wiki/2023-03-07_A_vision_for_search) prompted me to write up an idea I call a "personal search engine".   I've been thinking about a "a personal search engine" for years, maybe a decade.

With the current state of brokenness in commercial search engines, especially with the implosion of the commercial social media platforms, we have an opportunity to re-think search on a more personal level.

The tooling around static site generation where a personal search is an extension of your own website suggests a path out of the quagmire of commercial search engines.  Can techniques I use for my own site search, be extended into a personal search engine?

## A Broken Cycle

Search engines happened pretty early on in the web. If my memory is correct they showed up with the arrival of support for [CGI](https://en.wikipedia.org/wiki/Common_Gateway_Interface "Common Gateway Interface") in early web server software. Remembering back through the decades I see a pattern.

1. Someone comes up with a clever way to index web content and determine relevancy
2. They index enough the web to be interesting and attract early adopters
3. They go mainstream, this compels them to have a business model, usually some form of ad-tech
4. They index an ever larger portion of the web, the results from the search engine starts to degrade
5. The business model becomes the primary focus of the company, the indexing gets exploited (e.g. content farms, page hijacking), the search results degrade.

Stage four and five can be summed up as the "bad search engine stage". When things get bad enough a new search engine comes on the scene and the early adopters jump ship and the cycle repeats. This was well established by the time some graduate students at Stanford invented page rank. I think it is happening now with search integrated ChatGPT.

I think we're at the point in the cycle where there is an opportunity for something new. Maybe even break the loop entirely.

## How do I use search?

My use of search engines can be described in four broad categories.

1. Look for a specific answer queries
    - `spelling of <VALUE>`
    - `meaning of <VALUE>`
    - `location of <VALUE>`
    - `convert <UNIT> from <VALUE> to <UNIT>`
2. Shopping queries
    - pricing an item
    - finding an item
    - finding marketing material on an item
3. Look for subject information
    - a topic search
    - news event
    - algorithms
4. Look for information I know exists
    - technical documentation
    - an article I read
    - an article I want to read next

Most of my searches are either subject information or retrieving something I know exists. Both are particularly susceptible to degradation when the business model comes to dominate the search results.

A personal search engine for me would address these four types of searches before I reach for alternatives. In the mean time I'm stuck attempting to mitigate the bad search experience as best I can.

## Mitigating the bad search engine experience

> As commercial search engines degrade I rely on a given website's own search more

I've noticed the follow search behavior practice changes in my own web usage.  For shopping I tend to go to the vendors I trust and use their searches on their websites.  To learn about a place, it's Wikipedia and if I trying to get a sense of going there I'll probably rely on an Open Street Map to avoid the ad-tech in commercial services. I dread using the commercial maps because usage correlates so strongly with the spam I encounter the next time I use an internet connected device.

For spelling and dictionary I can use Wiktionary. Location information I use Wikipedia and Open Street Maps. Weather info I have links into [NOAA](https://www.weather.gov/) website. Do I really need to use the commercial services?

It seems obvious that the commercial services for me are at best a fallback experience. They are no longer the "go to" place on the web to find stuff. I miss the convenience of using my web browsers URL box as a search box but the noise of the commercial search engines means the convenience is not worth the cost.

What I would really like is a search service that integrated **my trusted sources** with a single search box but without the noise of the commercial sites. Is this possible? How much work would it be?

I think a personal (or even small group) search engine is plausible and desirable. I think we can build a prototype with some off the shelf parts.

## Observations

1. I only need to index a tiny subset of the web, I don't want a web crawler that needs to be monitored and managed
2. The audience of the search engine is me and possibly some friends
3. There are a huge number of existing standards, protocols and structured data formats and practices I could leverage to mange building a search corpus and for indexing.
4. Static site generators have moved site search from services (often outsourced to commercial search engines) to browser based solutions (e.g. [PageFind](https://pagefind.app), [LunrJS](https://lunrjs.com))
5. A localhost site could stage pages for indexing and I could leverage my personal website to expose my indexes to my web devices (e.g. my phone).
6. Tools like wget can mirror websites and that could also be used to stage content for a personal search engine
7. There is a growing body of Open Access data, journal articles and books, these could be indexed and made available in a personal search engine with some effort

## Exploring a personal search engine concept

When I've brought up the idea of "a personal search engine" over the years with colleagues I've been consistently surprise at the opposition I encounter.  There are so many of reasons not to build something, including a personal search engine. That has left me thinking more deeply about the problem, a good thing in my experience.  I've synthesized that resistance into three general questions. Keeping those questions in mind will be helpful in evaluating the costs in time for prototyping a personal search engine and ultimately if the prototype should turn into an open source project.

1. How would a personal search engine know/discover "new" content to include?
2. Search engines are hard to setup and maintain (e.g. Solr, Opensearch), why would I want to spend time doing that?
3. Indexing and search engines are resource intensive, isn't that going to bog down my computer?

Constraints can be a good thing to consider as well. Here's some constraints I think will be helpful when considering a prototype implementation.

- I maintain my personal website using a Raspberry Pi 400. The personal search engine needs to respect the limitations of that device.
- I'd like to be able to access my personal search engine from all my networked devices (e.g. my phone when I am away from home)
- I have little time to prototype or code anything
- I need to explain the prototype easily if I want others to help expand on the ideas
- If it breaks I need to easily fix it

I believe recent evolution of static site generation and site search offer an adjacent technology that can be leverage to demonstrate a personal search engine as a prototype. The prototype of a personal search engine could be an extension of my existing website.

## Addressing challenges

### How can a personal search engine know about new things?

The first challenge boils down to discovering content you want to index. What I'm describing is a personal search engine. I'm not trying to "index the whole web" or even a large part of it. I suspect the corpus I regularly search probably is in the neighborhood of a 100,000 pages or so. Too big for a bookmark list but magnitudes smaller than search engine deployments commonly see in an enterprise setting. I also am NOT suggesting a personal search engine will replace commercial search engines or even compete with them. What I'm thinking of is an added tool, not a replacement.

Curating content is labor intensive. This is why Yahoo evolved from a curated web directory to become a hybrid web directory plus search engine before its final demise.  I don't want to have to change how I currently find content on the web. When I do stumble on something interesting I need a mechanism to easily add it to my personal search engine. Fortunately I think my current web reading habits can function like a [mechanical Turk](https://en.wikipedia.org/wiki/Mechanical_Turk).

Most "new" content I find isn't from using a commercial search engine. When I look at my habits I find two avenues for content discovery dominate. I come across something via social media (today that's RSS feeds provided via Mastodon and Yarn Social/Twtxt) or from RSS, Atom and JSON feeds of blogs or websites I follow. Since the social media platforms I track support RSS I typically read all this content via newsboat which is a terminal based feed reader. I still find myself using the web browser's bookmark feature. It's just the bookmarks aren't helpful if they remain only in my web browser.  I also use [Pocket](https://getpocket.com) to read things later. I think all these can serve as a "link discovery" mechanism for a personal search engine. It's just a matter of collecting the URLs into a list of content I want to index, staging the content, index it and publish the resulting indexes on my personal website using a browser based search engine to query them.

This link discovery approach is different from how commercial search engines work.  Commercial engines rely on crawlers that retrieve a web page, analyze the content, find new links in the page then recursively follows those to scan whole domains and websites.  Recursive crawlers aren't automatic. It's easy for them to get trapped in link loops and often they can be a burden to the sites they are crawling (hence robot.txt files suggesting to crawlers what needs to be avoided).  I don't need to index the whole web, usually not even whole websites.  I'm interested in page level content and I can get a list of web pages from by bookmarks and the feeds I follow.


A Quick digression:

Blogs, in spite of media hype, haven't "gone away".  Presently we're seeing a bit of a renaissance with projects like [Micro.blog](https://micro.blog) and [FeedLand](http://docs.feedland.org/about.opml "this is a cool project from Dave Winer"). The "big services" like [WordPress](https://wordpress.com), [Medium](https://medium.com), [Substack](https://substack.com) and [Mailchimp](https://mailchimp.com/) provide RSS feeds for their content. RSS/Atom/JSON feed syndication all are alive and well at least for the sites I track and content I read. I suspect this is the case for others.  What is a challenge is knowing how to find the feed URL.  But even that I've notice is becoming increasingly predictable. I suspect given a list of blog sites I could come up with a way of guessing the feed URL in many cases even without an advertised URL in the HTML head or RSS link in the footer.

### Search engines are hard to setup and maintain, how can that be made easier?

I think this can be addressed in several ways. First is splitting the problem of content retrieval, indexing and search UI.  [PageFind](https://pagefind.app) is the current static site search I use on my blog.  It does a really good job at indexing blog content will little configuration. PageFind is clever about the indexes it builds.  When PageFind indexes a site is builds a partitioned index. Each partition is loaded by the web browser only when the current search string suggests it is needed. This means you can index a large number of pages (e.g. 100,000 pages) before it starts to feel sluggish. Indexing is fast and can be done on demand after harvesting the new pages you come across in your feeds. If the PageFind indexes are saved in my static site directory (a Git repository) I can implement the search UI there implementing the personal search engine prototype. The web browser is the search engine and PageFind tool is the indexer. The harvester is built by extracting interesting URLs from the feeds I follow and the current state of my web browsers' bookmarks and potentially from content in Pocket. Note the web browser bookmarks are synchronized across my devices so if I encounter an interesting URL in the physical world I can easily add it my personal search engine too the next time I process the synchronized bookmark file.

### Indexing and search engines are resource intensive, isn't that going to bog down my computer?

Enterprise Search Engine Software is complicated to setup, very resource intensive and requires upkeep. For me Solr, Elasticsearch, Opensearch falls into the category "day job" duty and I do not want that burden for my personal search engine. Fortunately I don't need to run Solr, Elasticsearch or Opensearch. I can build a decent search engine using [PageFind](https://pagefind.app).  PageFind is simple to configured, simple to index with and it's indexes scale superbly for a browser based search engine UI. Hosting is reduced to the existing effort I put into updating my personal blog and automating the link extraction from the feeds I follow and my web browsers' current bookmark file.

I currently use PageFind for web content I mirror to a search directory locally for off line reading. From that experience I know it can handle at least 100,000 pages. I know it will work on my Raspberry Pi 400. I don't see a problem in a prototype personal search engine assuming a corpus in the neighborhood of 100,000 pages.


## Sketching the prototype

Here's a sketch of a prototype of "a personal search engine" built on PageFind.

1. Generate a list of URLs pointing at pages I want to index (this can be done by mining my bookmarks and feed reader content).
2. Harvest and stage the pages on my local file system, maintaining a way to associated their actual URL with the staged copy
3. Index with PageFind and save the resulting indexes my local copy of my personal website
4. Have a page on my personal website use these indexes to implement a search and results page

The code that I would need to be implemented is mostly around extracting URL from my browser's bookmark file and my the feeds managed in my feed reader. Since newsboat is open source and it stores it cached feeds in a SQLite3 database in principle I could use the tables in that database to generate a list of content to harvest for indexing. I could write a script that combines the content from my bookmarks file and newsboat database rendering a flat list to harvest, stage and then index with PageFind. A prototype could be done in Bash or Python without too much of an effort.

One challenge remains after harvesting and staging is solved. It would be nice to use my personal search engine as my default search engine. After all I am already curating the content. I think this can be done by supporting the [Open Search Description](https://developer.mozilla.org/en-US/docs/Web/OpenSearch) to make my personal search engine a first class citizen in my browser URL bar. Similarly I could turn the personal search engine page into a PWA so I can have it on my phone's desktop along the other apps I commonly use.

Observations that maybe helpful for a successful prototype

1. I don't need to crawl the whole web just the pages that interest me
2. I don't need to create or monitor a recursive web crawler
3. I avoid junk because I'm curating the sources through my existing web reading practices
4. I am targeting a small search corpus, approximately 100,000 pages or so
5. I am only indexing HTML, Pagefind can limit the elements it indexes

A prototype of a personal search engine seems possible. The challenge will be finding the time to implement it.