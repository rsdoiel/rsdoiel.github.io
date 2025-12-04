---
title: Using text fragments
author: R. S. Doiel
description: |
  An example of using Antenna App's new reply action
  to transform a text fragment URL into a post. Also
  highlight a good point that Dave Winer made on his blog.
keywords:
  - text fragment URLs
  - blogging
  - antennaApp
dateCreated: "2025-12-03"
dateModified: "2025-12-03"
datePublished: "2025-12-03"
postPath: blog/2025/12/03/using_text_fragments.md
---

# Using text fragments

By R. S. Doiel, 2025-12-03


> We've forgotten how important links are

([scripting.com](http://scripting.com/2025/12/01.html#a144337:~:text=We%27ve%20forgotten%20how%20important%20links%20are), accessed 2025-12-03)

[Dave](https://scripting.com)'s right. We can't forget the humble link. His one line post nudged me to add a feature to [Antenna App](https://github.com/rsdoiel/antennaApp/releases "see v0.0.17" ). The feature is implemented as a new "action" called "reply". Here's how I started this post you're reading.

~~~shell
antenna reply http://scripting.com/2025/12/01.html#a144337:~:text=We%27ve%20forgotten%20how%20important%20links%20are
~~~

That generate a first draft of this post that looked like this.

~~~markdown

> We've forgotten how important links are

[cited](http://scripting.com/2025/12/01.html#a144337:~:text=We%27ve%20forgotten%20how%20important%20links%20are) 2025-12-03

~~~

It was enough to start things off but the "cited" isn't a useful label IMO. I wound up doing to copy editing. In the next release it'll be more like how this post started.

The reply feature is intended to be minimal. Just enough to avoid a blank page and minimizing the amount of select, copy, paste and formatting I need to do to get going.

The current implementation takes the text fragment URL and turns it into Markdown. The Markdown consists of a block quote holding the reference to what would be highlighted if you clicked the link below it. 

The code that parses the text fragment is naive. It only supports the "copy link to highlight" current generated in Desktop Firefox and Chrome. The specification has several ways of indicating the text to "highlight". You can provide the whole text to highlight (this tops out at about a sentence in Firefox). You can provide starting phrase of the text you want to highlight. You can provide start and end phrases bracketing the text to be highlight. I have only implemented the first case. I haven't found a web browser that implements the phrase parts approach yet.

Since the reply action writes to standard out I pipe the result to a draft of the post I am creating. Long run I way want to add explicit filename support, or to allow a quoted text fragment to be appended to an existing post.  

