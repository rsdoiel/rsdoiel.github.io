---
title: "Rosette Notes: Postgres and MySQL"
author: "R. S. Doiel"
byline: "R. S. Doiel, 2022-08-18"
pubDate: 2022-08-18
---

Rosette Notes
=============

By R. S. Doiel, 2022-08-18

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
