---
title: Rust tools for Web Work
abstract: |
  A quick review of a PageFind and FlatLake by Cloud Cannon. A brief description of how I use them.
pubDate: 2024-11-06
created: 2024-11-05
updated: 2024-11-06
byline: R. S. Doiel
keywords:
  - web
  - rust
  - search
  - JSON API
  - Cloud Cannon
---

# Two Rust command line tools for web work

By R. S. Doiel, 2024-11-06

I've noticed that I'm using more tools written in the Rust language. I'd like to highlight two that have impressed me. Both are from [Cloud Cannon](https://cloudcannon.com). They make static website development interesting without unnecessarily increasing complexity.

Historically static site development meant limited interactivity browser side. Then JavaScript arrived. That enabled the possibility of an interactive static site. Two areas remained challenging. First was search. An effective search engine used to required running specialized software like [Solr](https://solr.apache.org) or using a SAAS[^1] search solution.  When the renaissance in static sites happened these options were seen as problematic.

[^1]: SAAS, Software as a Service. This is how the web provides application software and application functionality. SAAS are convenient but often have significant drawbacks in terms of privacy and content ownership. SAAS dates back to pre-Google era. Early search engines like Alta Vista provided search as a service. Today many sites use Google, Bing or DuckDuckGo to provide search as a service.

Statically hosted search arrived when [Oliver Nightingale](https://github.com/olivernn) created [LunrJS](https://lunrjs.com/). LunrJS provides a Solr like search experience run from within your web browser. You needed to write some JavaScript to generate indexes and of course JavaScript had to be available in the browser to run the search engine. In spite of having to write some JavaScript to perform indexing it was easier to setup and manage than Solr. LunrJS added benefit of avoiding running a server. Things were good but there were limitations.  If you wanted to index more than ten thousand or so objects the indexes grew to be quite large. This made search painfully slow. That's because your web browser needed to download the whole search index before search could run in the browser.  There were variations on Oliver's approach but none really seemed to solve the problem completely. Still for small websites LunrJS was very good.

Fast forward and a little over a decade ago Cloud Cannon emerged as a company trying to make static site content management easier.  One of the things they created was a tool called [PageFind](https://pagefind.app). Like LunrJS PageFind provides a search engine experience for static websites that runs in the browser.  But it includes a few important improvements. First you don't need to write a program to build your indexes. PageFind comes with a Rust based tool called, unsurprisingly, "pagefind". It builds the indexes for you with minimal configuration. The second difference from LunrJS is PageFind builds collection of partial indexes that can be loaded on demand. This means you can index sites with many more than 10K objects and still use a browser side search. That's huge. I've used it on sites with as many as hundred thousand objects. That's a magnitude difference content that can be searched! A very clever feature of PageFind is that you can combined indexes from multiple sites.  This means the search with my blog can also cover my GitHub project sites that use PageFind for their web documentation. Very helpful.

PageFind does have limitations. It only indexes HTML documents. Unlike Solr it's not going to easily serve as a search engine for your collection of PDFs. At least without some effort on your part. Like LunrJS it also requires JavaScript to be available in the web browser. So if you're using RISC OS and a browser like NetSurf or Dillo, you're out of luck. Still it is a viable solution when you don't want to run a server and you don't want to rely on a SAAS solution like Google or Bing.

> Wait! There's more from Cloud Cannon!

If you start providing JavaScript widgets for your website content you'll probably miss having a database backed JSON API. You can create one as part of your site rendering process but it is a big chore. Cloud Cannon, in their quest for a static site content management system, provides an Open Source solution for this too. It's called [FlatLake](https://flatlake.app). Like PageFind it is a command line tool. Instead of analyzing HTML documents FlatLake works on Markdown documents. More specifically Markdown documents with YAML front matter[^2]. It uses that to render a read only JSON API from the metadata in your documents front matter.  You define which attributes you want to expose in your API in a YAML file. FlatLake creates the necessary directory structure and JSON documents to reflect that. Want to create a tag cloud? Your JSON API can provided the data for that. You want to provide alternate views into your website such as indexes or article series views?  Again you now have a JSON API that aggregates your metadata to render that. Beyond some small amount of configuration FlatLake does the heavy lifting of generating and managing the JSON API for your site. It's consistent and predictable. Start a new site and add FlatLake and you get a familiar JSON API out of the box.

[^2]: Front matter is a block of text at the top of your Markdown document usually expressed in YAML. Site building tools like [Pandoc](https://pandoc.org/chunkedhtml-demo/8.10-metadata-blocks.html#extension-yaml_metadata_block) can use the YAML block to populate and control templating. Similarly R-Markdown provides a similar functionality. FlatLake takes advantage of that. 


## PageFind and FlatLake in action

My personal website is indexed with PageFind.  The indexes are located at <https://rsdoiel.github.io/pagefind>. The search page is at <https://rsdoiel.github.io/search.html>. I index my content with the following command (which will run on macOS, Windows or Linux).

~~~shell
pagefind --verbose --exclude-selectors="nav,header,footer" --output-path ./pagefind --site .
~~~

That command index all the HTML content excluding nav, header and footers.  The JavaScript in my [search.html](https://rsdoiel.github.io/search.html) page looks like this.

~~~JavaScript
let pse = new PagefindUI({
    element: "#search",
    showSubResults: true,
    highlightParam: "highlight",
    mergeIndex: [{
        bundlePath: "https://rsdoiel.github.io/pagefind",
        bundlePath: "https://rsdoiel.github.io/shorthand/pagefind",
        bundlePath: "https://rsdoiel.github.io/pttk/pagefind",
        bundlePath: "https://rsdoiel.github.io/skimmer/pagefind",
        bundlePath: "https://rsdoiel.github.io/scripttools/pagefind",
        bundlePath: "https://rsdoiel.github.io/fountain/pagefind",
        bundlePath: "https://rsdoiel.github.io/osf/pagefind",
        bundlePath: "https://rsdoiel.github.io/fdx/pagefind",
        bundlePath: "https://rsdoiel.github.io/stngo/pagefind",
        bundlePath: "https://rsdoiel.github.io/opml/pagefind"
    }]
})
window.addEventListener('DOMContentLoaded', (event) => {
    let page_url = new URL(window.location.href),
        query_string = page_url.searchParams.get('q');
    if (query_string !== null) {
        console.log('Query string: ' + query_string);
        pse.triggerSearch(query_string);
    }
});
~~~

This supports searching content in some of my GitHub project sites as well as my blog.

One of the things I am working on is updating how I render my website.  I have a home grown tool called [pttk](https://rsdoiel.github.io/pttk "Plain Text Toolkit") that includes a "blogit" feature. Blog it takes cares care of adding Markdown documents to my blog and generates a a JSON document that contains metadata from the Markdown documents.  That later feature is no longer needed with the arrival of FlatLake. FlatLake also has the advantage that I can define other metadata collections to include in my JSON API. The next incarnation of pttk will be simpler as the JSON API will be provided by FlatLake.

FlatLake analyzes the Markdown documents in my website and build out a JSON API as folders and JSON documents. If I do this as the first step in rendering my site the rendering process can take advantage of that. It replace my "blog.json" file. It can even replace the directory traversal I previously needed to use with building the site. That's because I can take advantage of the exposed metadata in a highly consistent way. You can explore the JSON API being generated at <https://rsdoiel.github.io/api>. I haven't yet landed on my final API organization but when I do I'll be able to trim the code for producing my website significantly. Here's the outline I expect to follow.

1. Run FlatLake on the Markdown content and update the JSON API content
2. Read the JSON API and render my site
3. Run PageFind and update my site indexes
4. Deploy via GitHub Pages with `git` or `gh`

## Installing PageFind and FlatLake

Both PageFind and FlatLake are written in Rust. If you have Rust installed on your machine then Cargo will do all your lifting.  When I have a new machine I install [Rust](https://www.rust-lang.org/) with [Rustup](https://rustup.rs). On an running Machine I run `rustup upgrade` to get the latest Rust.  I then install (or updated) PageFind and FlatLake with Cargo.

~~~shell
rustup upgrade
cargo install pagefind
cargo install flatlake
~~~

I've run PageFind on macOS, Windows, Linux. On ARM 64 and Intel CPUs. I even run it on Raspberry Pi!. Rust supports all these platforms so where Rust runs PageFind and FlatLake can follow.

PageFind solves my search needs.  FlatLake is simplifying the tooling I use to generate my website. My plain text toolkit (pttk) needs to do much less. It feels close to the grail of static website management system built from simple precise tools. Git hands version control. Pandoc renders the Markdown to HTML. PageFind provides search and FlatLake provides the next generation JSON API. A Makefile or Deno task can knit things together into a publication system.
