---
title: RSS 23 years on
description: Reflection on Dave Winer's recent post "It's Really Simple"
author: R. S. Doiel
dateCreated: "2025-09-11"
dateModified: "2025-09-11"
datePublished: "2025-09-11"
postPath: "blog/2025/09/11/RSS_23_years_on.md"
---

# RSS 23 years on

By R. S. Doiel, 2025-09-11

I think Dave's post, [It's Really Simple](http://scripting.com/2025/09/11/123936.html?title=itsReallySimple), is an important read. It's shortness lends itself to reflection. **Dave takes the long view.** I think that is very healthy for the web. It's a view I've increasingly embraced over the last decade or three.

Dave's post points out 23 years after the introduction of RSS we could have seen much more creativity. In 2025 the primary contribution of web corporations is to stifle innovation. The "network effect" is their business model.They insure we're are both tenant and product. Is the solution to make complex standards that embrace the characteristics that enabled the walled gardens in the first place? I think RSS 2.0, twenty three years later, still provides a better path forward.

Do we want to be both tenant and product? If so than perhaps ATProto or ActivityPub make sense. RSS's path is far simpler. I don't think it is accidental that both Mastodon and BlueSky embraced RSS output. In 2025 lots of languages come with mature RSS libraries. Even if you need to write your own the spec is simple enough to do so.

Here are three systems I think show the longevity and possibility of RSS. Dave Winer's [FeedLand](https://feedland.org), Matt Mullenweg's [WordPress](https://wordpress.com), and Andrew Shell's port of rssCloud support from Frontier to a standalone server, [rssCloud v2](https://rpc.rsscloud.io/)[^1]. The FeedLand and WordPress show us user facing content systems with real inter-opt. Andrew's rssCloud shows us how to build a real time RSS service without tying it into a content management system directly. These are examples of a social web we can own. We're just not calling them that.

[^1]: See Andrew's notes on [his blog](https://blog.andrewshell.org/notes/rsscloud-server/) or checkout the GitHub repository at [github.com/rsscloud/rsscloud-server](https://github.com/rsscloud/rsscloud-server)

> RSS 2.0 is for the long view. As the car commercial used to say, "it's built to last".

I think BlueSky and Mastodon missed the boat skipping support for RSS 2.0 as input. I think part of the problem was how they were guided to re-implement a solution from walled gardens as an open source project. A common characteristic of systems developed by X, Meta and Google was complexity. For those companies the complexity was useful. I don't think we need that complexity if we are not building walled gardens. This missed opportunity was to assumed the "network effect" was the goal. I think communication is the goal. It can exists without scaling out to centralized walled gardens.

Here's a thought experiment, "Do complex protocols lend themselves to a diversity of implementations? Are they better suited to preservation?" I think the answer is no. I can read and process a tab delimited file from the 1970s or a comma delimited one from the 1980s. Why? It's a simple format. Simple is preservation friendly. I am certain I'll be able to read and process an RSS 2.0 file in 2050. Why, it's a simple standard. I don't think I'll be able to do that with the complex alternatives. My guess is they fall out of favor overtime and fade precisely because they're complex. Simple is a built-in preservation quality.

RSS 2.0 is stable and extensible. It has enabled Podcasting which Apple, YouTube and Spotify have yet to wall off. Podcasting, whether audio, video or text, offers us a way out. RSS allows us to say goodbye to the gate keepers like X, Meta, Google, Apple et el. We don't need a __Web 3.0__. What we need to embrace is the web and internet as common nouns. Write and deploy from our own machines. Connect them through the networks and eventually land content on the __Web__ or __Internet__ based on open standards and inter-opt. Let's skip the business models of wall gardens this time around.

When people mention the foundations of the web they typically mention HTTP, HTML, CSS and JavaScript as if their are just four pillars of the web. I think they are missing a fifth column, RSS 2.0. It provides the proven means of an open syndication system that continues to work after 23 years. 

The final reflection I'd like to focus on in Dave's post is Markdown. Markdown is a hypertext document format that is easier to type and proof read than HTML. I think it is where an alternative to the walled gardens can shine.  It works as an enclosure in the [Textcasting](https://textcasting.org) context.  Markdown with front matter allows non-programmers to manage the metadata associated with their documents be they blog posts or academic papers[^2]. It's a simple format, simpler than HTML. It's a format that lends itself to preservation in much the same way RSS 2.0 does.

[^2]: An example is R-Studio and RMarkdown or Jupyter Notebooks used in the academic and research science community. Functionality and features are enabled or activated by the metadata presented as front matter encoded using [YAML](https://yaml.org/).

In my own modest effort to create [the writing environment I want](https://rsdoiel.github.io/antennaApp "antennaApp is a feed oriented static content system build around Markdown and RSS 2.0"), I have relied on Markdown and RSS 2.0. Why? Because RSS 2.0 is a stable spec. I've embraced [CommonMark](https://commonmark.org) alongside with John Grubber's [Markdown](https://daringfireball.net/projects/markdown/) for writing because I can proof read it easier than proof reading HTML. It's a format you can read without conversion and if you do want to render as HTML that is easy to do too. With Markdown I can start something on my phone in a simple text editor. I can add that document to my blog to be rendered as HTML or into an RSS 2.0 feed. When I do so it all works because of inter-opt provided by RSS 2.0.

The web of 2025 can be open if we choose to open it up. Embrace not the "Web" as proper noun owned by corporations but the "web" as a common noun which we can also own a part. Step out the silos and see the wild lands of the real web. See their beauty and create them for yourself.
