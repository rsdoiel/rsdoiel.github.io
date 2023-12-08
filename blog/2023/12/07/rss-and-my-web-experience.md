---
title: RSS and my web experience
byline: R. S. Doiel, 2023-12-07
created: 2023-12-07
abstract: RSS is alive and kicking and Bluesky should support it too. Explore my recipe for reading web news.
series: Simplification and the Web
numnber: 1
keywords: [ "RSS", "Feeds", "Social Media", "news" ]
---

# RSS and my web experience

by R. S. Doiel, 2023-12-07

I agree with [Dave Winer](http://scripting.com/2023/12/07/140505.html?title=whyWeWantFeedsInBluesky), Blue Sky should support RSS. Most web systems benefit from supporting RSS. RSS is a base level inter-opt for web software like HTML and JSON can be. While I may not be typical I am an example of a web user who experiences much of the web via RSS. I read blog and site content via RSS. I "follow" my friends and colleagues via RSS. This is true when they blog or when they post in a Mastodon community.  I track academic repositories content for [ETH Zurich Research](https://www.rc-blog.ethz.ch/en/feed) and [Caltech](https://feeds.library.caltech.edu/recent/combined.html) via RSS feeds. I check the weather via NOAA's [RSS feed](https://www.weather.gov/rss).  News sites often syndicate still via RSS and then Podcasts, if they are actual Podcasts are distributed via RSS.  All this is to say I think RSS is not dead. It remains easy to render can can be easy to consume.  If a website doesn't provide it it is possible to generate it yourself[1] or find a service to use that does[2]. RSS remains key to how I experience and use the web in 2023.

[1]: Go libraries like [Colly](https://go-colly.org/) and [Gofeeds](https://github.com/mmcdole/gofeed) make it possible to roll your own like the one in skimmer

[2]: https://firesky.tv/ is an example of a service that provides RSS for Bluesky via its raw API, [html2rss](https://html2rss.github.io/) is service that producing RSS feeds for popular sites that don't include them

My personal approach to feeds is very much tailored to me. It's probably overkill for most people but it works with my vision and cognitive limitations. He's the steps I take in feed reading. They essentially decompose a traditional feed reader and allow for more flexibility for my reading pleasure.

1. Maintain a list of feeds in a simple text file
2. Harvest those feeds with [skimmer](https://rsdoiel.github.io/skimmer), Skimmer stores the items in an [SQLite3](https://sqlite.org)
3. I filter the items using SQL and SQLite3 or via an interactive mode provided by Skimmer
4. Render saved items to Markdown with [skim2md](https://rsdoiel.github.io/skimmer/skim2md.1.html)
5. Use [Pandoc](https://pandoc.org) to render the Markdown and view Firefox

The nice thing about this approach is that I can easily script it with Bash or even a Windows bat. I can easily maintain separate lists and separate databases for personal and work related material.  A bonus is the database items can also serve as a corpus for a personal search engine too. If you want to save maintain a public reading list this setup is ideal too. Of course the list of curated items can be transformed into their own RSS feed as well.

[Skimmer](https://rsdoiel.github.io/skimmer/skimmer.1.html) is a deconstructed feed reader. Does that make it post modern feed reader?  Skimmer processes a list of feeds I follow and saves the results in an SQLite 3 database. That database can be used to filter the feeds and flag items as "saved". Typically I filter by timestamps. Saved items can be processed with `skim2md` to render a markdown document. `skim2md` has an option to include a "save to pocket" button for each item in the output. I use Pandoc to render the page then view that result in Firefox. At my leisure I read the web page and press the "Save to pocket" button any item I want to read later. It's a very comfortable experience.

Skimmer lead me to think about a personal news page for myself and family. Skimmer lets me curate separate lists organized around themes. These can then be rendered to individual pages like pages of a newspaper. This has been captured in an experimental project I call [Antenna](https://rsdoiel.github.io/antenna). It even includes a feed search feature thanks to [PageFind](https://pagefind.app)
