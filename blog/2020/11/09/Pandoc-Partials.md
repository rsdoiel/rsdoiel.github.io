---
title: Pandoc Partials
author: rsdoiel@gmail.com (R. S. Doiel)
series: Pandoc Techniques
number: 1
keywords:
  - Pandoc
  - Templates
copyright: 'copyright (c) 2020, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2020
copyrightHolder: R. S. Doiel
abstract: |+
  Most people know about [Pandoc](https://pandoc.org/) from its
  fantastic ability to convert various markup formats from one to
  another. A little less obvious is Pandoc can be a template engine
  for rendering static websites allowing you full control over the
  rendered content.

  The main Pandoc documentation of the template engine can be found
  in the [User Guide](https://pandoc.org/MANUAL.html#templates).
  The documentation is complete in terms of describing the template
  capabilities but lacks a tutorial for using as a replacement for more
  ambitious rendering systems like [Jekyll](https://jekyllrb.com/) or
  [Hugo](https://gohugo.io/). Pandoc takes a vary direct approach and
  can be deceptively simple to implement.

dateCreated: '2020-11-09'
dateModified: '2025-07-22'
datePublished: '2020-11-09'
seriesNo: 1
---

Pandoc Partial Templates
========================

Most people know about [Pandoc](https://pandoc.org/) from its
fantastic ability to convert various markup formats from one to
another. A little less obvious is Pandoc can be a template engine
for rendering static websites allowing you full control over the
rendered content.

The main Pandoc documentation of the template engine can be found
in the [User Guide](https://pandoc.org/MANUAL.html#templates).
The documentation is complete in terms of describing the template
capabilities but lacks a tutorial for using as a replacement for more
ambitious rendering systems like [Jekyll](https://jekyllrb.com/) or
[Hugo](https://gohugo.io/). Pandoc takes a vary direct approach and
can be deceptively simple to implement.

Use your own template
---------------------

First thing in this tutorial is to use our own template with Pandoc
when rendering a single webpage. You use the `–-template` option to
provide your a template name. I think of this as the page level template.
This template, as I will show later, can then call other partial
templates as needed.

Example, render the [Pandoc-Partials.txt](Pandoc-Partials.txt) file using the
template named [index1.tmpl](index1.tmpl):

~~~{.shell}

    pandoc --from=markdown --to=html \
        --template=index1.tmpl Pandoc-Partials.txt > index1.htm

~~~

This is a simple template page level template.

~~~{.html-code}

    <!DOCTYPE html>
    <html>
    <head>
    </head>
    <body>
    ${body}
    </body>
    </html>

~~~

When we run our Pandoc command the file called
[Pandoc-Partials.txt](Pandoc-Partials.txt) is passed into the template as
the "body" element where it says `${body}`. See this Pandoc 
[User Guide](https://pandoc.org/MANUAL.html#templates) for the basics.

Example 1 rendered: [index1.htm](index1.htm)

Variables and metadata
----------------------

Pandoc's documentation is good at describing the
ways of referencing a variable or using the built-in
template functions. Where do the variables get their values?
The easiest way I've found is to set the variables values in
a JSON metadata file.  While Pandoc can also use the metadata
described in YAML front matter Pandoc doesn't support some of the
other common front matter formats.  If you're using another format
like JSON or TOML for front matter there are tools which can split
the front matter from the rest of the markdown document. For
this example I have created the metadata as JSON in a file
called [metadata.json](metadata.json).

Example [metadata.json](metadata.json):

~~~{.json}

    {
        "title": "Pandoc Partial Examples",
        "nav": [
            {"label": "Pandoc-Partials", "href": "Pandoc-Partials.html" },
            {"label": "Version 1", "href": "index1.htm" },
            {"label": "Version 2", "href": "index2.htm" },
            {"label": "Version 3", "href": "index3.htm" }
        ]
    }

~~~

Let's modify our initial template to include our simple navigation
and title.

Example [index2.tmpl](index2.tmpl):

~~~{.html-code}

    <!DOCTYPE html>
    <html>
    <head>
      ${if(title)}<title>${title}</title>${endif}
    </head>
    <body>
    <nav>
    ${for(nav)}<a href="${it.href}">${it.label}</a>${sep}, ${endfor}
    </nav>
    <section>
    ${body}
    </section>
    </body>
    </html>

~~~

We would include our navigation metadata with a Pandoc command like

~~~{.shell}

    pandoc --from=markdown --to=html \
           --template=index2.tmpl \
           --metadata-file=metadata.json Pandoc-Partials.txt > index2.htm

~~~

When we render this we now should be able to view a web page
with simple navigation driven by the JSON file as well as the
body content contained in the Pandoc-Partials.txt file.

Example 2 rendered: [index2.htm](index2.htm)

Partials
--------

Sometimes you have more complex documents. Putting this all in
one template can become tedious. Web designers use a term called
"partials". This usually means a template for a "part" of a page.
In our initial example we can split our navigation into it's own
template.

Implementing partials
---------------------

Pandoc will look in the current directory for partials as well
as in a sub directory called "templates" of the current direct.
In this example I am going to include my partial template for
navigation in the current directory along side my
[index3.tmpl](index3.tmpl).  My navigation template is called
[nav.tmpl](nav.tmpl).

Here's my partial template:

~~~{.html-code}

    <nav>
    ${for(nav)}<a href="${it.href}">${it.label}</a>${sep}, ${endfor}
    </nav>

~~~

Here's my third iteration of our index template, [index3.tmpl](index3.tmpl).

~~~{.html-code}

    <!DOCTYPE html>
    <html>
    <head>
    ${if(title)}<title>${title}</title>${endif}
    </head>
    <body>
    ${if(nav)}
    ${nav.tmpl()}
    ${endif}
    <section>
    ${body}
    </section>
    </body>
    </html>

~~~

Pandoc only requires you to reference the partial by using
its base name. Many people will name their templates with the
extension ".html". I find this problematic as if you're trying
to list the templates in the directory you can not easily list
them separately. I use the ".tmpl" extension to identify my templates.
Since I have other documents that share the base name "nav" I
explicit call my navigation partial using the full filename followed
by the open and closed parenthesis. I have also chosen to wrap
the template in an "if" condition. That way if I don't want navigation
on a page I skip defining it in my metadata file.

Inside the partial template we inherit the parent metadata object.
You can use all the built-in Pandoc template functions and variables
provided by Pandoc in your partial templates.

Putting it all together:

~~~{.shell}

    pandoc --from=markdown --to=html \
           --template=index3.tmpl \
           --metadata-file=metadata.json Pandoc-Partials.txt > index3.htm

~~~

Example 3 rendered: [index3.htm](index3.htm)