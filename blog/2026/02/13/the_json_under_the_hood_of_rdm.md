---
author: R. S. Doiel
dateCreated: "2026-02-13"
dateModified: "2026-02-13"
datePublished: "2026-02-13"
description: |
    A step by step for form URLs to retrieve JSON metadata from Invenio RDM and Zenodo.
keywords:
    - Invenio RDM
    - JSON
    - curl
    - jq
    - metadata
postPath: blog/2026/02/13/the_json_under_the_hood_of_rdm.md
title: The JSON under the hood of RDM

---


# The JSON under the hood of RDM

By R. S. Doiel, 2026-02-13

In my day job I work allot of library and archival repository software. The current favorite is [Invenio RDM](https://inveniordm.docs.cern.ch/). Compared to some other repository systems like [EPrints](https://https://en.wikipedia.org/wiki/EPrints) and[DSpace](https://en.wikipedia.org/wiki/DSpace) I think RDM is a large step in the right direction.  One thing I really like about both RDM and EPrints is their the RESTful API. It makes it trivial to retrieve records as structured text. In the case of RDM that structure is expressed as JSON (very convenient). All you need to know is how to modify the HTML version URL into the version where you see the structured metadata.

Let's say I want to look up an article titled "DIBS: An implementation of Controlled Digital Lending" in Zenodo. I plug the article title (or use the DOI, https://doi.org/10.5281/zenodo.17162802) into Zenodo and get back a the record page. The record page URL is this.

    <https://zenodo.org/records/17162802>

If I want to view that as structured metadata (JSON). I can insert a "/api" just before "/records". That URL looks like this.

    <https://zenodo.org/api/records/17162802>

Bingo I have RDM's JSON representation of the record. This is really helpful if I want do some sort of structural analysis on the record. All I need is to determine the identifier for the record and retrieve it. The identifier is the last bit after the URL part, "/records/".

What is I don't have the identifier already? RDM integrates OpenSearch to display lists of records. OpenSearch isn't directly exposed (for good reasons) to the public URL. The trick to getting lists of records is to use the "/records" end point along with query parameters. The means with a simple bit of URL editing I can get arbitrary lists back as JSON objects reflecting the OpenSearch JSON response structure. 

## URL hacking from HTML search results

Like many OpenSearch/Elasticsearch sites RDM normally generates the results page via requiring JavaScript evaluation. This allows a high degree of flexibility in presenting results. The trouble with the search page relying on JavaScript is that it obscures what is actually happening under the hood of your web browser. Under the hood the JavaScript takes the search query submitted and sends that off to OpenSearch, retrieves the JSON results then inserts them into the HTML page. How do you do this when you don't have JavaScript?

Go to an RDM deployment (I'm using Zenodo as an example). Open the search page with your browser's web tools are open. Look at the network calls the search page executes when you enter and submit search terms. That is where you find a clue to the actual URL handling the OpenSearch query processing. Regardless of whether your RDM instance bundled their UI built on Angular or React mess of JavaScript uses the records end point to pass through the OpenSearch results. The trick is knowing the simple the URL mapping of the HTML results to that back end query.

Let's say I am looking for the most resent additions to Zenodo from today, 2026-02-13. Using the HTML search page I get a URL that looks like this.

    <https://zenodo.org/search?q=updated%3A2026-02-13&l=list&p=1&s=10&sort=newest>

The query portion of the URL is `?q=updated%3A2026-02-13&l=list&p=1&s=10&sort=newest` is the important part. If I apply this to the `/api/records` end point. I get a URL that looks like this.

    <https://zenodo.org/api/records?q=updated%3A2026-02-13&l=list&p=1&s=10&sort=newest>

This is the JSON behind the search HTML page results.  Now I can use this to get lists of records. This works with my library's own RDM instances too. If you can form a search query with results you like in at Zenodo or on your local RDM instance using the HTML search page you can then get the results back in a JSON expression. The results follow the structured returned by OpenSearch. You just need to follow the [documentation](https://docs.opensearch.org/latest/query-dsl/query-filter-context/). The main JSON attribute that is useful is "hits" attribute.

## Taking things a step further with curl and jq.

[curl](https://curl.se/) will let us easily retrieve the search results as JSON from the command line.  We can page through the results using the `p=` query parameter (page number).  If we take the retrieved JSON we can pull out records using [jq](https://jqlang.org). Here's a simple command line phrase you can use to pull out the URLs to the JSON records of the Zenodo query results.

~~~shell
curl 'https://zenodo.org/api/records?q=updated%3A2026-02-13&l=list&p=1&s=10&sort=newest' | jq -r '.hits[][]?.links?.self'
~~~

This will list the RDM JSON url for the search query I supplied (updated since 2026-02-13). The list returns newest first. Today that list looked like this.

~~~

https://zenodo.org/api/records/18635105
https://zenodo.org/api/records/18635060
https://zenodo.org/api/records/18635124
https://zenodo.org/api/records/18635117
https://zenodo.org/api/records/18634630
https://zenodo.org/api/records/18635110
https://zenodo.org/api/records/18635099
https://zenodo.org/api/records/18635091
https://zenodo.org/api/records/18635094
https://zenodo.org/api/records/17556135
https://zenodo.org/api/records/18635089
https://zenodo.org/api/records/18635082
https://zenodo.org/api/records/18635087
https://zenodo.org/api/records/18635038
https://zenodo.org/api/records/18635076
https://zenodo.org/api/records/18635074
https://zenodo.org/api/records/18634979
https://zenodo.org/api/records/18635006
https://zenodo.org/api/records/18634916
https://zenodo.org/api/records/18635064
https://zenodo.org/api/records/18634080
https://zenodo.org/api/records/18635066
https://zenodo.org/api/records/18635062
https://zenodo.org/api/records/18635052
https://zenodo.org/api/records/18635020

~~~

There you have it. You can now retrieve a record or list or records as JSON from Invenio RDM repositories.
