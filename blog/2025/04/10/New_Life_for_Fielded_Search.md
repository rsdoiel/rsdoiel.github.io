---
title: New Life for Fielded Search
pubDate: 2025-04-10
author: R. S. Doiel
abstract: |
  A day dreaming in response to a Simon Willison post on using language models
  to convert queries into fielded searches. In this post I extrapolate how this
  could result in a more private search experience and allow for an enhanced
  search experience for static websites.
dateCreated: 2025-04-10
dateModified: 2025-04-10
series: "Personal Search Engine"
number: 3
keywords:
  - search
  - LLM
  - Ollama
  - PageFind
  - FlatLake
---

# New Life for Fielded Searches

By R. S. Doiel, 2025-04-10

[Simon Willison](https://simonwillison.net/2025/Apr/9/an-llm-query-understanding-service/) posted an article yesterday that caught my eye. He was pointing out how even small language models can be used to breakdown a search query into fielded tokens.  Some of the earliest search engine, way before Google's one box, search engines were built on SQL databases. Full text search was tricky. Eventually full text search become a distinct service, e.g. [Solr](https://solr.apache.org). The full text search engine enabled the simple search to become the expected way to handle search. Later search engines like Google's use log analysis to improve this experience further. When you use a common search string like "spelling of anaconda", "meaning of euphemism", "time in Hawaii" these results are retrieved from a cache. The ones that are location/time sensitive can be handled by simple services that either populate the cache or return a result then populate the cache with a short expatriation time. Life in search land was good.  Then large language models hit the big time and the "AI" hyperbole cranked up to 11.

There has been flirtation with replacing full text engines or more venerable SQL databases with large language models.  There is a catch. Well many catches but let me focus on just one. The commercial large language models are a few years out of date. When you use a traditional search engine you expect the results to reflect recent changes. Take shopping a price from two years ago isn't has useful as today's price given the tariff fiasco. Assembling large language models takes allot of time, compute resources and energy. Updating them with today's changes isn't a quick process even if you can afford the computer and energy costs. So what do? One approach as been to allow the results of a large language model to have agency. Agency is to use a traditional search engine to get results.  They're serious challenges with this approach. These include performance, impact on other web services and of course security.

What if the language model is used in the initial query evaluation stage?  This is what Simon's article is about. He points out that even a smaller language model can be used to successfully take a query string and break it down into a fielded JSON object. Let's call that a search object. The search object then can be run against a traditional full text search engine or a SQL engine. These of course can be provided locally on your own servers.  [Ollama](https://ollama.app) provides an easy JSON API on localhost that can be used as part of your query parsing stack. This may be leveling especially if your organization has collection specific content to search (e.g. a library, archive or museum).

Constructing an language model enable stack could look something like this.

1. front end web service (accepts the queries)
2. Ollama is used to turn the raw query string into a JSON search object
3. The JSON search object is then sent to your full text search engine or SQL databases to gather results
4. results are formatted and returned to the browser.

The key point in Simon Willison's post is that you can use a smaller language model. This means you don't need more hardware to add the Ollama integration. You can shoe horn it into your existing infrastructure. 

This pipeline is a simple to construct.  This trick part is finding the right model and evaluating the results and deciding when the LLM translation to a JSON search object is good enough. Worst case is the original query string can still be passed off to your full text engine. So far so good. A slightly more complex search stack with hopefully improved usefulness.

## a few steps down the rabbit hole

Where I think things become interesting is when you consider where search processing can happen. In the old days the whole stack had to be on the server. Today that's isn't true.  The LLM piece might still be best running server side but the full text search engine can be provided along with your statically hosted website. You can even integrate with a statically hosted JSON API. In light of that let's revisit my sequence.

1. Front end web service response with a search page to the browser
2. Browser evaluates the search page, gets the query string
3. The browser then sends it to the Ollama web service that is returns a JSON search object (fielded object)
4. The browser applies the object to our static JSON API calculating some results, it also runs query string through the static site search getting results
5. results are merged and displayed in the browser

So you might be wonder about the static site search (browser side search) and JSON API I mentioned. For static site search I've found [PageFind](https://pagefind.app) to be really handy. For the JSON API I'd go with [FlatLake](https://flatlake.app). The two eliminate much of what used to be required from dynamic websites like those provided by Drupal and WordPress. A key observation here is that your query string only leaves the browser once in order to get back the language model result. This is a step toward a more private search but it doesn't pass the goal of avoiding log traces of searches.

I first encounter browser side search solution with Oliver Nightingale's [Lunrjs](https://lunrjs.com). I switch to PageFind because Cloud Cannon had the clever idea to partition the indexes and leverage WASM for delivering the search. PageFind has meant providing full text search for more than 10K objects.

**Could a PageFind approach work for migrating the language model service browser side?**

If the answer were yes, then would be a huge win for privacy. It would benefit libraries, archives and museums by allowing them to host rich search experiences while also taking advantage of the low cost and defensibilty of static site deployments.

