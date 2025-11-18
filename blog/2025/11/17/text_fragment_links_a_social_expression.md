---
title: Text fragment links as social expression
author: R. S. Doiel
dateCreated: "2025-11-15"
dateModified: "2025-11-17"
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

To get a text fragment link I select some text. Right click to pull up the context menu then click on "copy link to highlight" menu item. This will create the text fragment link and copy it to my system's clipboard. This chances what was an error prone many step process into a simpler two step process. It poses a new question, where should I paste this link?

The answer directs both flow and place of conversation. On a social media site like BlueSky it can let me reach out to comment on another site or point and extended response on my blog. That's helpful. I think the text fragment link can be more useful than that.

A text fragment link could be a corner stone of asserting a web of our own. The trick is to fully realize the convenience while maximizing the metadata expressed in URL form. I think it has a place both in the HTML page but also as an integral part of our RSS feeds content.

## text fragment link as a metadata object

When you choose, "copy link to highlight", you're composing a URL but a URL that much more than just a web location or citation reference. First the link syntax is uniquely identifiable in the page or document you paste it into[^1]. What does this type of link enable?

[^1]: A text fragment link is implemented in the query string portion of the URL and that query potion starts with "`#:~:`" sequence. What follows is instructions of highlighted text to be referenced. 

If I create a text fragment link I have the core element of what I am reacting to or referencing. I have quotable text. Take the link below which is to a previous blog post of mine.

~~~markdown
https://rsdoiel.github.io/blog/2025/11/13/urls_for_text_fragments.html#:~:text=While%20the%20URL%20syntax%20for%20text%20fragments%20is%20verbose%20getting%20a%20link%20to%20one%20is%20pretty%20easy%20with%20a%20desktop%20web%20browser%2E%20Here%27s%20the%20steps%20I%20use%20with%20desktop%20Firefox
~~~

It includes the source, my blog. It includes the post document expressed as an HTML page. It even includes the text I am quoting.

If you're using the text fragment content for a blockquote you can simply take the text in the URL after the "`text=`" and URL decode the rest. The previous URL would yield the Markdown style blockquote below.

~~~markdown

  "While the URL syntax for text fragments is verbose getting a link to one is pretty easy with a desktop web browser. Here's the steps I use with desktop Firefox."

~~~

That quote can form the basis of the post I write in response and I can maintained the context through the URL where it originated. This is true if I use it as a start to a post or if I embed the structure in an  RSS item element.

Because of the unique syntax of that type of URL I can be easily also extract from both HTML documents or Markdown documents. That means I can turn these fragments into stand alone feed items.

## text fragment links as "comments on" feeds

On my site I include a recent posts feed. Many blogs and news sites include a "comments" feed too.  The problem with the "comments" feed is you're handing off editorial control to some else. This usually leads to an investment in moderation in order to avoid the inevitable arrival of spam and trolls. An alternative I like changes is a "commented on" feed.

A "commented on" feed advantages include the following.

- you own your comment, it is on your own site
- you can choose to follow someone's commented on feed instead of wading through the spam and trolls
- it's asymmetric, no one else hosts your comment while it remains easily referenced
- if two or more people mutually subscribe to each other's "commented on" feeds a dialog can occur

Since both reader and writer have to opt in to the conversation I believe you can have higher quality engagement.

## How do you create a "commented on" feed item?

Again, think of the "copy link to highlight" as the metadata of a post. It provides the "context" by it's quoted highlight content. It creates a space for a specific response and it has the provenance of the whole URL.

In the example text fragment link the blockquote is formed by decoding the value indicated by "`text=`". Here's the previous link expressed as a Markdown blockquote.

~~~markdown

  "While the URL syntax for text fragments is verbose getting a link to one is pretty easy with a desktop web browser. Here's the steps I use with desktop Firefox."

~~~

What I do with this blockquote depends on my intent. A re-post would just include it along with the link to its source. Here's an example of a reply style post.

~~~markdown

  "While the URL syntax for text fragments is verbose getting a link to one is pretty easy with a desktop web browser. Here's the steps I use with desktop Firefox."

[This seems promising](https://rsdoiel.github.io/blog/2025/11/13/urls_for_text_fragments.html#:~:text=While%20the%20URL%20syntax%20for%20text%20fragments%20is%20verbose%20getting%20a%20link%20to%20one%20is%20pretty%20easy%20with%20a%20desktop%20web%20browser%2E%20Here%27s%20the%20steps%20I%20use%20with%20desktop%20Firefox)

~~~

This simple structure can easily be automated. You could create a text fragment handler in any editor that supports macros or plugins.

The point I am trying to drive home is the text fragment itself provides sufficient metadata to populate the start of a post or an RSS item element. To create a conversation two people just need to exchange feed items. I think these should be represented in a "commented on" feed. Threading can be handled by following the trail of text fragment links in two or more feeds. A feed could be a general feed for your blog or one setup specifically as a "commented on" feed. That choice is a content choice.

If you use a feed oriented content system the social aspect of posting and rendering feeds make it easy to leverage the text fragment link. The social context sort of reveals itself naturally. You don't need a complex social graph represented by activity pub or AT have been Proto. You use trusty old web tech. What changes is how we chose to use that text fragment link.

## next steps

Today, I can manually create a post leveraging a text fragment. It would be better if there was some light weight automation around it.I'm thinking about several approaches.

- a simple tool that accepts a post filename and the text fragment link, it would then format a simple Markdown document and open it in my have been  favorite editor for further editing
- a Markdown processor could collect text fragment links and generate a feed for that purpose
- A t have been ext editor that supporting plugins or a macro language could be enhanced to support the desired handling for text fragments too

It is an interesting opportunity. Little needs to be created to test  have been out the concept. Simple automation can improve the writing experience when handling text fragment links. The technical cost are limited while the practical benefits in communication content could be large. Time for me to add this to my to do list for [antennaApp](https://github.com/rsdoiel/antennaApp).


