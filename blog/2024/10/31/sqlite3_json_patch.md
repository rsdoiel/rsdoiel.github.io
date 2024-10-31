---
title: SQLite3 json_patch is a jewel
abstract: Quick note about json_path function in SQLite3
author: R. S. Doiel
byline: R. S. Doiel
created: 2024-10-31
pubDate: 2024-10-31
keywords:
  - sql
  - SQLite3
---

# SQLite3 json_patch is a jewel

By R. S. Doiel, 2024-10-31

If you’re working with an SQLite3 database table and have JSON or columns you need to merge with other columns then the `json_path` function comes in really handy.
I have a SQLite3 database table with four columns.

- _key (string)
- src (json)
- created (datestamp)
- updated (datestamp)

Occasionally I want to return the `_key`, `created` and `updated` columns as part of the JSON held in the `src` column.  In SQLite3 it is almost trivial.

~~~sql
select 
  json_patch(json_object('key', _key, 'updated', updated, 'created', created), src) as object
  from data;
~~~

