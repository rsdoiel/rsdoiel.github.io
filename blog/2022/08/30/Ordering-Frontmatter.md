---
title: "Ordering front matter"
pubDate: 2022-08-30
author: "rsdoiel@gmail.com (R. S. Doiel)"
keywords: [ "pandoc", "front matter" ]
---

Ordering Front Matter
=====================

By R. S. Doiel, 2022-08-30

A colleague of mine ran into an interesting Pandoc behavior. He was combining a JSON metadata document and a converted word document and wanted the YAML front matter to have a specific order of fields (makes it easier for us humans to quickly scan it and see what the document was about).

The order he wanted in the front matter was

- title
- interviewer
- interviewee
- abstract

This was for a collection of oral histories. When my friend use Pandoc's `--metadata-json` to read the JSON metadata it rendered the YAML fine except the attributes were listed in alphabetical order.

We found a solution by getting Pandoc to treat the output not as Markdown plain text so that we could template the desired order of attributes.

Here's the steps we used.

1. create an empty file called "empty.txt" (this is just so you pandoc doesn't try to read standard input and processes
you metadata.json file with the template supplied)
2. Create a template with the order you want (see below)
3. Use pandoc to process your ".txt" file and your JSON metadata file using the template (it makes it tread it as plain text even though we're going to treat it as markdown later)
4. Append the content of the word file and run pandoc over your combined file as you would normally to generate your HTML


This is the contents of our [metadata.json](metadata.json) file.

```json
    {
        "title": "Interview with Mojo Sam", 
        "interviewee": "Mojo Sam", 
        "interviewer": "Tom Lopez",
        "abstract": "Interview in three sessions over sevaral decases, 1970 - 20020. The interview was conducted next door to reality via a portal in Old Montreal"
    }
```

[frontmatter.tmpl](frontmatter.tmpl) is the template we used to render ordered front matter.

```
    ---
    $if(title)$title: "$title$"$endif$
    $if(interviewee)$interviewee: "$interviewee$"$endif$
    $if(interviewer)$interviewer: "$interviewer$"$endif$
    $if(abstract)$abstract: "$abstract$"$endif$
    ---
```

Here's the commands we used to generate a "doc.txt" file with the 
front matter in the desired order. Not "empty.txt" is just an empty
file so Pandoc will not read from standard input and just work with the
JSON metadata and our template.

```
touch empty.txt
pandoc --metadata-file=metadata.json --template=frontmatter.tmpl empty.txt
```

The output of the pandoc command looks like this.

```
    ---
    title: "Interview with Mojo Sam"
    interviewee: "Mojo Sam"
    interviewer: "Tom Lopez"
    abstract: "Interview in three sessions over sevaral decases, 1970 -
    20020. The interview was conducted next door to reality via a portal in
    Old Montreal"
    ---
```
