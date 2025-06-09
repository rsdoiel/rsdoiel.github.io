---
title: Rethinking REST
author: R. S. Doiel
byline: R. S. Doiel
abstract: |
  I am re-thinking my reliance on REST's implementation of the CRUD abstraction in favor of the simpler
  read write file abstraction in my web application. This can be accomplished in SQL easily. This post
  covers an example of doing this in SQLite3 while also implementing JSON object versioning.

  Coverted are implenting the write abstraction using an upsert operation based on `insert` and SQLite3's
  `on conflict` clause. The object versioning is implemented using a simple trigger on the JSON column.
  The trigger maintains the version number and updated timestamp.
dateCreated: 2025-05-31
dateModified: 2025-06-09
pubDate: 2025-06-08
series: SQL Reflections
number: 7
keywords:
  - web service
  - web applications
  - web browsers
  - REST
  - read write web
  - SQL
  - SQLite3
copyright: copyright (c) 2025, R. S. Doiel
license: https://creativecommons.org/licenses/by-sa/4.0/
---

# Rethinking REST

## How to embrace the read write abstraction using SQL databases

By R. S. Doiel, 2025-06-07

[Roy Fielding](https://en.wikipedia.org/wiki/Roy_Fielding)'s 2000 dissertation describing [REST](https://en.wikipedia.org/wiki/REST) is a brilliant work. It revolutionized web services. I've spent a good chunk of my career implementing back end systems using a REST approach. REST's superpower is the mapping of HTTP methods to core database operations of create (POST), read (GET), update (PUT), and delete (DELETE). The has simplified machine to machine communication. That is a good thing.

REST has a browser problem. A quarter century after Fielding presented REST, the web browser still requires JavaScript to talk directly to a REST service. The core problem is the REST methods are not defined in the semantics of HTML. They are only available in HTTP protocol layer. JavaScript plays the role of solving the mapping of actions to REST methods. I can program over that impedance server side, browser side or both. The penalty is increased complexity. I think this complexity unnecessarily.

**What abstraction aligns with the grain of both web service and web browser?**

Sir Tim invented HTTP and HTML on a NeXT cube. The NeXT cube was a Unix system like the systems used by the Physicists at CERN where Sir Tim was employed. From Unix you can trace the concept of "everything is a file". File interaction can be boiled down to reads and writes. A second influence was the practice of using plain text to encode data. These characteristics influenced Sir Tim's choices when he invented HTTP and HTML. These characteristics inform the grain of the modern web.

What are the challenges of building on a read write abstraction rather than the database abstraction of create, read, update and delete? Do we toss out the database completely? That would be a too high of a cost.  Databases solve some important problems. This includes managing concurrent access, data protections and versatile query support. Database are the right choice in most cases for web applications. **So how do I get to a read write (RW) abstraction? The database wants create, read, update and delete (CRUD)?**

The short answer is we already do it. It's just messy. Typically we do this server side. It can be implemented browser side using JavaScript. Sometimes both places. We may layer that step as a micro service or embedded in some monolithic monstrosity. It's there someplace. It doesn't need to be a mess.

Let's consider that for a moment. Server side the web service receives a request containing web form data. The service decodes the web form, hopefully validates the contents, then figures out if it is a "create" or "update" in the database system before attempting either an `insert` or `update` operation. The database schema usually reflects the form data. If the form has repeating fields then you might have more than one table and need to maintain relationships between the tables. This can quickly become complex.

Server side this complexity was answered via object relational models (ORM).  Browser side we've seen similar approaches to the ORM in the development of frameworks that "bind" data in to an object model that can be sent to a back end system (often a REST API). The problem with both the server side ORM and browser side data binding frameworks is they tend to add allot of complexity. Ultimately they wind up dictating the approach you take to solve problems. Over time the frameworks become more complex too as they try to be a generalize solution to complex schema implementations. This accrues another source of complexity. The price of either becomes loss of flexibility, loss of performances and often deep levels of knowledge about the framework or ORM.  The longer lived your application is the more likely that this will not end well. I believe we can avoid this by taking stock of where database systems and the web have evolved since 2000.


**What am I proposing?**

Let's look at the deepest layer in our stack, the relational database. Several changes have happen on the database side that I think can help us build web application aligned with the read write abstraction core to our web browsers.  The first is a concept called upsert. Upsert is the idea of combining the behavior of `insert` and `update` into one operation. The upsert gives us our write operation.

What about the mapping of a web form's data?  The second change in relational database world is the wide adoption of JSON column support. We can treat web form contents as a JSON expression. Modern SQL can query the JSON columns along with the other supported data types.

A third changed was the arrival of SQLite in 2000. SQLite is SQL engine that does not require a separate database management system. Since 2000 SQLite has grown in usage. It now is used more commonly than Microsoft SQL server, Oracle, MySQL or PostgreSQL. The old requirement of using a stand alone database management system as part of the web stack has now turned into an option.

SQLite3 provides support for both JSON columns and upsert. The upsert concept is implemented as an `on conflict` clause in your `insert` statement.  SQLite3 also support SQL triggers. Using the JSON column, upsert and triggers the SQLite3 database can handle the mapping of data as well as mapping our read write (RW) operations to the database CRUD operations. Better yet SQLite3 is an embedded SQL engine so you don't have to run a database management system at all. 

Use of JSON columns can radically simplify your JSON schema for many use cases. The model I am suggesting can be used to implement simple content management systems, metadata managers and form processor systems. Here's a table design suitable to many simple web applications.

~~~SQL
CREATE TABLE IF NOT EXISTS data (
   id TEXT NOT NULL PRIMARY KEY,
   src JSON DEFAULT NULL,
   updated DATETIME DEFAULT CURRENT_TIMESTAMP,
   version INT DEFAULT 0
);
~~~

The `id` holds a unique identifier like a file path does in a file system. The `src` column holds our JSON source. The `updated` column records the ISO-8601 timestamp of when your object is updated.  You might be wondering about `version` column and a missing `created` column. SQL can be used to automate data versioning and reduce create and update into a write operation. This is done by adding a second table. The scheme change in the second table from the first is how the primary key is defined.

~~~SQL
CREATE TABLE IF NOT EXISTS data_history (
   id TEXT NOT NULL,
   src JSON DEFAULT NULL,
   updated DATETIME DEFAULT CURRENT_TIMESTAMP,
   version INT DEFAULT 0,
   PRIMARY KEY (id, version)
);
~~~

The SQL engine (SQLite3) does the actual version management using an SQL trigger. The "on conflict" of an insert triggers an "update" operation. The "update" action then triggers the `write_data` action before it completes.

Here is how our upsert is implemented.

~~~SQL
INSERT INTO data (id, src) values (?, ?) 
ON CONFLICT (id) DO
  UPDATE SET src = excluded.src
  WHERE excluded.id = id;
~~~

The `write_data` trigger is responsible for two things. Inserts a new row into the `data_history` table using the the current row's values. Next it updates the `data` table's `version` number and `updated` timestamp automatically.

~~~SQL
CREATE TRIGGER write_data BEFORE UPDATE OF src ON data
BEGIN
  -- Now insert a new version into data_history.
  INSERT INTO data_history (id,src, updated, version)
    SELECT id, src, updated, version FROM data WHERE id =id; 
  -- Handle updating the updated timestamp and version number
  UPDATE data SET updated = datetime(), version = version + 1
    WHERE old.id = new.id;
END; 
~~~


So when I insert a new object there is no conflict so a simple insert is performed on the `data` table.  The row's version and `upgrade` columns get populated by the schema defaults. The next time the row is update it triggers the `write_data` operation where the row is recorded (copied) to the `data_history` table before being updated to reflect the changed values.

How do you find out when a record was created without a column called created?

In the follow SQL we perform a left join with the `data_history` table. We filter the history table for a row with the same id but a version number of 0. If a row is found then the value of `data_history.updated` will not be null. A `ifnull` function can be used to pick that value otherwise we use the `data.updated` value from `data` table. Here is how that SQL would look.

~~~SQL
SELECT data.id as id, 
  data.src as src,
  data.updated as updated,
  ifnull(data_history.updated, data.updated) as created,
  data.version
FROM data LEFT JOIN data_history ON
  ((data.id = data_history.id) and (data_history.version = 0))
WHERE data.id = ?;
~~~

The complexity of mapping CRUD to RW is now completely contained in the SQL engine. While I have use SQLite3 for this specific example in practice these features are available in most modern relational database management systems. It's matter of knowing the specifics of the dialect.

Isn't this a whole lot of SQL to write? Perhaps. By leveraging JSON columns the needs to elaborate on this SQL are minimal. Effectively these four statements can function like an SQL component. I think the investment is small. It solves a large class of web application storage needs.  You could even use a template to automatically generate them. Once written your can re-use them as needed.

**Why did I focus on SQLite3?**

Because reducing the layers in our web stack reduces complexity. With SQLite3 we don't need database management system running. It's one less thing to manage, monitor and defend. In a cloud environment it can mean renting one less service.

**What layers remain? What are their responsibilities?**

In 1999 web applications had a data management component, a user management component and an authentication and authorization component. The point of the application was the data management component. You were required to implement the others to keep the data safe while it was on the Internet.

Today authentication and authorization can be handled by single sign-on systems. In the academic and research settings you typically see combinations like Apache2 + Shibboleth or NginX + Shibboleth. On the commercial Internet you see systems like OpenID and OAuth2. For a decade or more the systems I've designed and implemented take advantaged of single sign-on.  My application doesn't have to have a user management component or an authentication and authorization component at all.

I do need a layer that validates the inputs and returns the resources requested. I usually implement this as a "localhost" web service that relies on the "front end" web service for authentication and authorization. If my layer uses SQLite3 for data storage then the "stack" is just a "front end" web server providing authentication and authorization and a "back end" persistence layer providing validation, storage and retrieval.

An advantage of this simple stack is I can develop, test and improve the localhost web service and know it'll plug into the front end when I am ready for a production deployment.  The front end deals in requests and responses, the back end deals in requests and responses. Meanwhile I have all the advantages of a SQL database on the "back end".

Are there times I might need more layers?  Sure.  If I was managing millions of objects I would not store them in a single SQLite database.I'd use a database management system like PostgreSQL.  If I need a rich full text search engine I might use Solr or Open Search for that. If I am storing large objects then I might have a middle ware that can speak S3 protocol to store or retrieve those objects. My point is those are no longer a requirement. Extra layers or parallel services are now only options. They are available if and only if I need them.

Example.  If I want to basic full text search, SQL databases have index types that support this.  SQLite3 is included there.
By leveraging SQL triggers I can extract data from my stored JSON column and populate full text search columns or even other tables as needed.I can get allot of the advantages of a full text search before I reach for an external system like Solr.

So here are my take way items for you.

1. The web and databases continue to evolve.
2. Take advantage of the improvements to simplify your code and your implementations
3. Evaluate if you really need that heavy stack when you build your next application
4. Use the simplest of abstractions that solve the problem required
5. Consider a simple data interaction model like read write before you reach for REST

Enjoy.
