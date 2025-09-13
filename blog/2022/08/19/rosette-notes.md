---
title: 'Rosette Notes: Postgres and MySQL'
author: rsdoiel@gmail.com (R. S. Doiel)
byline: 'R. S. Doiel, 2022-08-19'
pubDate: 2022-08-19T00:00:00.000Z
updated: 2022-09-19T00:00:00.000Z
series: SQL Reflections
number: 2
keywords:
  - postgres
  - mysql
  - sql
  - psql
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  > A dance around two relational databases, piecing together similarities as
  with the tiny mosaic tiles of a guitar's rosette


  What follows are my preliminary notes learning Postgres 12 and 14.


  ...
dateCreated: '2022-08-19'
dateModified: '2025-07-22'
datePublished: '2022-08-19'
postPath: 'blog/2022/08/19/rosette-notes.md'
seriesNo: 2
---

Rosette Notes
=============

By R. S. Doiel, 2022-08-19

> A dance around two relational databases, piecing together similarities as with the tiny mosaic tiles of a guitar's rosette

What follows are my preliminary notes learning Postgres 12 and 14.

Postgres & MySQL
----------------

This is a short comparison of some administrative commands I commonly use. The first column describes the task followed by the SQL to execute for Postgres 14.5 and then MySQL 8. The presumption is you're using `psql` to access Postgres and `mysql` to  access MySQL. Values between `<` and `>` should be replaced with an appropriate value.

| Task                    | Postgres 14.5                     | MySQL 8           |
|-------------------------|------------------------------------|-------------------|
| show all databases      | `SELECT datname FROM pg_database;` | `SHOW DATABASES;` |
| select a database       | `\c <dbname>`                      | `USE <dbname>`    |
| show tables in database | `\dt`                              | `SHOW TABLES;`    |
| show columns in table   | `SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '<table_name>';` | `SHOW COLUMNS IN <table_name>` |

Reflections
-----------

The Postgres shell, `psql`, provides the functionality of showing a list of tables via a short cut while MySQL choose to add the `SHOW TABLES` query. For me `SHOW ...` feels like SQL where as `\d` or `\dt` takes me out of SQL space. On the other hand given Postgres metadata structure the shortcut is appreciated and I often query for table names as I forget them. `\dt` quickly becomes second nature and is shorter to type than `SHOW TABLES`. 

Connecting to a database with `\c` in `psql` is like calling an "open" in programming language. The "connection" in `psql` is open until explicitly closed or the shell is terminated.  Like `USE ...` in the MySQL shell it make working with multiple database easy.  The difference are apparent when you execute a `DROP DATABASE ...` command. In `psql` you need to `CLOSE` the database first or the `DROP` will fail.  The MySQL shell will happily let you drop the current database you are currently using.

The challenge I've experienced learning `psql` after knowing MySQL is my lack of familiarity with the metadata Postgres maintains about databases and structures.  On the other hand everything I've learned about standards base SQL applies to managing Postgres once remember the database/table I need to work with.  A steeper learning curve from MySQL's `SHOW` but it also means writing external programs for managing Postgres databases and tables is far easier because everything is visible because that is how you manage Postgres. MySQL's `SHOW` is very convenient but at the cost of hiding some of its internal structures.

Both MySQL and Postgres support writing programs in SQL. They also support stored procedures, views and triggers. They've converged in the degree in which they have both implemented SQL language standards.  The differences are mostly in approach to managing databases.  There are some differences, necessitated by implementation choices, in the `CREATE DATABASE`, `CREATE TABLE` or `ALTER` statements but you can often use the basic form described in ANSI SQL and get the results you need. When doing performance tuning the dialect differences are more important.

Dump & Restore
--------------

Both Postgres and MySQL provide command line programs for dumping a database. MySQL provides a single program where as Postgres splits it in two. Check the man pages (or website docs) for details in their options. Both sets of programs are highly configurable allowing you to dump just schema, just data or both with different expectations.

| Postgres 14.5      | MySQL 8                         |
|--------------------|---------------------------------|
| `pg_dumpall`       | `mysqldump --all-databases`     |
| `pg_dump <dbname>` | `mysqldump --database <dbname>` |

The `pg_dumpall` tool is designed to restore an entire database instance. It includes account and ownership information. `pg_dump` just focuses on the database itself. If you are taking a snapshot production data to use in a test `pg_dump` output is easier to work with. It captures the specific database with out entangling things like the `template1` database or database user accounts and ownership.

You can restore a database dump in both Postgres and MySQL. The tooling is a little different.

| Postgres 14.5                   | MySQL 8                                      |
|---------------------------------|----------------------------------------------|
| `dropdb <dbname>`               | `mysql -execute 'DROP DATABASE <dbname>;'`   |
| `createdb <dbname>`             | `mysql -execute 'CREATE DATABASE <dbname>;'` |
| `psql -f <dump_filename>`       |`mysql <dbname> < <dump_filename>`            |

NOTE: These instructions work for a database dumped with `pg_dump` for the Postgres example. In principle it is the same way you can restore from `pg_dumpall` but if you Postgres instance already exists then you're going to run into various problems, e.g. errors about `template1` db.

Lessons learned along the way
-----------------------------

2022-08-22

8:00 - 11:30; SQL; Postgres; Three things have turned out to be challenges in the SQL I write, first back ticks is a MySQL-ism for literal quoting of table and column names, causes problems in Postgres. Second issue is "REPLACE" is a none standard extension I picked up from MySQL [it wraps a DELETE and INSERT together](https://dev.mysql.com/doc/refman/8.0/en/extensions-to-ansi.html), should be using UPDATE more than I have done in the past. The third is parameter replacement in SQL statement. This appears to be [db implementation specific](http://go-database-sql.org/prepared.html). I've used "?" with SQLite and MySQL but with Postgres I need to use "$1", "$2", etc. Challenging to write SQL once and have it work everywhere. Beginning to understand why GORM has traction.


2022-08-24

11:00 - 12:00; SQL; Postgres; I miss `SHOW TABLES` it's just muscle memory from MySQL, the SQL to show tables is `SELECT tablename FROM pg_catalog.pg_tables WHERE tablename NOT LIKE 'pg_%';`. I could write a SHOWTABLE in PL/pgSQL procedure implementing MySQL's "SHOW TABLES". Might be a good way to learn PL/pgSQL. I could then do one for MySQL and compare the PL/SQL language implementations.

2022-08-26

9:30 - 10:30; SQL; Postgres; If you are looking for instructions on installing Postgres 14 under Ubuntu 22.04 LTS I found DigitalOcean [How To Install PostgreSQL on Ubuntu 22.04 \[Quickstart\]](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart), April 25, 2022 by Alex Garnett helpful.

2022-09-19

10:30 - 12:30; SQL; Postgres; Setting up postgres 14 on Ubuntu shell script, see [https://www.postgresql.org/download/linux/ubuntu/](https://www.postgresql.org/download/linux/ubuntu/), see [https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart) for setting up initial database and users
