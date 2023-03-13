---
title: "SQL query to CSV, a missing datatool"
author: "rsdoiel@sdf.org (R. S. Doiel)"
pubDate: 2023-01-03
updateDate: 2023-03-13
keywords: [ "sql", "csv", "tab delimited" ]
---

# SQL query to CSV, a missing datatool

By R. S. Doiel, 2023-01-13

Update: 2023-03-13

At work we maintain allot of metadata related academic and research publications in SQL databases. We use SQL to query the database and export what we need in tab delimited files. Often the exported data includes a column containing publication or article titles.  Titles in library metadata can be a bit messy. They contain a wide set of UTF-8 characters include math symbols and various types of quotation marks. The exported tab delimited data usually needs clean up before you can import it successfully into a spreadsheet.

In the worst cases we debug what the problem is then write a Python script to handle the tweak to fix things.  This results in allot of extra work and slows down the turn around for getting reports out quickly. This is particularly true of data stored in MySQL 8 (though we also use SQLite 3 and Postgres).

This got me thinking about how to get a clean export (tab or CSV) from our SQL databases today.  It would be nice if you provided a command line tool with a data source string (e.g. in a config file or the environment), a SQL query and the tool would use that to render a CSV or tab delimited file to standard out or a output file. It would work something like this.

```
    sql2csv -o eprint_status_report.csv -config=$HOME/.my.cnf \
	    'SELECT eprintid, title, eprint_status FROM eprint' 
```

The `sql2csv` would take the results of the query and write to the CSV file.

The nice thing about this approach is that I could support the three relational databases we use -- i.e. MySQL 8, Postgres and SQLite3 with one common tool so my Bash scripts that run the reports would be very simple rather than specialized to one database system or the other.

I hope to experiment with this approach in the next release of [datatools](https://github.com/caltechlibrary/datatools), an open source project maintained at work.

## update

Jon Woodring pointed out to me today that both SQLite3 and PostgreSQL clients can output to CSV without need of an external tool. Wish MySQL client did that! Instead MySQL client supports tab delimited output. I'm still concidering sql2csv due to the ammount work I do with MySQL database but I'm not sure if it will make it into to the datatools project or now since I suspect our MySQL usage will decline overtime as more projects are built with PostgreSQL and SQLite3.
