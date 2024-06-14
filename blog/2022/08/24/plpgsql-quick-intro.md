---
title: "A Quick into to PL/pgSQL"
author: "rsdoiel@gmail.com (R. S. Doiel)"
byline: "R. S. Doiel, 2022-08-24"
pubDate: 2022-08-24
series: "SQL Reflections"
number: 3
keywords:
  - postgres
  - sql
  - psql
  - plsql
  - plpgsql
---

A Quick intro to PL/pgSQL
========================

PL/pgSQL is a procedure language extended from SQL. It adds flow control and local state for procedures, functions and triggers. Procedures, functions and triggers are also the compilation unit. Visually PL/pgSQL looks similar to the MySQL or ORACLE counter parts. It reminds me of a mashup of ALGO and SQL. Like the unit of compilation, the unit of execution is also procedure, function or trigger. 

The Postgres documentation defines and explains the [PL/pgSQL](https://www.postgresql.org/docs/14/plpgsql.html) and how it works.  This document is just a quick orientation with specific examples to provide context.

Hello World
-----------

Here is a "helloworld" procedure definition.

```sql
    CREATE PROCEDURE helloworld() AS $$
    DECLARE
    BEGIN
       RAISE NOTICE 'Hello WORLD!';
    END;
    $$ LANGUAGE plpgsql;
```

Let's take a look this line by line.

1. CREATE PROCEDURE defines the procedure and the starting and ending delimiter for the procedure (e.g. `AS $$` the procedure's text ends when `$$` is encountered an second time.
2. DECLARE is the block where you would declare the variables used in the procedure, we have none in this example
3. The BEGIN starts the actual procedure instructions
4. The `RAISE NOTICE` line is how you can display output to the console when the procedure is run
5. The END completes the procedure definition
6. the `$$ LANGUAGE plpgsql;` concludes the text defining the procedure and tells the database engine that procedure is written in PL/pgSQL.

We can run the procedure using the "CALL" query.

```sql
    CALL helloworld()
```

NOTE: If you want to change the procedure you can "DROP" it first otherwise you'll get an error that it already exists.

```sql
    DROP PROCEDURE helloworld;
```

Improving my workflow
---------------------

SQL procedures are generally stored in the RDBMs in database environment. You can think of them as records in the system's database. Procedures and functions are created and can be dropped. While they can be manually typed in the database's shell it is easier to maintain them in plain text files outside the RDBM environment.  

1. Write the procedure in a text file.
2. Load the text file (e.g. FILENAME) into Postgres 
   a. outside the Postgres shell use `psql -f FILENAME` 
   b. inside the Postgres shell used `\i FILENAME`
3. Call the procedure to test it

To turn these steps into a look I use a "CREATE OR REPLACE" statement and be able to reload the updated procedure easier see [43.12. Tips for Developing in PL/pgSQL](https://www.postgresql.org/docs/14/plpgsql-development-tips.html).  Note in the revised example the "-- " lines are comments.

Our revised [helloworld](helloworld.plpgsql).

```sql
    --
    -- Create (or replace) the new "helloworld" procedure.
    -- NOTE: this can be run with "CALL"
    --
    CREATE OR REPLACE PROCEDURE helloworld() AS $$
    DECLARE
    BEGIN
        RAISE NOTICE 'Hello World!';
    END;
    $$ LANGUAGE plpgsql;
```


Hi There
--------

[hithere](hithere.plpgsql) is similar to our helloworld example except it is a function that takes a parameter of the person's name. The function returns a "VARCHAR", so this should work as part of a select statement.

```sql
    --
    -- This is a "Hi There" function. The function takes
    -- a single parameter and forms a greeting.
    --
    CREATE OR REPLACE FUNCTION hithere(name varchar) RETURNS varchar AS $$
    DECLARE
      greeting varchar;
    BEGIN
        IF name = '' THEN
            greeting := 'Hi there!';
        ELSE
            greeting := 'Hello ' || name || '!';
        END IF;
        RETURN greeting;
    END;
    $$ LANGUAGE plpgsql;
```

Giving it a try.

```shell
    SELECT hithere('Mojo Sam');
```

Further reading
---------------

- [Conditionals](https://www.postgresql.org/docs/14/plpgsql-control-structures.html#PLPGSQL-CONDITIONALS)
- [Loops](https://www.postgresql.org/docs/14/plpgsql-control-structures.html#PLPGSQL-CONTROL-STRUCTURES-LOOPS)
- [Calling a procedure](https://www.postgresql.org/docs/14/plpgsql-control-structures.html#PLPGSQL-STATEMENTS-CALLING-PROCEDURE)
- [Early return from a procedure](https://www.postgresql.org/docs/14/plpgsql-control-structures.html#PLPGSQL-STATEMENTS-RETURNING-PROCEDURE)

