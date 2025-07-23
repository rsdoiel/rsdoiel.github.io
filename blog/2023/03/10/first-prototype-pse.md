---
title: First Personal Search Engine Prototype
pubDate: 2023-03-10T00:00:00.000Z
updated: 2023-11-29T00:00:00.000Z
author: R. S. Doiel
series: Personal Search Engine
number: 2
keywords:
  - personal search engine
  - search
  - indexing
  - web
  - pagefind
copyrightYear: 2023
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  've implemented a first prototype of my personal search engine which

  I will abbreviate as "pse" from here on out. I implemented it using 

  three [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) scripts

  relying on [sqlite3](https://sqlite.org),
  [wget](https://en.wikipedia.org/wiki/Wget) and
  [PageFind](https://pagefind.app) to do the heavy lifting.


  Both Firefox and newsboat store useful information in sqlite databases. 
  Firefox's `moz_places.sqlite` holds both all the URLs visited as well as those
  that are associated with bookmarks (i.e. the SQLite database
  `moz_bookmarks.sqlite`).  I had about 2000 bookmarks, less than I thought with
  many being stale from link rot. Stale page URLs really slow down the harvest
  process because of the need for wget to wait on various timeouts (e.g. DNS,
  server response, download times).  The "history" URLs would make an
  interesting collection to spider but you'd probably want to have an exclude
  list (e.g. there's no point in saving queries to search engines, web mail,
  shopping sites). Exploring that will wait for another prototype.


  ...
dateCreated: '2023-03-10'
dateModified: '2025-07-22'
datePublished: '2023-03-10'
seriesNo: 2
---

# First Personal Search Engine Prototype

By R. S. Doiel, 2023-08-10

I've implemented a first prototype of my personal search engine which
I will abbreviate as "pse" from here on out. I implemented it using 
three [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) scripts
relying on [sqlite3](https://sqlite.org), [wget](https://en.wikipedia.org/wiki/Wget) and [PageFind](https://pagefind.app) to do the heavy lifting.

Both Firefox and newsboat store useful information in sqlite databases.  Firefox's `moz_places.sqlite` holds both all the URLs visited as well as those that are associated with bookmarks (i.e. the SQLite database `moz_bookmarks.sqlite`).  I had about 2000 bookmarks, less than I thought with many being stale from link rot. Stale page URLs really slow down the harvest process because of the need for wget to wait on various timeouts (e.g. DNS, server response, download times).  The "history" URLs would make an interesting collection to spider but you'd probably want to have an exclude list (e.g. there's no point in saving queries to search engines, web mail, shopping sites). Exploring that will wait for another prototype.

The `cache.db` associated with Newsboat provided a rich resource of content and much fewer stale links (not surprising because I maintain that URL list more much activity then reviewing my bookmarks).  Between the two I had 16,000 pages. I used SQLite 3 to query the url values from the various DB into sorting for unique URLs into a single text file one URL per line.

The next thing after creating a list of pages I wanted to search was to download them into a directory using wget.  Wget has many options, I choose to enable timestamping, create a protocol directory and then a domain and path directory for each item. This has the advantage of being able to transform the Path into a URL later.

Once the content was harvested I then used PageFind to index the all the harvested content. Since I started using PageFind originally the tool has gained an option called `--serve` which provides a localhost web service on port 1414.  All I needed to do was add an index.html file to the directory where I harvested the content and saved the PageFind indexes. Then I used PageFind to again to provide a localhost based personal search engine.

While the total number of pages was small (16k pages) I did find interesting results just trying out random words. This makes the prototype look promising.

## Current prototype components

I have simple Bash script that gets the URLs from both Firefox bookmarks and Newsboat's cache then generates a single text file of unique URLs I've named "pages.txt".

I then use the "pages.txt" file to harvest content with wget into a tree structure like 

- htdocs
    - http (all the http based URLs I harvest go in here)
    - https (all the https based URLs I harvest go in here)
    - pagefind (this holds the PageFind indexes and JavaScript to implement the search UI)
    - index.html (this holds the webpage for the search UI using the libraries in `pagefind`)

Since I'm only downloaded the HTML the 16k pages does not take up significant disk space yet.

## Prototype Implementation

Here's the bash scripts I use to get the URLs, harvest content and launch my localhost search engine based on PageFind.

Get the URLs I want to be searchable. I use to environment variables
for finding the various SQLite 3 databases (i.e. PSE_MOZ_PLACES, PSE_NEWSBOAT).

~~~
#!/bin/bash

if [ "$PSE_MOZ_PLACES" = "" ]; then
    printf "the PSE_MOZ_PLACES environment variable is not set."
    exit 1
fi
if [ "$PSE_NEWSBOAT" = "" ]; then
    printf "the PSE_NEWSBOAT environment variable is not set."
    exit 1
fi

sqlite3 "$PSE_MOZ_PLACES" \
    'SELECT moz_places.url AS url FROM moz_bookmarks JOIN moz_places ON moz_bookmarks.fk = moz_places.id WHERE moz_bookmarks.type = 1 AND moz_bookmarks.fk IS NOT NULL' \
    >moz_places.txt
sqlite3 "$PSE_NEWSBOAT" 'SELECT url FROM rss_item' >newsboat.txt
cat moz_places.txt newsboat.txt |
    grep -E '^(http|https):' |
    grep -v '://127.0.' |
    grep -v '://192.' |
    grep -v 'view-source:' |
    sort -u >pages.txt
~~~

The next step is to have the pages. I use wget for that.

~~~
#!/bin/bash
#
if [ ! -f "pages.txt" ]; then
    echo "missing pages.txt, skipping harvest"
    exit 1
fi
echo "Output is logged to pages.log"
wget --input-file pages.txt \
    --timestamping \
    --append-output pages.log \
    --directory-prefix htdocs \
    --max-redirect=5 \
    --force-directories \
    --protocol-directories \
    --convert-links \
    --no-cache --no-cookies
~~~

Finally I have a bash script that generates the index.html page, an Open Search Description XML file, indexes the harvested sites and launches PageFind in server mode.

~~~
#!/bin/bash
mkdir -p htdocs

cat <<OPENSEARCH_XML >htdocs/pse.osdx
<OpenSearchDescription xmlns="http://a9.com/-/spec/opensearch/1.1/"
                       xmlns:moz="http://www.mozilla.org/2006/browser/search/">
  <ShortName>PSE</ShortName>
  <Description>A Personal Search Engine implemented via wget and PageFind</Description>
  <InputEncoding>UTF-8</InputEncoding>
  <Url rel="self" type="text/html" method="get" template="http://localhost:1414/index.html?q={searchTerms}" />
  <moz:SearchForm>http://localhost:1414/index.html</moz:SearchForm>
</OpenSearchDescription>
OPENSEARCH_XML

cat <<HTML >htdocs/index.html
<html>
<head>
<link
  rel="search"
  type="application/opensearchdescription+xml"
  title="A Personal Search Engine"
  href="http://localhost:1414/pse.osdx" />
<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
</head>
<body>
<h1>A personal search engine</h1>
<div id="search"></div>
<script src="/pagefind/pagefind-ui.js" type="text/javascript"></script>
<script>
    window.addEventListener('DOMContentLoaded', function(event) {
		let page_url = new URL(window.location.href),
    	    query_string = page_url.searchParams.get('q'),
      		pse = new PagefindUI({ element: "#search" });
		if (query_string !== null) {
			pse.triggerSearch(query_string);
		}
    });
</script>
</body>
</html>
HTML

pagefind \
--source htdocs \
--serve
~~~

Then I just language my web browser pointing at `http://localhost:1414/index.html`. I can even pass the URL a `?q=...` query string if I want.

From a functionality point of view this is very bare bones and I don't think 16K pages is enough to make it compelling (I think I need closer to 100K for that).

## What I learned from the prototype so far

This prototype suffers from several limitations.

1. Stale links in my pages.txt make the harvest process really really slow, I need to have a way to avoid stale links getting into the pages.txt or have them removed from the pages.txt
2. PageFind's result display uses the pages I downloaded to my local machine. It would be better if the result link was translated to point at the actual source of the pages, I think this can be done via JavaScript in my index.html when I setup the PageFind search/results element. Needs more exploration

16K pages is a very tiny corpus. I get interesting results from my testing but not good enough to make me use first.  I'm guessing I need a corpus of at least 100K pages to be compelling for first search use.

It is really nice having a localhost personal search engine. It means that I can keep working with my home network connection is problematic. I like that. Since the website generated for my localhost system is a "static site" I could easily replicate that to net and make it available to other machines.

Right now the big time sync is harvesting content to index. I'm not certain yet how much space disk space will be needed for my 100K page target corpus.

Setting up indexing and the search UI were the easiest part of the process.  PageFind is so easy to work with compare to enterprise search applications.

## Things to explore

I can think of several ways to enlarge my search corpus. The first is there are a few websites I use for reference that are small enough to mirror. Wget provides a mirror function. Working from a "sites.txt" list I could mirror those sites periodically and have their content available for indexing.

When experimenting with the mirror option I notice I wind up with PDF that are linked in the pages being mirrored.  If I used the Unix find command to locate all the PDF I could use another tool to extract there text.  Doing that would enlarge my search beyond plain text and HTML.  I would need to think this through as ultimately I'd want to be able to recover the path to the PDF when those results are displayed.

Another approach would be to work with my full web browsers' history as
well as it's bookmarks. This would significantly expand the corpus. If I did this I could also check the "head" of the HTML for references to feeds that could be folded into my feed link harvests. This would have the advantage of capture content from sources I find useful to read but would catch blog posts I might have skipped due to limited reading time.

I use Pocket to read the pages I find interesting in my feed reader.  Pocket has an API and I could get some additional interesting pages from it. Pocket also has various curated lists and they might have interesting pages to harvest and index. I think the trick would be to use those suggests against an exclude list of some sort. E.g. Makes not sense to try to harvest paywall stuff or commercial sites more generally. One of the values I see in pse is that it is a personal search engine not a replacement for commercial search engines generally.