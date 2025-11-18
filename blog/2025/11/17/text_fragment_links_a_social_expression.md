---
title: Text fragment links as social expression
author: R. S. Doiel
dateCreated: "2025-11-15"
dateModified: "2025-11-18"
datePublished: "2025-11-17"
postPath: blog/2025/11/17/text_fragment_links_a_social_expression.md
description:
    An exploration of picking up text fragment links in a Markdown document
    as a means of generating "comment on" feeds.
keyword:
  - text fragment URLs
  - web
  - feeds
  - social web
---

# Text fragment links as social expression

By R. S. Doiel, 2025-11-17

Some of the attraction of the walled gardens like Instagram, X, BlueSky and Mastodon was the ease at which you can "re-post", "reply" or "quote". Automatic linking provides a smooth process. Two or more decades ago this was innovation, today your web browser supports linking via text fragments.

How do I get a text fragment link? Select a phrase or block of text in a web page. Right click to pull up the context menu. Pick the menu item "copy link to highlight". This will create the text fragment link on your computer's clipboard. Where should you paste the link?

Pasting the link into a social media site like BlueSky will focus the conversation there. You can also use the link to direct the conversation to your own site. That's helpful. I think the text fragment link can be more useful than that.

A text fragment link could be a corner stone used to assert a web of our own. The trick is to fully realize the convenience while maximizing the content expressed in the URL. I think it has a place both in the HTML page but also as an integral part of our RSS feeds.

## text fragment link as a content unit

When you choose, "copy link to highlight", you're composing a URL. It is a URL with more then a location. It is a URL that holds textual content. The text fragment link's syntax means you can target it for additional processing without needing to evaluate every other link that might be in the web page[^1]. That begs the question, what does this type of link enable?

[^1]: A text fragment link is implemented in the query string portion of the URL and that query potion starts with "`#:~:`" sequence. What follows is instructions of highlighted text to be referenced. 

Below is an example of a text fragment link that points to another of my blog posts.  It's pretty hard to read because the important bits are hidden by URL encoding.

~~~markdown
https://rsdoiel.github.io/blog/2025/11/13/urls_for_text_fragments.html#:~:text=While%20the%20URL%20syntax%20for%20text%20fragments%20is%20verbose%20getting%20a%20link%20to%20one%20is%20pretty%20easy%20with%20a%20desktop%20web%20browser%2E%20Here%27s%20the%20steps%20I%20use%20with%20desktop%20Firefox
~~~

Unpacking it you can find the link to the blog post plus the content that had been selected. If you have a url decoder handy you can break it down into its parts. Example, look at the part of that long, horrible url and look closer at the part after "`#:~:text=`". That's a description of the quote. You just need to URL decode the spaces and punctuation to recover the text the tells the web browser what to highlight when the web page is opened. Here's the decoded text.

~~~
"While the URL syntax for text fragments is verbose getting a link to one is pretty easy with a desktop web browser. Here's the steps I use with desktop Firefox."
~~~

That quote and link can form the basis of a post, a reply or a comment. It is enough to provide some context to what I want to highlight or discuss at the original URL. That URL can point anywhere on the web, not just some walled garden. Even better I can include that information as an item in an RSS feed. Syndication offers the opportunity for further discussion.

Because of the unique syntax of that type of URL the link can be easily extracted from both HTML documents and Markdown documents. That means I can turn these text fragments into a dedicated feed of things I've commented on.

## text fragment links populating a "commented on" feed

On my site I include a recent posts feed. Many blogs and news sites include a "comments" feed too.  The problem with the "comments" feed is you're handing off editorial control to someone else. This usually leads to an investment in moderation in order to avoid the inevitable arrival of spam and trolls. An alternative approach is to produce a "commented on" feed. I like this approach.

A "commented on" feed comes with advantages over an old fashioned comment system and feed.

- you own your comment, it is on your own site
- your comments are not subjected to someone elses terms of service
- your comments remain easy to reference by linking or feed
- someone else can choose to follow the things you've commented on
- if two or more people mutually subscribe to each other's "commented on" feeds a dialog can occur

Since both reader and writer have to opt in to the conversation I believe you can have higher quality engagement.

## How do you create a "commented on" feed item?

A single text fragment URL contains the location and the content to be highlighted.  What I do with the text fragment depends on my intent. A re-post would just include the highlighted text along with the link to its source. A reply or comment would be formed by adding more. Here's an example of a reply style post expressed in Markdown.

~~~markdown

> "While the URL syntax for text fragments is verbose getting a link
> to one is pretty easy with a desktop web browser. Here's the steps
> I use with desktop Firefox."

[This looks promising](https://rsdoiel.github.io/blog/2025/11/13/urls_for_text_fragments.html#:~:text=While%20the%20URL%20syntax%20for%20text%20fragments%20is%20verbose%20getting%20a%20link%20to%20one%20is%20pretty%20easy%20with%20a%20desktop%20web%20browser%2E%20Here%27s%20the%20steps%20I%20use%20with%20desktop%20Firefox)

~~~

This simple structure can easily be automated. You could create a text fragment handler in any editor that supports macros or plugins.

The point I am trying to drive home is the text fragment itself provides sufficient content to populate a post or an RSS item element. Add additional text and you have something more meaningful. A text fragment can anchor a discussion. The discussion proceeds by exchanging feed items. A feed reader or aggregator can provide conversation threading by following the trail of text fragment links.

If you use a feed oriented content system the social aspect of posts and replies becomes visible through the in bound and out bound RSS feeds. The social context sort of reveals itself naturally. You don't need a complex social graph represented by activity pub or ATProto. You use trusty old web pages and RSS feeds. The technology does not require change. We simply change how we use it.

## next steps

Today, I can manually create a post using a text fragment link. It would be better if there was some light weight automation around it. Several approaches come to mind.

- a simple tool that accepts a post filename and the text fragment link, it would then format a simple Markdown document and open it in my favorite editor for further editing
- a Markdown processor could collect text fragment links and generate a feed for that purpose
- a text editor plug-in or macro could transform a text fragment link for using as a post

It is an interesting opportunity. Little needs to be created to test the concept. Simple automation can improve the writing experience when handling text fragment links. The technical cost are limited while the practical content benefits could be large. Time for me to add this to my to do list for [antennaApp](https://github.com/rsdoiel/antennaApp).


