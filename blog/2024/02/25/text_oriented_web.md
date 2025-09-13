---
title: A Text Oriented Web
createdDate: 2024-02-25T00:00:00.000Z
author: R. S. Doiel
byline: 'R. S. Doiel, 2024-02-25'
keywords:
  - web
  - text
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  The web is a busy place. There seems to be a gestalt resonant at the moment on
  the web that can be summarized by two phrases, "back to basics" and
  "simplification". It is not the first time I've seen this nor is it likely the
  last. This blog post describes a thought experiment about a simplification
  with minimal invention and focus on feature elimination. It's a way to think
  about the web status quo a little differently. My intention is to explore the
  implications of a more text centered web experience that could coexist as a
  subset of today's web.


  ...
dateCreated: '2024-02-25'
dateModified: '2025-07-23'
datePublished: '2024-02-25'
postPath: 'blog/2024/02/25/text_oriented_web.md'
---

# A Text oriented web

By R. S. Doiel, 2024-02-25

The web is a busy place. There seems to be a gestalt resonant at the moment on the web that can be summarized by two phrases, "back to basics" and "simplification". It is not the first time I've seen this nor is it likely the last. This blog post describes a thought experiment about a simplification with minimal invention and focus on feature elimination. It's a way to think about the web status quo a little differently. My intention is to explore the implications of a more text centered web experience that could coexist as a subset of today's web.

## The web's "good stuff"

I think the following could form the "good stuff" in a Crockford[^1] sense of pairing things down to the essential.

- the transport layer should remain HTTP but be limited to a few methods (GET, POST and HEAD) and the common header elements (e.g. length, content-type come to mind)
- The trio of HTML, CSS and JavaScript is really complex, swap this out for Markdown augmented with YAML (Markdown and YAML already have a synergy in Markdown processors like Pandoc)
- A Web form is expressed using GHYITS[^2], it is delimited in the Markdown document by the familiar "`^---$`" block element, web form content would be encoded as YAML in the body of the POST using the content type "`application/x-yaml`".
- Content would be served using the `text/markdown; charset: utf-8` content type already commonly used to identify Markdown content distinct from `plain/text`

I need a nice name for describing the arrangement of Markdown+YAML over HTTP arrangement. Is the descriptive acronym for "text oriented web", i.e. "tow", enough? Does it already have a meaning in software or the web? Would the protocol be "tow://"? I really need something a bit more clever and catchy if this is going to proceed beyond a thought experiment.

[^1]: Douglas Crockford "discovered" JSON, see <https://en.wikipedia.org/wiki/Douglas_Crockford>

[^2]: GHYITS, acronym, GitHub YAML Issue Template Syntax, see <https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms>

## Prototyping Options

A proof of concept could be possible using off the self web server and web browser. The missing parts would be setting up the web server to add the `text/markdown; charset: utf-8` header for "`.md`" files and to handle processing POST with a content type of `application/x-yaml`. Client side could be implemented in a static web page via JavaScript or WASM module. The JS/WASM could convert the Markdown+YAML into HTML rendering the "tow" content. The web form on submit would be intercepted by the JavaScript event handler and reformulated as a POST with a content type of `application/x-yaml`.

Building a "tow" server and client should be straight forward in Go (probably many languages). The the standard "http" package can be used to implement the specialized http server. The `yaml.v3` package to process the YAML POST data. Similar you should be able to create a text client for the command line or even a GUI client via [Fyne](https://fyne.io)

## Exploratory Questions

- What does it mean to have a more text oriented web?
- What advantages could a text user interface have over a graphical user interface?
- Can "tow" provide enough simple interactivity to support interactive fiction?
- Could a simple specification be stated clearly in a few pages of text?
- What possibilities open up when a web browser can send a data structure via YAML to a service?
- Can we live with a simpler client than a modern evergreen web browser?
- With a conversation interaction model of "listener" and a "speaker", does it make sense thinking in terms of client server architecture?
- How hard is it to support both traditional website and this minimal "tow" site using the same corpus?
- Can this be done sustainably?

## Extrapolations

From a thought experiment I can see how to implement this both from a proof of concept level but also from a service and viewer level. I think it even offers an opportunity to function in a peer to peer manner.  If we're focusing primarily on text then the storage requirements can be minimal and the service could even live in a database system like SQLite3 as a form of sandbox of content.  Leveraging HTTP/HTTPS means we don't need any special support for content traveling across the net. With a much smaller foot print you can scratch the itch of a simpler textual experience without the trackers, JavaScript ping backs, etc. It could re-emphasize the conversion versus broadcast metaphor popularized by the walled gardens.  It might provide a more satisifying experience on Mobile since the payloads delivered to the web browser could be much smaller.

## What is needed to demonstrate a standalone "tow"?

- A modified HTTP web server (easy to implement in Go and other languages)
- A viewer/browser, possible to implement via Fyne in Go or as a text application/command line interface in Go

## Why not Gopher or Gemini?

Tow is not there to replace anything, not Gopher, Not Gemini, the WWW. It is an exploration of a subset of the WWW protocols with a specific focused on textual interaction. I don't see why a server or browser couldn't support Gopher and Gemini as well as Tow. Given that Markdown can easily be rendered into Gem Text, and Markdown can be treated as plain text I suspect you should be able to support all three text rich systems from the same copy and easily derive a full HTML results if desired too.
