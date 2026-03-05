---
author: R. S. Doiel
dateCreated: "2026-03-04"
dateModified: "2026-03-04"
datePublished: "2026-03-04"
description: |
    Explore the secret sauce of Markdown and frontmatter.  The post discusses how they can
    transform content management by simplifying metadata, theming, and document structure.
    Markdown with YAML frontmatter to streamline static site generation, create flexible
    themes, and even express RSS feeds and OPML aggregations. Markdown and frontmatter
    can provide a straightforward way to manage content without getting tangled in
    templates or complex tools.
keywords:
    - Markdown
    - CommonMark
    - Frontmatter
    - YAML
postPath: blog/2026/03/04/markdown_and_frontmatter.md
title: 'Markdown & Frontmatter: taking text further'

---


# Markdown & Frontmatter: Taking Text Further

By R. S. Doiel, 2026-03-04

There is a secret sauce that came with the adoption of Markdown and CommonMark in static website generators. **Frontmatter** is used to express metadata about the document. Often, this is expressed as a [block of YAML](https://jekyllrb.com/docs/front-matter/), a language created to express structured data like metadata. Early Markdown-oriented static site generators like Jekyll leveraged this language to simplify content management. Today, frontmatter and Markdown are used not only in static content management but also in the data science community, with dialects of [Markdown](https://daringfireball.net/projects/markdown/) like [RMarkdown](https://rmarkdown.rstudio.com/). What does attaching a complex structured data expression bring to the table?

This post is being typed up as a Markdown document. When I am ready to publish it to my blog, I will add YAML frontmatter. The frontmatter will be used in the site rendering process. It will include metadata such as title, authorship, dates, description, and keywords. Some of this metadata will end up in the HTML document, while some will be used to form other documents, like RSS feeds. Here’s a typical example of what I include at the top of my Markdown posts:

~~~yaml

title: Markdown and Frontmatter, taking text further
author: R. S. Doiel
dateCreated: "2026-03-04"
datePublished: "2026-03-04"
description: |
  A description of Markdown with frontmatter and a discussion of how it can be used
keywords:
  - Markdown
  - CommonMark
  - Frontmatter
  - YAML

~~~

This use case is typical in static content site generators. It allows you to keep the creation of page content simple. By attaching frontmatter at the top of the document, you also make the document’s metadata available for processing[^1]. 

[^1]: Front matter is the name of a practice adapted from print books. Printed books contain metadata at the start of books like title, authorship, publication date, publisher, copyright, preface and table of contents. This allowed for books to be easily aggregated in collections while also providing a small degree of provenance to the document. Applied in the electronic context the words "front matter" have come to form a compound word "frontmatter" in English.

My content management tool, [Antenna App](https://rsdoiel.github.io/antennaApp), like many others, uses this information to determine how to add a post or a single web page. In a dynamic content management system like WordPress or Drupal, this information is collected from a web form and stored in a database. Static site systems avoid complexity by keeping the document metadata as part of the document itself.

For a long time, I used frontmatter in my Markdown documents in just this way. Last year, I realized I could take it a step further. Markdown and frontmatter can directly express the contents of an RSS feed (for example, a list of posts) and can express aggregations of feeds in [OPML](https://en.wikipedia.org/wiki/OPML) using a similar combination of Markdown with frontmatter. Over time, as I’ve continued to develop my content management tools, I’ve taken this approach even further. You can express many parts of an assembled web page as individual Markdown documents held in a folder.

One of the challenges I’ve seen people struggle with in content management systems over the years is that you often ask creators to commit to either a specific template language (for example, PHP) or restrict them to a theme system where specialists provide the templates used to transform content into pages and posts. Theme ecosystems can become a key factor in selecting a specific CMS and are often an indicator of the adoption and health of the CMS project. In the static content management space, there is no dominant player for content management systems. While some systems are very successful (for example, Hugo, Ghost, and Jekyll), there isn't a WordPress or Drupal **equivalent**. Similarly, there isn't a single way to express themes between these systems. Often, a theme engine becomes bound up in the language implementation of the content system. Sometimes they embrace something more generic like [Handlebars](https://handlebarsjs.com/). When HTML5 added templates, they went with yet another approach. This makes moving between these systems  **challenging**. There’s a large cognitive shift when mapping one system's approach to another system's approach. Is there a possible middle ground?

## Finding a middle path by embracing Markdown

**What is a theme?** Most theme engines include some content structure (for example, headers, footers, navigation elements, and a central content block). For visual layout and design, CSS has become the de facto means to achieve visual placement. But there remains the question of content structure that is common between pages on the website. The goal of a theme is usually to specify these common elements in a uniform way to meet the needs of the website. In a language like PHP, you might output HTML with a pointer to a known CSS location. In a language like Python, you might use some template system to express this. In Go, you’d use Go’s own template language to do this or an extension of it, like that found in Hugo. Can we avoid a third language if we’re already using Markdown and a little YAML?

The humble file system provides an **opportunity**. In the theme engine of Antenna App, I’ve taken the approach that a theme is a CSS file and a set of elements based on Markdown documents, all contained within a folder. Here’s an example layout:

- theme folder
  - style.css
  - header.md
  - nav.md
  - footer.md
  - top_content.md
  - bottom_content.md

This folder represents a general structure. If one of these elements is missing, it will not be included when translating a Markdown document into HTML for presentation on the website. This simple approach means you can write your navigation element just like you write a blog post, using Markdown. The same applies to headers, footers, and any pre- or post-content information. Want to build a theme? Create a new folder. Add the specific elements you require as Markdown documents to the folder and perhaps a CSS file, too. Then apply the theme to your Antenna App site.

This approach doesn't solve the challenge of writing CSS. Fortunately, there are helpful examples of CSS that target Markdown-generated elements. Additionally, large language models can be used effectively to generate CSS for styling Markdown-generated HTML elements. So there are options for solving the CSS challenge.

In Antenna App, when you apply a theme folder, it takes the directory structure and its documents and folds them into the site or collection configuration. What I hope is that other people who write static content engines could see the value in this approach too (and improve on it!). I picture a simple tool that works similarly to Pandoc, which could convert this structure into other theme and template expressions. You could then replicate them across content management systems, giving you more flexibility as your needs change and evolve.

This would be fine if Antenna App was used by a large number of people. It isn't; it's used by me. I think the approach to theming sites can be applied to other static content systems.

## Using Pandoc as a model

Pandoc has been a tried and true converter of Markdown to HTML for a very long time. Pandoc implements CommonMark, which is an **amalgam** of Markdown extensions along with John Gruber's original specification. Pandoc is also really good at translating other document formats. It does so by leveraging an internal representation (an abstract syntax tree) so that an importer just needs to implement a single mapping, while an exporter does the reverse. What if this simple structure was used in a similar way to translate one theme system to another? While my implementation was designed for use with Antenna App, I could see translating it to work with Pandoc templates or Hugo. You'd just need to create the crosswalks.

## Wait, isn't Markdown hard to teach?

The other day, I read someone claim that Markdown is hard to teach. Having helped out with Data Carpentry courses from time to time, I'm not sure I buy that. First, when compared to HTML, there is just **a lot** less text to manage. You don't need to explain the SGML-inspired greater-than and less-than signs. You don't really need to explain structured documents initially. You start simply by asking someone to type a paragraph and see how it translates.

This isn't surprising because Markdown was inspired by what people were doing in plain text email back in the day. Similarly, you can add elaboration as it is needed. There is no worry about open and closing elements, no worry about quoting things just right. There are a few complex expressions to pick up (for example, links and embedding image references), but most plain text works as expected. There is a second hidden power in Markdown: it was designed to be easy to read. This latter part is **crucial**. Markdown is far easier to edit than XML or HTML as a result of its readability. What it gives up in the range of nuanced expression, it gains in how easy it is to learn and use day to day.

Of course, just like HTML, you can find WYSIWYG editors that support Markdown. If the editor also provides a **convenient** way to edit frontmatter, then all that I've stated before still applies. You learn one tool, and the rest just follows.

## Where does this leave us?

I think Markdown's application has, to a large extent, been a missed opportunity because it hasn't been embraced directly as a hypertext expression. I think it should be. When combined with frontmatter, it can provide all that is necessary for driving content systems. It can be used to fully express the types of files needed in a modern website, such as RSS feeds, OPML for subscription lists, and sitemaps, too. I don't think my exploration of Antenna App is the complete answer. I wrote it to fit my writing preferences. I hope others see what I've done and take things a few steps further. It's time we take back the tooling around our own writing without relying on ever more complex software to do so.
