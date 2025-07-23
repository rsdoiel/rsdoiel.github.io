---
title: PostgreSQL dump and restore
pubDate: 2022-09-19T00:00:00.000Z
author: rsdoiel@gmail.com (R. S. Doiel)
byline: 'R. S. Doiel, 2022-09-19'
keywords:
  - PostgreSQL
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  This is a quick note on easily dumping and restoring a specific database

  in Postgres 14.5.  This example has PostgreSQL running on localhost and

  [psql](https://www.postgresql.org/docs/current/app-psql.html) and

  [pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) are both
  available.

  Our database administrator username is "admin", the database to dump is called
  "collections". The SQL dump

  file will be named "collections-dump-2022-09-19.sql".


  ...
dateCreated: '2022-09-19'
dateModified: '2025-07-22'
datePublished: '2022-09-19'
---

PostgreSQL dump and restore
===========================

This is a quick note on easily dumping and restoring a specific database
in Postgres 14.5.  This example has PostgreSQL running on localhost and
[psql](https://www.postgresql.org/docs/current/app-psql.html) and
[pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html) are both available.
Our database administrator username is "admin", the database to dump is called "collections". The SQL dump
file will be named "collections-dump-2022-09-19.sql".

```shell
	pg_dump --username=admin --column-inserts \
	    collections >collections-dump-2022-09-19.sql
```

For the restore process I follow these steps

1. Using `psql` create an empty database to restore into
2. Using `psql` replay (import) the dump file in the new database to restoring the data

The database we want to restore our content into is called "collections_snapshot"

```shell
	psql -U dbadmin
	\c postgres
	DROP DATABASE IF EXISTS collections_snapshot;
	CREATE DATABASE collections_snapshot;
	\c collections_snapshots
	\i ./collections-dump-2022-09-19.sql
	\q
```

Or if you want to stay at the OS shell level

```shell
	dropdb collections_snapshot
	createdb collections_snapshot
	psql -U dbadmin --dbname=collections_snapshot -f ./collections-dump-2022-09-19.sql
```


NOTE: During this restore process `psql` will display some output. This is normal. The two
types of lines output are shown below.

```sql
	INSERT 0 1
	ALTER TABLE
```

If you want to stop the input on error you can use the `--set` option to set the error behavior
to abort the reload if an error is encountered.