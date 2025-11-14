---
title: URLS for text fragments
author: R. S. Doiel
dateCreated: "2025-11-13"
dateModified: "2025-11-13"
datePublished: "2025-11-13"
postPath: "blog/2025/11/13/urls_for_text_fragments.md"
description: |
  A quick overview of text fragments expressed as URLs.
keywords:
  - url hacking
  - text fragments
  - anchors
---

# URLS for text fragments

By R. S. Doiel, 2025-11-13

A web innovation that I missed was the wide spread support for text fragments expressed as a URL. This is extremely helpful for both citation and quoting sections of a web page in a blog post. The URL syntax is now widely supported by ever green browsers (e.g. Firefox, Safari and Chrome). You can find a nice explanation at [Text fragments](https://developer.mozilla.org/en-US/docs/Web/URI/Reference/Fragment/Text_fragments) on the [MDN](https://developer.mozilla.org/en-US/docs/Web/URI/Reference/Fragment/Text_fragments) website.

The syntax is a little funky. Here's an example of selecting the second paragraph in my recent blog post [Half-life of Frameworks](https://rsdoiel.github.io/blog/2025/11/07/half-life-of-frameworks.html),

<https://rsdoiel.github.io/blog/2025/11/07/half-life-of-frameworks.html#:~:text=The%20way,choice>

The sequence `#:~:` indicates it is a link to a text fragment. The `text=The%20way,choice` essentially tells the browser to jump to the text block that starts with "The%20way" and ends with "choice". Using this URL in Firefox will bring up the web page and highlight the text fragment centering it in the view.

It is important to realize that web pages with JavaScript can break this feature. I've noticed this on sites like Substack and BlueSky. The link may bring you to the right page but will not behave as expected. Here's an example of a text fragment link that should work but doesn't

<https://sarahkendzior.substack.com/notes#:~:text=I%20was%20suspended%20from%20BlueSky%20for%20defending%20the%20honor%20of%20Johnny%20Cash%2E>

This should link to Sarah Kendzoir's note entry about being banned from BlueSky for her support of rebutting a WSJ article on Johnny Cash. Instead if you want to link to that entry you must resort to a link exposed with the  tiny ["dot dot dot" menu](https://substack.com/@sarahkendzior/note/c-176537092). 

It is not a browser bug. It's a choice of those who render pages via JavaScript. I get their commercial reasons. One more reason not to link to commercial websites and other walled gardens that break web standards.

## How do you easily generate text fragment link?

While the URL syntax for text fragments is verbose getting a link to one is pretty easy with a desktop web browser.
Here's the steps I use with desktop Firefox. 

1. navigate to the web page
2. select the text I want a link to
3. using the context menu (e.g. right click with my mouse)
4. click on "Copy Link to Highlight"

I now have a text fragment link saved to my web browser's clipboard (i.e. the copy buffer). I can now paste it into my Markdown document. These steps work on other popular desktop browsers (e.g. Safari, Orion and Chrome).

On mobile it's trickier. There isn't really a context menu like their is on the desktop. I haven't found a menu that will take a text selection from the web browser and include a "Copy Link to Highlight" option for sharing. That's shame. While I don't write blog posts on my phone I do take notes. Maybe mobile OS will catch up to that functionality in the future. I'm not holding by breath.

## text fragment URL possibilities

As commercial social web platforms continue to devolve into muck. The open web can take advantage of features text fragment URLs. This could be an advantage in demonstrating the fluidity of the open web. In my experiments I've found it easy to take advantage of text fragment links in Markdown. Their just another link.  If you're building Markdown processors you could auto-quote the text when you encounter a text fragment link. That's save some cutting and pasting in the writing process. You could even derive feeds from Markdown documents that include links expressing text fragments.  I'm hoping to have a chance to experiment with these features in my [antennaApp](https://rsdoiel.github.io/antennaApp) project.

