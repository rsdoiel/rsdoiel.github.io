---
title: Limit and offset for row pruning
abstract: >-
  Noted are how to combine a select statement with limit and offset clauses with
  a delete statement to prune rows.
byline: R. S. Doiel
created: 2024-10-31T00:00:00.000Z
pubDate: 2024-10-31T00:00:00.000Z
keywords:
  - sql
  - SQLite3
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2024-10-31'
dateModified: '2025-07-23'
datePublished: '2024-10-31'
---

# Limit and offset for row pruning

By R. S. Doiel, 2024-10-31

I recently needed to prune data that tracked report requests and their processing status. The SQLite3 database table is called
"reports" and has four columns.

- `id` (uuid)
- `created` (request date stamp)
- `updated` (status updated date stamp)
- `src` (a JSON column with the status details)

The problem is the generated report can be requested as needed. I wanted to maintain the request data for the most recent one. The "src" column has the report name and status. That is easily checked using the JSON notation supported by SQLite3 (v3.47.0). It's easy to get the most recent completed row with a simple SELECT statement using both an ORDER clause and LIMIT clause.

~~~sql
select id
  from reports
  where src->>'report_name' = 'myreport' and
        src->>'status' = 'completed'
  order by updated desc
  limit 1
~~~

This gives me the key to the most recent record.  How do I get a list of he rows I want to prune?  The answer is to use the LIMIT cause with an OFFSET
modifier. The OFFSET let's us skip a certain number of rows before applying the limit.  In this case I want to skip one row and show the rest. This database table doesn't get that big so I can use a limit like one thousand. Here's what that looks like.

~~~sql
select id
  from reports
  where src->>'report_name' = 'myreport' and
        src->>'status' = 'completed'
  order by updated desc
  limit 1000 offset 1
~~~

Now that I have my list of ids I can combine it with a DELETE statement which has a WHERE clause. The WHERE clause will use the IN operator to iterate over the list of ids from my select statement.

Putting it all together it looks like this.

~~~sql
delete from reports
  where id in (
    select id
      from reports
      where src->>'report_name' = 'myreport' and
            src->>'status' = 'completed'
      order by updated desc
      limit 1000 offset 1
)
~~~

The nice thing is I can run this regularly. It will never delete the most recent row because the offset value is one.