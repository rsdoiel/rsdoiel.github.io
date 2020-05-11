{
    "markup": "mmark",
    "title": "From Markdown and Bash to mkpage",
    "author": "R. S. Doiel",
    "date": "2016-08-16",
    "copyright": "copyright (c) 2016, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}



# From Markdown and Bash to mkpage

By R. S. Doiel 2016-08-16

When I started maintaining a website on Github a few years ago my needs
were so simple I hand coded the HTML.  Eventually I adopted 
a markdown processor for maintaining the prose. My "theme" was a
CSS file and some HTML fragments to wrap the markdown output. If I needed 
interactivity I used JavaScript to access content via a web API. 
Life was simple, all I had to learn to get started was Git and how to
populate a branch called "gh-pages".


## Deconstructing Content Management Systems

Recently my website needs have grown. I started experimenting with static
site generators thinking an existing system would be the right fit. 
What I found were feature rich systems that varied primarily in 
implementation language and template engine. Even though I wasn't
required to run Apache, MySQL and PHP/Perl/Python/Ruby/Tomcat it felt 
like the static site generators were racing to fill a complexity 
vacuum. In the end they were interesting to explore but far more
than I was willing to run. I believe modern content management systems can
be deconstruct into something simpler.

Some of the core elements of modern content management systems are

+ creation and curation of data sources (including metadata)
+ transforming data sources if needed
+ mapping a data source to appropriate template set
+ rendering template sets to produce a final website

Modern static site generators leave creation and curration to your 
text editor and revision control system (e.g. vi and git). 

Most static site generators use a simplified markup. A populate one is
called [Markdown](https://en.wikipedia.org/wiki/Markdown). This "markup"
is predictable enough that you can easily convert the results to HTML and
other useful formats with tools like [pandoc](http://pandoc.org/). In most 
static site generators your content is currated in Markdown and when the 
pages are built it is rendered to HTML for injection into your website's 
template and theme.

Mapping the data sources to templates, combining the templates and rendering 
the final website is where most systems introduce a large amount of complexity.
This is true of static site generators like [Jekill](https://jekyllrb.com) and 
[Hugo](https://gohugo.io).


## An experimental deconstruction

I wanted a simple command line tool that would make a single web page.
It would take a few data sources and formats and run them through a
template system. The template system needed to be simple but support
the case where data might not be available. It would be nice if it handled
the case of repititious data like that used in tables or lists. Ideally
I could render many pages from a single template assuming a simple website
and layout.

### A single page generator

[mkpage](https://github.com/rsdoiel/mkpage) started as an experiment in
building a simple single page generator. It's responsibilities
include mapping data sources to the template, transforming data if needed
and rendering the results. After reviewing the websites I've setup in
the last year or two I realized I had three common types of data.

1. Plain text or content that did not need further processing
2. Markdown content (e.g. page content, navigation lists)
3. Occassionally I include content from JSON feeds

I also realized I only needed to handle three data sources.

1. strings
2. files
3. web resources

Each of these sources might provide plain text, markdown or JSON data formats.

That poses the question of how to express the data format and the data 
source when mapping the content into a template. The web resources are
easy in the sense that the web responses include content type information.
Files can be simple too as the file extension indicates their
format (e.g. ".md" for Markdown, ".json" for JSON documents). What remained
was how to identify a text string's format.  I opted for a prefix ending in 
a colon (e.g. "text:" for plain text, "markdown:" for markdown 
and "json:" for JSON). This mapping allows for a simple key/value
relationship to be expressed easily on the command line.

### mkpage in action

Describing how to build "mypage.html" from "mypage.md" and "nav.md" 
(containing links for navigating the website) is as easy as typing

```shell
    mkpage "content=mypage.md" "navigation=nav.md" page.tmpl > mypage.html
```

In this example the template is called "page.tmpl" and we redirect the 
output to "mypage.html".


Adding a custom page title is easy too.

```shell
    mkpage "title=text:My Page" \
        "content=mypage.md' "navigation=nav.md" 
        page.tmpl \
        > mypage.html
```

Likewise integrating some JSON data from weather.gov is relatively straight
forward. The hardest part is discovering the [URL](http://forecast.weather.gov/MapClick.php?lat=34.0522&lon=118.2437&DFcstType=json) 
that returns JSON!  Notice I have added a weather field and the URL. When data
is recieved back from weather.gov it is JSON decoded and then passed to the
template for rendering using the "range" template function.

```shell
    mkpage "title=My Page" \
        "content=mypage.md" \
        "navigation=nav.md" \
        "weather=http://forecast.weather.gov/MapClick.php?lat=34.0522&lon=118.2437&DFcstType=json" \
        page.tmpl \
        > mypage.html
```

What is *mkpage* doing?

1. Reading the data sources and formats from the command line
2. Transforming the Markdown and JSON content appropriately
3. Applying them to the template (e.g. page.tmpl)
4. Render the results to stdout

Building a website then is only a matter of maintaining navigation in
*nav.md* and identifing the pages needing to be created. I can easily 
automated that using the Unix find, grep, cut and sort. Also with find 
I can iteratively process each markdown file applying a 
template and rendering the related HTML file.  This can be done for a site 
of a few pages (e.g. about, resume and cv) to more complex websites like 
blogs and repository activities.

Here's an example template that would be suitable for the previous
command line example. It's mostly just HTML and some curly bracket notation 
sprinkled in.

```html
    <!DOCTYPE html>
    <html>
    <head>
        {{with .title}}<title>{{- . -}}</title>{{end}}
        <link rel="stylesheet" href="css/site.css">
    </head>
    <body>
        <nav>
        {{ .navigation }}
        </nav>
        <section>
        {{ .content }}
        </section>
        <aside>
        Weather Demo<br />
        <ul>
        {{range .weather.data.text}}
            <li>{{ . }}</li>
        {{end}}
        </ul>
        </aside>

    </body>
    </html>
```

You can find out more about [mkpage](https://github.com/rsdoiel/mkpage)
[rsdoiel.github.io/mkpage](https://rsdoiel.github.io/mkpage).

To learn more about Go's text templates see 
[golang.org/pkg/text/template](https://golang.org/pkg/text/template/). 

If your site generator needs are more than *mkpage* I suggest [Hugo](https://gohugo.io). 
It's what I would probably reach for if I was building a large complex organizational
site or news site.

If you're looking for an innovative and rich author centric content system
I suggest Dave Winer's [Fargo](http://fargo.io) outliner and [1999.io](https://1999.io).


