---
title: Bootstrapping a Text Oriented Web
byline: 'R. S. Doiel, 2024-06-14'
created: 2024-06-14T00:00:00.000Z
pubDate: 2024-06-14T00:00:00.000Z
keywords:
  - text oriented web
  - tow
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  First order of business is to shorten "text oriented web" to TOW.  It's easier
  to type and say.  I'm considering the bootstrapping process from three vantage
  points. 


  1. content author

  2. the server software

  3. client software 


  The TOW approach is avoids invention in favor of reuse. HTTP protocol is well
  specified and proven. [Common Mark](https://commonmark.org) has a
  specification as does [YAML](https://yaml.org/). TOW documents are UTF-8
  encoded. A TOW document is a composite of Common Mark with YAML blocks. TOW
  documents combined with HTTP provide a simplified hypertext platform. 


  ...
dateCreated: '2024-06-14'
dateModified: '2025-07-23'
datePublished: '2024-06-14'
---

# Bootstrapping a Text Oriented Web

By R. S. Doiel, 2024-06-14

First order of business is to shorten "text oriented web" to TOW.  It's easier to type and say.  I'm considering the bootstrapping process from three vantage points. 

1. content author
2. the server software
3. client software 

The TOW approach is avoids invention in favor of reuse. HTTP protocol is well specified and proven. [Common Mark](https://commonmark.org) has a specification as does [YAML](https://yaml.org/). TOW documents are UTF-8 encoded. A TOW document is a composite of Common Mark with YAML blocks. TOW documents combined with HTTP provide a simplified hypertext platform. 


## Authoring TOW documents

TOW seeks to simplify the content author experience. TOW removes most of the complexity of content management systems rendering processes. A TOW document only needs to be place in a directory supported by a TOW server. In that way it is as simple as [Gopher](https://en.wikipedia.org/wiki/Gopher_(protocol)). The content author should only need to know [Markdown](https://en.wikipedia.org/wiki/Markdown), specifically the [Common Markdown](https://commonmark.org/) syntax. If they want to create interactive documents or distribute metadata about their documents they will need to be comfortable creating and managing YAML blocks embedded in their Common Mark document. Use of YAML blocks is already a common practice in the Markdown community.

Describing content forms using YAML has several advantages. First it is much easier to read than HTML source. YAML blocks are not typically rendered by Markdown processor libraries. I can write a simple preprocessor which tenders the YAML content form as HTML. Since HTML is allowed in Markdown documents these could then be run through a standard Markdown to HTML converter.  In the specific case of Pandoc a filter could be written to perform the pre-processor step. It should be possible to always render a TOW document as an HTML5 document. This is deliberate, it should be possible to use the TOW documents to extrapolate a traditional website.

## Server and client software

TOW piggy backs on the HTTP protocol. A TOW document is a composite of Common Mark with embedded YAML blocks when needed. It differs from the existing WWW content only in its insistence that Common Mark and YAML be first class citizens forming a viable representation of a hypertext document. A TOW document URL looks the same as a WWW URL. The way TOW documents distinguish themselves from ordinary web content is via their content type, "text/tow" or "text/x-tow".  Content forms are sent to a TOW service using the content type "application/yaml" content type instead of the various urlencoded content types used by WWW forms. 

TOW browsers eschew client side programming. I have several reasons for specifying this. First the TOW concept is a response to current problems and practices in the WWW. I don't want to contribute to the surveillance economy. It also means that's what the client receives avoids on vector if hijacking that the WWW has battled over the years. Importantly this also keeps the TOW browser model very simple. The TOW browser renders TOW content once per load. TOW is following the path that [Gemini protocol](https://geminiprotocol.net/) and [Gemtext](https://hexdocs.pm/gemtext/Gemtext.html). Unlike Gemini it does not require a new protocol and leverages an existing markup. Like Gemini TOW is not replacing anything but only supplying an alternative.

My vision for implementing TOW is to use existing HTTP protocol. That means a TOW URL looks just like a WWW URL. How do I distinguish between WWW and TOW?  HTTP protocol supports headers. TOW native interaction should use the content type "text/tow" or "text/x-tow". Content forms submitted to a TOW native server should submit their content encoded as YAML and use the content type "text/tow" or "text/x-tow". This lets the server know that the reply should remain in "text/tow" or "text/x-tow".  A TOW enabled browser can be described as a browser that knows how to render TOW documents and submit YAML responses.

## How to proceed?

A TOW document needs to be render-able as HTML+CSS+JavaScript because that is what is available today to bootstrap TOW. The simplest TOW server just needs to be able to send TOW content to a requester with the correct content type header, e.g. "text/tow".  That means a server can be easily built in Go using the standard [net/http](https://gopkg.in/net/html) package. That same package could then be combined with a web server package to adapt it into a TOW server supporting translation to HTML+CSS+JavaScript during the bootstrap period.  If the TOW web server received a request where "text/tow" wasn't in the acceptable response list then it would return the TOW document translated to HTML+CSS+JavaScript.

A TOW native browser could be built initially as a [PWA](https://en.wikipedia.org/wiki/Progressive_web_app). It just needs to render TOW native documents as HTML5+CSS+JavaScript and be able to send TOW content forms back as YAML using the "text/tow" content type. Other client approaches could be taken, e.g. write plugin for the [Dillo browser](https://dillo-browser.github.io/), build something on [Gecko](https://developer.mozilla.org/en-US/docs/Glossary/Gecko), build something on [WebKit](https://webkit.org/), or use [Electron](https://www.electronjs.org/). A PWA is probably good enough for proof of concept.

A minimal TOW proof of concept would be the web service that can handle the translation of TOW documents to HTML+CSS+JavaScript. A complete proof of concept could be implemented TOW native support via [PWA](https://en.wikipedia.org/wiki/Progressive_web_app). 

1. tow2html5
2. towtruck (built using tow2html5)
3. towby (initially built as tow2html5 WASM module as PWA)

## Proposed programs

tow2html5
: This can be implemented in Go as both a package and command line interface. The command line interface could function either in preprocessor mode (just translating the YAML forms into HTML5) or as a full processor using an existing Common Mark package. It could also be compiled to a WASM module to support implementing a TOW browser as PWA.

towtruck
: This would be a simple web service that performed tow2html5 translation for tow document requests from non-TOW native browsers. If the accepted content type requested includes TOW native then it'd just hand back the TOW file untranslated. I would implemented this as a simple static HTTP web service running on localhost then use Lighttpd, Apache 2 or NginX for a front end web server. This simplifies the TOW native server.

towby
: A [PWA](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps) based TOW browser proof of concept