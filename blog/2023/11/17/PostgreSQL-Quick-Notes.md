---
title: 'Postgres Quick Notes, take two'
keywords:
  - postgres
byline: 'R. S. Doiel, 2023-11-17'
abstract: A collection of quick notes for setting and Postgres for development.
author: R. S. Doiel
copyrightYear: 2023
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2023-11-17'
dateModified: '2025-07-22'
datePublished: '2023-11-17'
---

# Postgres Quick Notes, take two

By R. S. Doiel, 2023-11-17

What follows is some quick notes to remind me of the things I do when
I setup a new instance of PostgreSQL on the various machines I work with.

## Installation approach

If possible I install Postgres with the system's package manager or follow
the directions suggested for installation on the [Postgres website](https://postgres.org).

### macOS and Postgres

For macOS that's not the route I take if possible is to install via [Postgres App](https://postgresapp.com/).
This provides a very nice setup of developing with Postgres on macOS and also allows you to easily
test multiple versions of Postgres.  It is not as convenient in the Mac Mini headless configuration
I also use Postgres on macOS in. In that case I use Mac Ports' package manager to install Postgres.
Unfortunately just using ports command isn't enough to get running. What follows is my notes on the
additional steps I've taken to get things working.

Install the version of Postgres you want (e.g. PostgreSQL 16) via ports

1. install postgresql16, postgresql16-server, postgres_select
2. make sure the postgres version is selected using the ports command
3. make a directory for the default postgres db
4. make sure the default db directory is owned by the postgres user
5. run the initialization scripts provided by the posts installer
6. use the ports command to load the plist
7. start up the server, make sure the log file is writable

Here's the commands I type in the shell

~~~shell
sudo port install postgresql16-server postgresql16 postgresql_select
# Answer y to the prompt
# After the install completes Ports will suggest the following to complete the process.
sudo port select postgresql postgresql16
sudo mkdir -p /opt/local/var/db/postgresql16/defaultdb
sudo chown postgres:postgres /opt/local/var/db/postgresql16/defaultdb
sudo -u postgres /bin/sh -c 'cd /opt/local/var/db/postgresql16 && /opt/local/lib/postgresql16/bin/initdb -D /opt/local/var/db/postgresql16/defaultdb'
sudo port load postgresql16-server
sudo -u postgres /bin/sh -c '/opt/local/lib/postgresql16/bin/pg_ctl -D /opt/local/var/db/postgresql16/defaultdb -l /opt/local/var/log/postgresql16/postgres.log start'
~~~

## Database users setup

This applies to most Postgres installations I do because I am using them to
develop software solutions. In a production setting you'd want a more conservative
security approach.

1. Make sure you can connect as the postgres user
2.  For each developer
    a. Use the Postgres createuser tool to create superuser account(s)
    b. Use the Postgres createdb tool to create databases for those account(s)

Here's the commands I type in the shell

~~~shell
sudo -u postgres psql
~~~

When in the psql shell you should be able to use the slash commands like

\\l
: list the databases

\\dt
: list the tables in the database

\\d TABLE\_NAME
: list the schema for TABLE\_NAME

\\q
: quit the psql shell

Assuming we have a working Postgres I now create superuser accounts for
development and databases that match the username.

~~~shell
sudo -u postgres createuser --interactive $USER
createdb $USER
~~~

I should now be able to run the psql shell without specifying the
postgres username.

~~~shell
psql
~~~