---
title: "Pandoc, Pagefind and Make"
pubDate: 2022-11-30
keywords: [ "Pandoc", "Pagefind", "make", "static site" ]
---

# Pandoc, Pagefind and Make

Recently I've refresh my approach to website generation using three programs.

- [Pandoc](https://pandoc.org)
- [Pagefind](https://pagefind.app) for providing a full text search of documentation
- [GNU Make](https://www.gnu.org/software/make/)
    - [website.mak](website.mak) Makefile

Pandoc does the heavy lifting. It renders all the HTML pages, CITATION.cff (from the projects [codemeta.json](codemeta.github.io "codemeta.json is a metadata documentation schema for documenting software projects")) and rendering an about.md file (also from the project's codemeta.json). This is done with three Pandoc templates. Pandoc can also be used to rendering man pages following a simple page recipe.

I've recently adopted Pagefind for indexing the HTML for the project's website and providing the full text search UI suitable for a static website. The Pagefind indexes can be combined with your group or organization's static website providing a rich cross project search (exercise left for another post).

Finally I orchestrate the site construction with GNU Make. I do this with a simple dedicated Makefile called [website.mak](#website.mak).


## website.mak

The website.mak file is relatively simple.

```makefile
#
# Makefile for running pandoc on all Markdown docs ending in .md
#
PROJECT = PROJECT_NAME_GOES_HERE

MD_PAGES = $(shell ls -1 *.md) about.md

HTML_PAGES = $(shell ls -1 *.md | sed -E 's/.md/.html/g') about.md

build: $(HTML_PAGES) $(MD_PAGES) pagefind

about.md: .FORCE
        cat codemeta.json | sed -E 's/"@context"/"at__context"/g;s/"@type"/"at__type"/g;s/"@id"/"at__id"/g' >_codemeta.json
        if [ -f $(PANDOC) ]; then echo "" | pandoc --metadata title="About $(PROJECT)" --metadata-file=_codemeta.json --template codemeta-md.tmpl >about.md; fi
        if [ -f _codemeta.json ]; then rm _codemeta.json; fi

$(HTML_PAGES): $(MD_PAGES) .FORCE
	pandoc -s --to html5 $(basename $@).md -o $(basename $@).html \
		--metadata title="$(PROJECT) - $@" \
	    --lua-filter=links-to-html.lua \
	    --template=page.tmpl
	git add $(basename $@).html

pagefind: .FORCE
	pagefind --verbose --exclude-selectors="nav,header,footer" --bundle-dir ./pagefind --source .
	git add pagefind

clean:
	@if [ -f index.html ]; then rm *.html; fi
	@if [ -f README.html ]; then rm *.html; fi

.FORCE:
```

Only the "PROJECT" value needs to be set. Typically this is just the name of the repository's base directory.

## Pandoc, filters and templates

When write my Markdown documents I link to Markdown files instead of the HTML versions. This serves two purposes. First GitHub can use this linking directory and second if you decide to repurposed the website as a Gopher or Gemini resource
you don't linking to the Markdown file makes more sense.  To convert the ".md" names to ".html" when I render the HTML I use a simple Lua filter called [links-to-html.lua](https://stackoverflow.com/questions/40993488/convert-markdown-links-to-html-with-pandoc#49396058 "see the stackoverflow answer that shows this technique").

```lua
# links-to-html.lua
function Link(el)
  el.target = string.gsub(el.target, "%.md", ".html")
  return el
end
```

The "page.tmpl" file provides a nice wrapper to the Markdown rendered as HTML by Pandoc. It includes the site navigation and project copyright information in the wrapping HTML. It is based on the default Pandoc page template with some added markup for navigation and copyright info in the footer. I also update the link to the CSS to conform with our general site branding requirements. You can generate a basic template using Pandoc.

```shell
pandoc --print-default-template=html5
```

I also use Pandoc to generate an "about.md" file describing the project and author info.  The content of the about.md is taken directly from the project's codemeta.json file after I've renamed the "@" JSON-LD fields (those cause problems for Pandoc). You can see the preparation of a temporary "_codemeta.json" using `cat` and `sed` to rename the fields. This is I use a Pandoc template to render the Markdown from.

```pandoc
---
title: $name$
---

About this software
===================

$name$ $version$
----------------

$if(author)$
### Authors

$for(author)$
- $it.givenName$ $it.familyName$
$endfor$
$endif$

$if(description)$
$description$
$endif$


$if(license)$- License: $license$$endif$
0$if(codeRepository)$- GitHub: $codeRepository$$endif$
$if(issueTracker)$- Issues: $issueTracker$$endif$


$if(programmingLanguage)$
### Programming languages

$for(programmingLanguage)$
- $programmingLanguage$
$endfor$
$endif$

$if(operatingSystem)$
### Operating Systems

$for(operatingSystem)$
- $operatingSystem$
$endfor$
$endif$

$if(softwareRequirements)$
### Software Requiremets

$for(softwareRequirements)$
- $softwareRequirements$
$endfor$
$endif$

$if(relatedLink)$
### Related Links

$for(relatedLink)$
- [$it$]($it$)
$endfor$
$endif$
```

This same technique can be repurposed to render a CITATION.cff if needed.

## Pagefind

Pagefind provides three levels of functionality. First it will generate indexes for a full text search of your
project's HTML pages. It also builds the necessary search UI for your static site. I include the search UI via a
Markdown document that embeds the HTML markup described at [Pagefind.app](https://pagefind.app/docs/)'s Getting started
page.  When I invoke Pagefind I use the `--bundle-dir` option to be "pagefind" rather than "_pagefind".  The reason is GitHub Pages ignores the "_pagefind" (probably ignores all directories with "_" prefix).

If you need a quick static web server while you're writing and developing your documentation website Pagefind can
provide that using the `--serve` option. Assuming you're in your project's directory then something like this should do the trick.

```shell
    pagefind --source . --bundle-dir=pagefind --serve
```
