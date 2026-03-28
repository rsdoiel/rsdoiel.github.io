---
author: R. S. Doiel
dateCreated: "2026-03-27"
dateModified: "2026-03-27"
datePublished: "2026-03-27"
description: |
    A post about using LibreOffice Writer as a WYSIWYG Markdown editor. In it I go over
    formatting a table. What was made easy and a two challenges I ran into (frontmatter
    and code fences). It was a positive experience and I think I will be using LibreOffice
    more as a result of the Markdown feature that arrived in version 26.2.

    Short version is LibreOffice Writer can be useful in your writing workflow. Some things are a little rough around the edges but 26.2 is the first release with Markdown support. I expect this will improve over future releases. It's something to consider and keep an
    eye one.
keywords:
    - Markdown
    - LibreOffice
postPath: blog/2026/03/27/libreoffice_writer_and_markdown.md
title: LibreOffice Writer and Markdown

---


# LibreOffice Writer and Markdown

By R. S. Doiel, 2026-03-27

In the v26.2 release LibreOffice Writer picked up a new superpower.  Writer now supports reading and writing Markdown. This means we have all the power of a full blown word process and the simplicity of working with Markdown documents. This is true whether you running macOS, Windows, Linux or Raspberry Pi OS as I do. The official help documentation can be found here, <https://help.libreoffice.org/latest/en-US/text/swriter/guide/markdown.html>. Opening a Markdown document is as easy as File → Open then pick your Markdown document to edit. Saving to Markdown is just a mater of picking that document format.

Does this feature mean I will be switching from my preferred text editor to Writer? No. But it has a role. Writer offers interesting possibilities for copy edit work. Alternative document formats are an easy save away. Where I think it will come in handy is for more complex posts. Hand typing tables usually takes a pass or two of typing and then previewing the Markdown content to see if I like how the table is laying out.  That process is simplified in a word processor like Writer. That’s where WYSIWYG has an advantage. Want to insert a column into that table, no problem, that is largely automatic in a word processor. Need to insert an image?  No problem that’s an easy task too. These are things word processors have provided since before the turn of the century.

Let me give a table a try. Ctrl-F12 or the table icon on the menu bar will let me insert a table. It even lets me visual pick the size. I’ll create a three by three table.

|  |  |  |
| - | - | - |
|  |  |  |
|  |  |  |


So that was an empty 3x3 table. If I look at the source for this file it looks like correctly format Markdown. Here’s the text in a “*Preformatted Text*” style NOTE: I pasted in the text, then selected it and set the style. You can find the “*Preformatted Text*” style under the style pull down then clicking on “more styles”. This cause a panel to appear on the right side of the editing window.  The style is towards the bottom of the list. Here’s the Markdown.

~~~Markdown

|  |  |  |  
| - | - | - |  
|  |  |  |  
|  |  |  |

~~~

(NOTE: I reset to the default style before continuing). Let’s give that a try putting in some content. I well make the first row have the column heading style then following rows use the table content style

| Column One Heading | Column Two Heading | Column Three Heading |
| - | - | - |
| One | Two | Three |
| Four | Five | Six |


Adding rows at the bottom is a matter of hitting the return key in the last cell. The table menu is also available. It provides more table level control than the right click context menu. I’m going to copy and paste that example again but this time reformat the middle content to be centered and the right content to be right justified.  I want the header row to have emphasized text and each cell to be centered too. No looking up at my Markdown cheat sheet. I write the steps I took after pasting in the table below.

| **Column One Heading** | **Column Two Heading** | **Column Three Heading** |
| :-: | :-: | :-: |
| One | Two | Three |
| Four | Five | Six |


1. Click the cell “Column Two Heading”, then Table menu → select → column
2. Format Menu → Align Text → Center
3. Click the cell “Column Three Heading”, then Table menu → select → column
4. Format Menu → Align Text → Right
5. Click the cell “Column One Heading”, then Table menu → select → row
6. Format Menu → Align Text → Center
7. Format Menu → Text → Bold

Format table done. Let’s take a look and see that that looks in *Preformatted Text* style.

~~~Markdown

| **Column One Heading** | **Column Two Heading** | **Column Three Heading** |  
| - | :-: | -: |  
| One | Two | Three |  
| Four | Five | Six |

~~~

Yep, that looks like slightly more advanced Markdown table.

How about inserting an a hyperlink? Here’s the link to [my bog](https://rsdoiel.github.io/). All I did is highlight “my blog”, then Insert menu → Hyperlink. That popped up a simple dialog to setup the link. While I can type this out in my plain text editor as fast as I can click around the screen in LibreOffice it’s nice to have the option. This is particularly true when doing copy edit work. The word processor is designed to make processing words easy and largely does the heavy lifting.

Where things will get interesting is finding the right spot for LibreOffice Writer in my workflow. Conceptually it should be simple to integrate. My initial reaction as I write this blog post is the Markdown produced by Writer is clean. Clean Markdown can be rendered as clean efficient HTML easily. I will need to use writer more to discover the places which are problems. It certainly is a much better solution than I remember back in the day with people using Word or Word Perfect to generate HTML. I think LibreOffice Writer could provided human writers with a solid option if they are adverse to learning Markdown. It's nice to see the support picked in mature word processor. That offers the advantage of both using a word processor and retaining the simplicity of Markdown for hypertext documents.

## Closing thoughts

This is the first release with Markdown support. It has some bugs and issues I've discovered using it to write this post.

First issue is specific to blogging. In blogging I use [frontmatter](https://www.markdownlang.com/advanced/frontmatter.html) to include metadata in my posts. Writer doesn’t understand it. In fact it mangles it if you read in a Markdown document with it then save the results back to Markdown. So when I use LibreOffice Writer it'll be in my workflow before I add any metadata to the Markdown post.

I have hope this might change. LibreOffice Writer has support for document properties. "Properties" is the common word processor jargon for a document's metadata. Properties do work fine in formats like [ODT](https://blog.documentfoundation.org/blog/2026/03/27/odf-is-the-future-ooxml-is-the-past/). If we’re lucky it will be a feature that gets solved in the future. I don't think this is a bug, I think it is something that will get addressed in the future as a feature enhancement.

The second issue probably is a bug. It is related to expressing code samples expressed using "code fences"[^1]. I write allot about programming as a result I often include code examples. The *Preformatted Text* style when applied after pasting the text will insert the opening "code fence" but does not necessarily including a closing one. Forcing the formatting to default after the preformatted section sometimes inserts a closing code fence. I was not a 100% able to confirm when this happens and when it doesn't. Until then it'll be hard to file a useful bug report. In the mean time I've settled on finally copy edit work in my favorite plain text editor. 

[^1]: Code fences are how we express the HTML equivalent of "`<code><pre>...</pre></code>`". These can be styled in CSS to provide syntax highlighting in your code samples.

The last problem I noticed is that foot notes and end notes don't seem to get handled correctly. This could be pilot error here. I haven't used Writer in decades. When I inserted them they look right in the Writer's WYSIWYG text window but review the plain text they don't show up. Again I am not sure if this is pilot error or an actual bug.

These are small issues[^2]. There have been fewer problems than I would expect on an initial roll out of Markdown support. I am still going to use my text editor in my publication workflow. In the meantime I don't mind doing these minor cleanups and I am reasonably sure these will get addressed moving forward.

Writer shines is in its maturity as a word processor that can now work with Markdown documents. All the nice word processor features are there, spell check, thesaurus, document statistics. I suspect I will use Writer more in the coming year than I have in the decade plus since I finished grad school. With LibreOffice Writer I can harmonize my writing tools and let the written documents remain in a simple flexible format. Now it’s time to re-learn Writer and move beyond hunt and click. May even be time to start reading it's source code.

[^2]: In the end I addressed these in my text editor as I previewed content converted to HTML.

