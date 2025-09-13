---
title: Building A to Z list pages in Pandoc
keywords:
  - Pandoc
  - templates
author: R. S. Doiel
copyrightYear: 2023
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  Pandoc offers a very good template system. It avoids elaborate features in
  favor of a few simple ways to bring content into the page.  It knows how to
  use data specified in “front matter” (a YAML header to a Markdown document) as
  well as how to merge in JSON or YAML from a metadata file.  One use case that
  is common in libraries and archives that less obvious of how to handle is
  building A to Z lists or year/date oriented listings where you have a set of
  navigation links at the top of the page followed by a set of H2 headers with
  UL lists between them.  In JSON the typical data presentation would look
  something like


  ...
dateCreated: '2023-10-18'
dateModified: '2025-07-22'
datePublished: '2023-10-18'
postPath: 'blog/2023/10/18/A-to-Z-lists.md'
---

# Building A to Z lists pages in Pandoc

By R. S. Doiel, 2023-10-18

Pandoc offers a very good template system. It avoids elaborate features in favor of a few simple ways to bring content into the page.  It knows how to use data specified in “front matter” (a YAML header to a Markdown document) as well as how to merge in JSON or YAML from a metadata file.  One use case that is common in libraries and archives that less obvious of how to handle is building A to Z lists or year/date oriented listings where you have a set of navigation links at the top of the page followed by a set of H2 headers with UL lists between them.  In JSON the typical data presentation would look something like

```json
{
  "a_to_z": [ "A", "B"],
  "content": {
    "A": [
      "After a beautiful day",
      "Afterlife"
    ],
    "B": [
      "Better day after",
      "Better Life"
    ]
  }
}
```

The trouble is that while YAML’s outer dictionary (key/value map) works fine in Pandoc templates there is no way for the the for loop to handle maps of maps like we have above.  Pandoc templates really want to iterate over arrays of objects . That’s nice thing! It gives us more ways to transform the data to provide more flexibility in our template implementation. Here’s how I would restructure the previous JSON to make it easy to process via Pandoc’s template engine.  Note how I’ve taken our simple array of letters and turned them into an object with an “href” and “label” attribute. Similarly I’ve enhanced the “content” objects.

```json
{
  "a_to_z": [ {"href": "A", "label": "A"}, {"href": "B", "label": "B"} ],
  "content": [
      {"letter": "A", "title": "After a beautiful day", "id": "after-a-beautiful-day"},
      {"title": "Afterlife", "id": "afterlife"},
      {"letter": "B", "title": "Better day after", "id": "better-day-after"},
      {"title": "Better Life", "id": "better-life"}
  ]
}
```

Then the template can be structure something like

```
<menu>
${for(a_to_z)}
${if(it.href)}<li><a href="${it.href}">${it.label}</a></li>${endif}
${endfor}
</menu>

${for(content)}
${if(it.letter)}

## <a id="${it.letter}" name="${it.letter}">${it.letter}</a>

${endif}
- [${it.name}](${it.id})
${endfor}

```

There is one gotcha in A to Z list generation. A YAML parser may convert a bare “N” to “false” (and presumable “Y” will become “true”). This is really annoying. The way to avoid this is to add a space to the letter in your JSON output. This will insure that the “N” or “Y” aren’t converted to the boolean values “true” and “false”. Pandoc’s template engine is smart enough to trim leading and trailing spaces.

Finally this technique can be used to produce lists and navigation that are based around years, months, or other iterative types but that is left as an exercise to the reader.
