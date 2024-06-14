---
title: "Revealing the Pandoc AST"
series: "Pandoc Techniques"
number: 4
keywords: [ "Pandoc", "filter" ]
copyright: "copyright (c) 2022, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---

Revealing the Pandoc AST
========================

I've used Pandoc for a number of years, probably a decade. It's been wonderful
watching it grow in capability. When Pandoc started accepting JSON documents as
a support metadata file things really started to click for me. Pandoc became
my go to tool for rendering content in my writing and documentation projects.

Recently I've decided I want a little bit more from Pandoc. I've become curious
about prototyping some document conversion via Pandoc's filter mechanism. To do
that you need to understand the AST, aka abstract syntax tree. 
How is the AST structure? 

It turns out I just wasn't thinking simply enough (or maybe just not paying
enough attention while I skimmed Pandoc's documentation). Pandoc's processing
model looks like

```
	INPUT --reader--> AST --filter AST --writer--> OUTPUT
```

I've "known" this forever. The missing piece for me was understanding 
the AST can be an output format.  Use the `--to` option with the value
"native" you get the Haskell representation of the AST. It's that simple.

```
	pandoc --from=markdown --to=native \
	   learning-to-write-a-pandoc-filter.md | \
	   head -n 20
```

Output

```
[ Header
    1
    ( "learning-to-write-a-pandoc-filter" , [] , [] )
    [ Str "Learning"
    , Space
    , Str "to"
    , Space
    , Str "write"
    , Space
    , Str "a"
    , Space
    , Str "Pandoc"
    , Space
    , Str "filter"
    ]
, Para
    [ Str "I\8217ve"
    , Space
    , Str "used"
    , Space
```

If you prefer JSON over Haskell use `--to=json` for similar effect. Here's
an example piping through [jq](https://stedolan.github.io/jq/).

```
	pandoc --from=markdown --to=json \
	   learning-to-write-a-pandoc-filter.md | jq .
```

Writing filters makes much sense to me now. I can see the AST and see
how the documentation describes writing hooks in Lua to process it.

