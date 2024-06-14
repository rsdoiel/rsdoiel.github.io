---
title: "Postgres 14 on Ubuntu 22.04 LTS"
author: "rsdoiel@gmail.com (R. S. Doiel"
byline: "R. S. Doiel"
series: "SQL Reflections"
number: 4
pubDate: 2022-08-26
daft: true
---

Postgres 14 on Ubuntu 22.04 LTS
===============================

by R. S. Doiel, 2022-08-26

This is just a quick set of notes for working with Postgres 14 on an Ubuntu 22.04 LTS machine.  The goal is to setup Postgres 14 and have it available for personal work under a user account (e.g. jane.doe). 

Assumptions

- include `jane.doe` is in the sudo group
- `jane.doe` is the one logged in and installing Postgres for machine wide use
- `jane.doe` will want to work with her own database by default

Steps

1. Install Postgres
2. Confirm installation
3. Add `jane.doe` user providing access

Below is the commands I typed to run to complete the three steps.

~~~shell
sudo apt install postgresql postgresql-contrib
sudo -u createuser --interactive
jane.doe
y
~~~

What we've accomplished is installing Postgres, we've create a user in Postgres DB environment called "jane.doe" and given "jane.doe" superuser permissions, i.e. the permissions to manage Postgres databases.

At this point we have a `jane.doe` Postgres admin user. This means we can run the `psql` shell from the Jane Doe account to do any database manager tasks. To confirm I want to list the databases available

~~~shell
psql 
SELECT datname FROM pg_database;
\quit
~~~

NOTE: This post is a distilation of what I learned from reading Digital Ocean's [How To Install PostgreSQL on Ubuntu 22.04 \[Quickstart\]](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-22-04-quickstart), April 25, 2022 by Alex Garnett.

