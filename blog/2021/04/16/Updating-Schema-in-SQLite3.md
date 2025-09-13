---
title: Updating Schema in SQLite3
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2021-04-16'
keywords:
  - SQLite
  - SQL
  - database
series: SQL Reflections
number: 1
copyright: 'copyright (c) 2021, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2021
copyrightHolder: R. S. Doiel
abstract: |
  [SQLite3](https://sqlite.org/docs.html) is a handy little
  database as single file tool.  You can interact with the file
  through largely standard SQL commands and embed it easily into
  applications via the C libraries that the project supports.
  It is also available from various popular scripting languages
  like Python, PHP, and Lua. One of the things I occasionally
  need to do and always seems to forget it how to is modify a
  table schema where I need to remove a column. So here are
  some of the basics do I can quickly find them later and avoid
  reading various articles tutorials because the search engines
  doesn't return the page in the SQLite documentation.

  In the next sections I'll be modeling a simple person object
  with a id, uname, display_name, role and updated fields.

  ...
dateCreated: '2021-04-16'
dateModified: '2025-07-23'
datePublished: '2021-04-16'
postPath: 'blog/2021/04/16/Updating-Schema-in-SQLite3.md'
seriesNo: 1
---

Updating Schema in SQLite3
==========================

By R. S. Doiel, 2020-04-16

[SQLite3](https://sqlite.org/docs.html) is a handy little
database as single file tool.  You can interact with the file
through largely standard SQL commands and embed it easily into
applications via the C libraries that the project supports.
It is also available from various popular scripting languages
like Python, PHP, and Lua. One of the things I occasionally
need to do and always seems to forget it how to is modify a
table schema where I need to remove a column[^1]. So here are
some of the basics do I can quickly find them later and avoid
reading various articles tutorials because the search engines
doesn't return the page in the SQLite documentation.

[^1]: The SQL `ALTER TABLE table_name DROP COLUMN column_name` does not work in SQLite3

In the next sections I'll be modeling a simple person object
with a id, uname, display_name, role and updated fields.

Creating a person table
-----------------------


```sql

CREATE TABLE IF NOT EXISTS "person" 
        ("id" INTEGER NOT NULL PRIMARY KEY, 
        "uname" VARCHAR(255) NOT NULL, 
        "role" VARCHAR(255) NOT NULL, 
        "display_name" VARCHAR(255) NOT NULL, 
        "updated" INTEGER NOT NULL);

```

Adding a column
---------------

We will create a *junk* column which we will remove later.

```sql

.schema person
ALTER TABLE person ADD COLUMN junk VARCHAR(255) NOT NULL;
.schema person

```

Dropping a column
-----------------

To drop a column in SQLite you need to actually create
a new table, migrate the data into it then drop the old table
and finally rename it. It is best to wrap this in a transaction.

```sql

BEGIN TRANSACTION;
    CREATE TABLE IF NOT EXISTS "person_new" 
           ("id" INTEGER NOT NULL PRIMARY KEY, 
           "uname" VARCHAR(255) NOT NULL, 
           "role" VARCHAR(255) NOT NULL, 
           "display_name" VARCHAR(255) NOT NULL, 
           "updated" INTEGER NOT NULL);
    INSERT INTO person_new
           SELECT id, uname, role, display_name, updated
           FROM person;
    DROP TABLE person;
    ALTER TABLE person_new RENAME TO person;
COMMIT;

```
