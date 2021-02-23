---
title: "Pandoc & Metadata"
author: "R. S. Doiel"
series: "Pandoc Techniques"
number: 2
keywords: [ "Pandoc", "Metadata", "Templates" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---


Pandoc & Metadata 
=================

Pandoc supports three ways of providing metadata to its template
engine. 

1. Front matter
2. Command line optional metadata
3. A JSON metadata file.

Front matter
------------

Front matter is a community term that comes from physical world
of paper books and articles.  It is the information that comes 
before the primary content.  This information might be things 
like title, author, publisher and publication date. These days 
it'll also include things like identifiers like ISSN, ISBN possibly 
newer identifiers like DOI or ORCID. In the library and programming
community we refer to this type of structured information as
metadata.  Data about the publication or article.

Many publication systems like TeX/LaTeX support provided means of 
incorporating metadata into the document.  When simple markup formats 
like Markdown, Textile and Asciidoc became popular the practice was 
continued by including the metadata in some sort of structured encoding
at the beginning of the document. The community adopted the term from
the print world, "front matter". 

Pandoc provides for several ways of working with metadata and supports
one format of front matter encoding called [YAML](https://yaml.org/). 
Other markup processors support other encoding of front matter. Two
popular alternatives of encoding are [TOML](https://toml.io/en/) and 
[JSON](https://json.org).  If you use one of the alternative encoding
for your front matter then you'll need to split the front matter
out of your document before processing with Pandoc[^1].  

[^1]: The [MkPage Project](https://caltechlibrary.github.io/mkpage/) provides a tool called [frontmatter](https://caltechlibrary.github.io/mkpage/docs/frontmatter/) that can be easy or your can easily roll your own in Python or other favorite language.


If you provide YAML formatted front matter Pandoc will pass this
metadata on and make it available to it's template engine and the
templates you create to render content with Pandoc. See the Pandoc
User Guide section [YAML metadata blocks](https://pandoc.org/MANUAL.html#extension-yaml_metadata_block) for more details. If you've used another
encoding of front matter then the metadata file approach is probably
the ticket.

Metadata passed by command line
-------------------------------

If you only have a metadata elements you would like to
make available to the template (e.g. title, pub date) you
can easily add them using the `--metadata` command line option.
This is documented in the Pandoc User Guide under the heading
[Reader Options](https://pandoc.org/MANUAL.html). Here's a simple
example where we have a title, "U. S. Constitution" and a
publication date of "September 28, 1787".

~~~{.shell}
    pandoc --metadata \
        title="U. S. Constitution" \
        pubdate="September 28, 1787" \
        --from markdown --to html --template doc1.tmpl \
        constitution.txt
~~~

The template now has two additional values available as metadata
in addition to `body`, namely `pubdate` and `title`. Here's an
example template [doc1.tmpl](doc1.tmpl).

~~~

   <!DOCTYPE html>
   <html>
   <head>
       <title>${title}</title>
   </head>
   <body>
      <h1>${title}</h1>
      <h2>${pubdate}</h2>
      <p>
      ${body}
      <p>
   </body>
   </html>

~~~

More complex metadata is better suited to creating a JSON document
with the structure you need to render your template.


Metadata file
-------------

Metadata files can be included with the option `--metadata-file`. This
like the `--metadata` option are discussed in the Pandoc User Guide under
the [Read Options(https://pandoc.org/MANUAL.html) heading.  The JSON 
document should contain an Object where each attribute corresponds to
the variable you wish to referenced in template.  Pandoc's template
engine support both single values but also objects and arrays. In this
way you can structure the elements you wish to include even elements
which are iterative (e.g. a list of links or topics). Below is a
JSON data structure that includes the page title as well as links
for the navigation.  The nav attribute holds a list of objects 
with attributes of href and label containing data that will be used
to render a list of anchor elements in the template.


~~~{.json}

    {
        "title": "U. S. Constitution",
        "pubdate": "September 28, 1787",
        "nav": [
            {"label": "Pandoc Metadata", "href": "Pandoc-Metadata.html" },
            {"label": "Magnacarta", "href": "magnacarta.html" },
            {"label": "Declaration of Independence", "href": "independence.html" },
            {"label": "U. S. Constitution", "href": "constitution.html"}
        ]
    }

~~~

Here's a revised template to include the navigation,
see [doc2.tmpl](doc2.tmpl).

~~~

   <!DOCTYPE html>
   <html>
   <head>
       <title>${title}</title>
   </head>
   <body>
      <nav>
      ${for(nav)}<a href="${nav.href}">${nav.label}</a>${sep}, ${endfor}
      </nav>
      <h1>${title}</h1>
      ${if(pubdate)}<h2>${pubdate}</h2>${endif}
      <p>
      ${body}
      <p>
   </body>
   </html>

~~~


Combining Techniques
--------------------

It is worth noting that these approaches can be mixed and matched.
In the following example I use the same [metadata.json](metadata.json)
file which has title and pubdate attributes but override them
using the command line `--metadata` option. In this way I can use that 
file along with [doc2.tmpl](doc2.tmpl) and render each 
To render the constitution page from a Markdown version of the 
U. S. Constitution you could use the following Pandoc command:

~~~{.shell}

	pandoc --from markdown --to html --template doc2.tmpl \
        --metadata-file metadata.json \
        --metadata title="Magna Carta" \
		--metadata pubdate="1215" \
		-o magnacarta.html \
		magnacarta.txt

	pandoc --from markdown --to html --template doc2.tmpl \
        --metadata-file metadata.json \
        --metadata title="The Declaration of Indepenence" \
		--metadata pubdate="July 4, 1776" \
        -o independence.html \
        independence.txt

	pandoc --from markdown --to html --template doc2.tmpl \
        --metadata-file metadata.json \
        --metadata title="U. S. Constitution" \
		--metadata pubdate="September 28, 1787" \
        -o constitution.html \
        constitution.txt

~~~

See [Magna Carta](magnacarta.html), [The Declaration of Independence](independence.html), [U. S. Constitution](constitution.html)


