---
title: Opensearch Description Document needs love
abstract: >
  Opensearch Description Document is a specification for describing how a site
  search can integrate into your web browser. In 2025 it is still supported by
  Firefox, Safari and Chrome. It lets you integrate your site search into your
  browsers URL box (a.k.a. omnibox) as a first class search citizen. It is a
  means for us to take back search.

  In this article I use a simple case study of integrating a PageFind search
  using an Opensearch Description Document.
author: R. S. Doiel
keywords:
  - search
  - web
  - site search
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-nc-sa/4.0/'
dateCreated: '2025-08-09'
dateModified: '2025-08-09'
datePublished: '2025-08-09'
postPath: 'blog/2025/08/09/opensearch_description_documents_need_love.md'
---

# Opensearch Description Document needs love

> Allow your readers to skip the ad-tech and search your site directly

By R. S. Doiel, 2025-08-09

Opensearch Description Documents are an XML file that describes how search works on your website. The specification dates back to 2005[^01]. Opensearch Description Documents (example "osd.xml") should not be confused with [Opensearch](https://opensearch.org/) the search engine Amazon and friends forked from [ElasticSearch](https://www.elastic.co/). Despite the overlap in name they are not the same thing[^02].

The Opensearch Description Document role is to provide a little metadata about the search system and how to make a query. With this bit of information the web browser can then make that search available in the URL box (omnibox) of your web browser. Early on this was automatic but as companies have tried to monopolize search they have used security as the excuse to restrict the usage of this metadata. It still works safely in Firefox but in Safari and Chrome you have to take extra steps to use it.

## What does this mean to a site reader?

If implemented correctly the Opensearch Description Document allows integration as a "search engine" in your web browser. On Firefox that means I can see my web site's site search in the pull down list of available search engines and just add it. For [Safari](https://support.apple.com/guide/safari/search-sfria1042d31/18.0/mac/15.0 "This was the documentation I could find for Safari search options") and [Chrome](https://support.google.com/chrome/answer/95426?hl=en-IS&co=GENIE.Platform%3DDesktop "This is the doucmentation I could find from Google for Chome site search options") you must go into the settings to enable your site search.

## What does it mean as a site owner?

As a site owner I can allow my readers to search without ad-tech and spyware.  Plus I can allow my readers to initiate a site search from any web page since the URL box (omnibox) is always available regardless of which page I'm reading. The eliminates URL tricks like pasting in the search URL followed by a `?q=My%20Search%20Terms` at the end of it.

## How do I implement this?

Integrating Opensearch Description Documents requires including additional HTML elements in the head element of the HTML document. This tells the web browser where to find the XML document. It requires the creation of the XML document (e.g. "osd.xml"). It also requires that your search engine have a structured URL where the search terms can be dropped. More on that in our use case.

## Implementing the Opensearch Description Document.

The [MDN](https://developer.mozilla.org/en-US/docs/Web/XML/Guides/OpenSearch "see the docs at the Mozilla Developer Network") has a good page describing the details of creating this document. (NOTE: While XML looks a lot like HTML it is less forgiving than HTML. It must be a valid XML file.)

Below is a minimum Opensearch Description Document XML document I use on my website. It is in the root of the website and is called "osd.xml", <https://rsdoiel.github.io/osd.xml>.

~~~xml
<?xml version="1.0" encoding="UTF-8"?>
<OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/">
  <ShortName>rsdoiel</ShortName>
  <Description>Search Robert's Ramblings and Blog</Description>
  <Url type="text/html" method="get" template="https://rsdoiel.github.io/search.html?q={searchTerms}"/>
  <InputEncoding>UTF-8</InputEncoding>
  <Image height="16" width="16">https://rsdoiel.github.io/favicon.ico</Image>
</OpenSearchDescription>
~~~

The first element, **OpenSearchDescription** element, wraps the document.
Next up is **ShortName**. As the element tag suggests this is for a "show name". ShortName should be less than 14 alphanumeric characters only. I've chose my subdomain name, "rsdoiel", from the host name "rsdoiel.github.io". It can be anything you want.

After **ShowName** is an element called **Description**. This is a simple text string up to 1024 characters long. I short description. In one sentence you want to describe your search engine. In my case I chose, "Search Robert's Ramblings and Blog".

**Description** is followed by the **Url** element. This is the element that describes how to make a query. It includes the full URL to your search page and any query options needed to cause the page to return search results.  On my site I use a browser side search engine called [PageFind](https://pagefind.app). I leverage the URL query parameters to trigger the search and therefore use a "get" method. The template attribute describes how to form the URL used to retrieve search results. The text, `{searchTerms}` will get replaced by the text your type in the URL box (omnibox) of your web browser. I've setup PageFind to look at the query parameters for a "q" field and my "template" maps the value of "q" to `{searchTerms}`.

Next are **InputEncoding** which sets the encoding type and **Image** that associates an image for your search. For me I always use UTF-8 for web things and have repurposed the favicon.ico as the icon value associated with my site search.

## Hooking in "osd.xml" to your web pages.

I use CommonMark documents to build for my website and Pandoc to turn that into a webpage. I do this using a template. To integrate the Opensearch Description Document into my site I've updated the templates adding the following link element inside the head element.

~~~HTML
  <link rel="search"
        type="application/opensearchdescription+xml"
        title="Robert's Rambling Search Engine"
        href="osd.xml">
~~~

## Updating PageFind

PageFind is a search engine that works in your browser rather than on a server. It does this be creating indexes that can be downloaded as needed by your web browser. If you look at the [PageFind docs](https://pagefind.app/docs) website the basic example looks like this.

~~~JavaScript
window.addEventListener('DOMContentLoaded', (event) => {
  new PagefindUI({ element: "#search", showSubResults: true });
});
~~~

This will add a search box to the element with the id of "#search". When you type in a search term it will show results. This is fine if you directly navigate to that page. What we want is to trigger results when you navigate to the page including a "q" query parameter, <https://rsdoiel.github.io/search.html?q=osd.xml>

The first thing to support this is to retrieve the query parameter. Here's a simple function to do that.

~~~JavaScript
function getQueryParam(name) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(name);
}
~~~

When the page is loaded we use that function to retrieve any value for "q" that is available.

~~~JavaScript
const queryString = getQueryParam("q") || "";
~~~

Then when the `PageFindUI` is created we can use that object's `triggerSearch` method to trigger our search results.

~~~JavaScript
    pagefindUI.triggerSearch(queryString);
~~~

Putting it all together you add the following side the body element.

~~~JavaScript
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js"></script>
<div id="search"></div>
<script>
// Fetch the query "q" form the URL
function getQueryParam(name) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(name);
}
// When the page is loaded setup PageFindUI object.
window.addEventListener('DOMContentLoaded', (event) => {
  const pagefindUI = new PagefindUI({ element: "#search", showSubResults: true });

  const queryString = getQueryParam("q");
  // Trigger a search query if "q" is available.
  if (queryString) {
    pagefindUI.triggerSearch(queryString);
  }
});
</script>
~~~

You can see a much more elaborate version on my website, [search.html](view-source:https://rsdoiel.github.io/search.html). You can try it at <https://rsdoiel.github.io/search.html>. On my site I am bundling indexes from other GitHub repository websites to provide a common searchable collection.

## Using your site search from the URL box (omnibox)

If you're using Firefox you're in luck. When you load a website search page and then clear the menu bar you should see your search icon and pull down list of search options on the left of the URL box (omnibox).

<img src="Firefox_URL_Box.png" alt="Picture of the Firefox URL box" style="max-width:50%">

Clicking on the downward caret lists the  available search engines. Notice the "Robert's Rambling Search Engine" at the top. Clicking this will add it to the list of search engines available when typing in the URL box (omnibox).

<img src="Firefox_Search_Engine_Choice.jpg" alt="Picture of the Firefox Search Engine List" style="max-width: 30%">

Now when you want to search my web site you can click the "rsdoiel" (short name) from the pull down list.


[^01]: See https://en.wikipedia.org/wiki/OpenSearch_(specification)

[^02]: Since Amazon pushed the fork I've wondered if the name choices was deliberate to sow confusion. They want lock in just as much as the next Big Co.
