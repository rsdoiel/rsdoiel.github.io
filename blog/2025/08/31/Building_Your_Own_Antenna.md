---
title: Building Your Own Antenna
author: R. S. Doiel
dateCreated: "2025-08-20"
dateModified: "2025-08-31"
datePublished: "2025-08-31"
---

# Building Your Own Antenna

By R. S. Doiel, 2025-08-31

I have been prototyping my personal news site called [Antenna](https://rsdoiel.github.io/antenna) since 2023. It was inspired by Dave Winer's [news.scripting.com](https://news.scripting.com). It has always run on a Raspberry Pi 3B+ running Raspberry Pi OS (Linux). The content is available over my home network and I make it public by publishing via GitHub pages. Over the last two years it has become the first place I go to consume content from the web (second is Dave's news.scripting.com).

This past month (August 2025), my prototype website lead me to write a new application I am calling [antenna](https://github.com/rsdoiel/antennaApp) after the website that inspired it. 

## What I learned from running Antenna website

Having the feeds in a simple text format means I curate the feeds more. When I relied on OPML it became just enough extra work hand editing XML that I wanted something simpler. I started with a feed file format inspired by [Newsboat](https://newsboat.org). It was a little too simple, wound up writing scripts to convert that format to something more general (e.g. OPML). I decided to pick something better known for my new application. That got me thinking. Lots of people know Markdown. A collection is a list of zero or more links. That's is easy to express as Markdown. It has the advantage of being able to be convert to other formats as needed (example using a Pandoc filter to render as OPML).

What about other configuration I might need?

The Markdown community has supported Metadata for the Markdown document as "front matter" expressed in YAML. That suggested YAML has been seen by the many in in the Markdown community. YAML front matter is also documented. Why not use it for specific configuration of my collection of feeds? I can use it to express the extra fields that can be included in the channel metadata for rendering RSS 2.0 files. YAML can also serve as the configuration language for the Antenna application. Seems like a good match. I think people who work with Markdown maybe interested in generating static websites, they may have knowledge of YAML so that aligns with my applcation.

How do you add a collection to the "antenna.yaml" file? A prototype can be implemented with a hand edited YAML file but that's not good for everyone. While YAML is easier to type and read than JSON it's not bullet proof. The Antenna application can create a default "antenna.yaml" file as an initialization action. The Antenna command can include a means of adding a collection (expressed as a Markdown document) and removing a collection. While someone can dive into the YAML (and comments in the default YAML can document what things are), they don't have to dive into YAML if I provide sensible defaults. That's a win for simplicity and flexibility.

Once a collection is defined and added to the Antenna YAML configuration it can be harvested. The harvested content then can be used to generate HTML and RSS 2.0 XML files.

You can find my current experimental implementation of the Antenna application as <https://github.com/rsdoiel/antennaApp/releases>. There are zip files for macOS, Linux and Windows for both x86_64 and aarch64 (ARM 64) machines.

## What is the Antenna application really?

Antenna, the application, is a feed oriented static website generator. It stores each collection of feed items in an SQLite3 database. You can have as many collections as you want.  In addition to aggregating feed content you can "post" or "unpost" items to a collection. The Antenna application can harvest collections then generate an HTML page and RSS 2.0 XML for each collection. The application provides a preview action so you can see the results without publishing a website.

Supporting in bound and out bound RSS allows an Antenna website to become a distributed node on the open social web. It's simple, it's RSS 2.0, it proven. You can "follow" someone by adding their feed. They can "follow" you back by adding yours. You only need to host a copy of your Antenna site on the open web and promote the feeds you produce. It doesn't require permission, it remains under your control. It doesn't need to surveil anyone or sell anything to work. It's just out there as long as you have a site on the open web.

Antenna requires minimal resources. I run it on a Raspberry Pi 3B+ running the current version of Raspberry Pi OS. It can even run on a Raspberry Pi Zero running Raspberry Pi OS without the desktop. I have run tested it on Windows 10, Windows 11 and macOS and found it runs just fine there too. 

Because it can run on minimal hardware it is possible to create your own Antenna appliance. You could even host a public access point to step off the public Internet and into the community digital spectrum like little digital libraries.

## How do I install the experimental Antenna application?

The Antenna application can be [installed](https://rsdoiel.github.io/antennaApp/INSTALL.html) on Raspberry Pi OS/Linux, macOS and Windows. The executables are distributed via GitHub at <https://github.com/rsdoiel/antennaApp/releases>. Unzip the file for your operating system and CPU type then copy the executable in the "bin" directory to where it'll be available in a terminal (i.e. someplace in the PATH). If you can run `antenna -version` from your Terminal then it is installed and working. See [INSTALL.md](https://rsdoiel.github.io/antennaApp/INSTALL.html)

It is important to remember that Antenna is an experimental proof of concept, it'll have bugs and will likely change over time. As I use it more the things that bother me will get fixed or improved. Look at the [license](https://rsdoiel.github.io/antennaApp/LICENSE) for details before adopting it.

## High level Workflow

The basic workflow for generating the Antenna website can be thought of as 

1. Curating your feed collections, posting Markdown documents to a collection
2. Harvest the collections
3. Generate HTML pages for the collections

Steps two and three can be run on a schedule or run on demand. I use a cronjob to run them each morning and evening on my venerable Pi 3B+.

## Developing the Antenna application

### Figuring out features

What are the features of the Antenna application?  Dave Winer's [Textcasting](https://textcasting.org) was a good guide for thinking about the problem. It'll likely guide the feature evolution moving forward. Two years of running my Antenna website with a bundle of Bash scripts, Pandoc templates and a custom feed manager provided more insight. The hairball of the prototype lead to a single application that you run in a terminal. It supports a syntax of "actions" and simple "modifiers". Configuration is generally managed by the application but can be customized via editing YAML files. Each collection has a YAML file that specifies how to write the content in HTML. The "antenna.yaml" file descriptions which collections to process and includes SQL to filter them aggregated content.

Collection curation is done in Markdown. Markdown describes a list of links. Each link is a feed. The links are extracted from the Markdown document when they have this form, `- [FEED_LABEL](FEED_URL "OPTIONAL_FEED_DESCRIPTION")`. Front Matter in the collection document will be used to provide channel metadata used when generating RSS and HTML. Having the collection expressed as Markdown is an advantage. When the collection is rendered as RSS the channel level information can be taken from the YAML front matter of the collection document much like it works with RMarkdown or Pandoc. Mean while Markdown also makes sense for post to a collection. Again the additional front matter can provide insights into how Antenna should handle the post.

Rules of thumb:

- __content__ think Markdown
- __configuration__ think YAML

Here's the initial feature set I've landed for the 0.0.1 version of the Antenna application.

1. Define a feed collections as a list of links in a Markdown file
2. Use YAML front matter for additional configuration and metadata
3. Use YAML for configuration of the Antenna App
4. Use a share page structure among all generated pages (easier to style)
5. Allow customization of the pages by injecting HTML blocks
6. Use a simple command structure for the program, `antenna ACTION [MODIFIERS]`

There were something things I wanted to avoid.

- Avoid template languages, they get too involved to document and explain
- Avoid extra software dependencies, the Antenna application should be a single stand alone executable available for Raspberry Pi OS/Linux, macOS and Windows
- While Antenna is being implemented as a command line tool, keep it simple where the syntax is action followed by modifiers

What are minimum set of actions needed by the Antenna application based on my [prototype website](https://rsdoiel.github.io/antenna)?

init
: Initial (create/validate) an Antenna YAML configuration file.

add COLLECTION_MARKDOWN
: Add a feed collection defined by COLLECTION_MARKDOWN, a Markdown file. The Markdown file can contain a list of links that look like `- [FEED_LABEL](FEED_URL, "FEED_DESCRIPTION")`. All other content in the Markdown file is ignored. That means you can actually document things about the feed or publish the Markdown file as it's own webpage along side the aggregated results.

del COLLECTION_MARKDOWN
: Remove a feed collection defined by the COLLECTION_MARKDOWN file name from the collections managed in the antenna.yaml file.

harvest | harvest COLLECTION_MARKDOWN
: Harvest all collections or specific collections.

generate | generate COLLECTION_MARKDOWN
: Generate HTML and RSS 2.0 XML for all collections or a specific collection. The generated files have a similar name to the Markdown file defining the collection. Example, "myfeeds.md" would result in the aggregation HTML page of "myfeeds.html" and the RSS 2.0 file called "myfeeds.xml".

post COLLECTION_MARKDOWN  MARKDOWN_FILE
: Add the POST_MARKDOWN file to the harvested collection of COLLECTION_MARKDOWN. Depending on the he front matter the "post" will either exist as a collection item record or may also be configured to be rendered as HTML in the web tree curated by Antenna.

unpost COLLECTION_MARKDOWN LINK_TO_POST
: Remove a item with the LINK_TO_POST value from the harvested collection of COLLECTION_MARKDOWN. This works both for "post" items and any other item in the feed collection.

In the case of "post" the MARKDOWN_FILE front matter provides the metadata
needed to complete the processing. This allows you to inject items into a collection that just show up in the aggregate or to do full blog posts where the the post content is written to an HTML file.

When you run a harvest action, the COLLECTION_MARKDOWN file is read and each of the feeds defined will be harvested with the feed items and channel information stored in the "channels" and "items" table of the SQLite3 database associated with COLLECTION_MARKDOWN filename. Example, "travel.md" could define a list of links related to travel. That is the COLLECTION_MARKDOWN file. When the "travel.md" collection is added to the antenna configuration a database is generated called "travel.db". When I run generation action both an HTML page will show the aggregation of those feeds and a new RSS 2.0 XML file will be generated, "travel.html" and "travel.xml".  

A Markdown document which includes  "postPath" and "link" in the front matter  tells the Antenna application to convert the Markdown into HTML and write it to the location specified by "postPath". 

## How do you manage individual pages for your website?

A collection doesn't have to contain feeds from external websites. It can be a collection of "posts". A post isn't proscriptive. It just describes something that will be aggregated in a collection, if you include "postPath" it also describes where to render HTML of the post contents. That's it. You can organize the "postPath" of each document however you want. I happen to like the blog directory style of "posts/YEAR/MONTH/DAY/POST_FILE" but you might prefer a wiki layout or just something ad-hoc. Antenna doesn't have opinions, you tell it what you want and it does it. It's your choice.

## Do feed items accumulate forever?

Each collection defined in the "antenna.yaml" file includes a filter attribute. A filter is a sequence of SQL statements. These statements are run against the SQLite3 database associated with the collection. By default two filter statements are supplied. 

- Set everything to review, `UPDATE items SET status = 'review'`
- Set the recently (previous three weeks) published items to published, `UPDATE items SET status = 'published' WHERE pubDate >= date('now', '-21 days');`

The statements are applied one after the other in order. You can choose to include statements that remove stale items. You could set all items to published too. Each statement gets executed that you include. Since the database is a standard SQLite3 database you can use the SQLite3 command line program to explore and test what statements you might want to use yourself.

## Work flows

### Curating aggregations

When I want to add a feed to a collection I just open the Markdown file for the collection and add another list element that points to the feed. Example, `- [Robert's blog](https://rsdoiel.github.io/rss.xml)`.  To remove a feed from a collection, I just edit the Markdown file and delete that line.

The Markdown file is read each time you run `antenna harvest`. It'll only harvest items it finds matching the simple markdown list item pattern I've shown above.

### Updating your Antenna website

This involves two steps

1. harvest, e.g. `antenna harvest`
2. generate, e.g. `antenna generate`

This will cause the aggregation pages to be updated with the last content of the collection feeds. This is easy to run in a terminal as well as schedule via your operating system's scheduler (e.g. via cron, systemd or launchd daemons).

### Setting up a new Antenna

1. Create a directory
2. Change into that directory
3. Initialize your Antenna instance
4. Add a feed collection
5. Customize the collection's YAML files
6. Harvest
7. Generate
8. Preview your website at <http://localhost:8000>

Here's the steps taken in the terminal.

~~~shell
mkdir mysite
cd mysite
antenna yaml
edit index.md # define my initial collection, save the file
antenna add index.md
edit index.yaml # Customize the HTML wrapping the aggregated content.
antenna harvest
antenna generate
antenna preview
~~~

NOTE: A site generated in this way can be published to the Web via a static website service. I happen to use GitHub pages but there are lots of others out there.

### Adding a micro blog post to "mysite"

Here is a simple micro blog "helloworld.md" post Markdown file.

~~~markdown
---
pubDate: "2025-08-31"
---

Hello World!
~~~

I can added to the "index.md" collection using the "post" action.

~~~shell
antenna post index.md hellworld.md
~~~

I can see the updated post by running generate and preview.

~~~
antenna generate
antenna preview
~~~

This micro blog post only lives in the feed's item table. There is no landing page. It will only be written out to RSS and HTML if it remains in the "published" state. If the item is removed from the items table the micro blog post will not get rendered the next to you render the feed's page. This makes them somewhat emphermal.

### Adding a blog post to "mysite"

If I update "helloworld.md" to include a "postPath" and "link" then the post will get written into the the directory tree managed by my Antenna application. Here's the updated Markdown file.

~~~Markdown
---
link: http://localhost:8000/helloworld.html
postPath: helloworld.md
pubDate: "2025-08-31"
---

Hello World!
~~~

Run the post action, generate and then preview.

~~~shell
antenna post index.md helloworld.md
antenna generate
antenna preview
~~~

You should now see "htdocs/helloworld.html" and be able to navigate to it directly using <http://localhost:8000/helloworld.html>.

NOTE: If each time you run the post action on that file it'll regenerate the HTML.

There you have it, you have your own Antenna for aggregating your personal news site and website generation rolled together in one application.

## How would Antenna integrate into am existing website?

Antenna plays nice with other blogging tools. It only generates those pages associated with the aggregated collections and any posted Markdown files. The HTML generate is suitable to process with [PageFind](https://pagefind.app) if your static sites provides search. You can place the source Markdown files into your web tree an leverage the JSON API generated by [FlatLake](https://flatlake.app). If your using Pandoc or another means of rendering your website Antenna just gets used along side it. It doesn't require additional software or modify the web tree beyond what you specify.

## SQLite3 database as content storage

The Antenna application takes advantage of SQLite3 database(s) to persist the web content it manages. It is a binary format so you may want to back it up outside of your version control system (outside of Git). It's really up to you.

Because SQLite3 is used that means you can do any additional ad-hoc processing you want via SQL. This is a powerful feature and allows for potential integration with other systems. You could as example write a program to render come posts to other systems like BlueSky or Mastodon. I leave that as an exercise for the reader.

In the antenna.yaml file each collection has an attribute called "filter". The filter holds a list of SQL statements that are run before generating the HTML pages. You can list as many as you want, though by default two are provided (set everything to review, then set recent items to published).

## How do I manage individual web pages?

The Antenna application is feed oriented. By that I mean it'll generate an aggregation page and RSS file. A collection doesn't have to include links at all. A collection that just has posts is completely valid. The posts will be used as content for the aggregated HTML page and populate the outbound RSS feed. You can use a simple filter to ensure all posts are published before generating the feed page, `update items set status = 'published'`. That's it. All items in the collection will always be published. They'll always show up in the aggregated HTML and RSS file.

When you update a page you re-post it to the collection. When each item is posted Antenna generates the HTML page when the postPath and link are set. Then you can "preview" the site you can see the updated page.

## Other possibilities

Antenna application let's us easily setup our own new aggregation websites. We don't need to rely on Google, Facebook, etc. As long as there is an RSS/Atom or JSON feed, we can included it in our own aggregation.

Antenna can also serve as a site rendering tool for Markdown content. It supports posts as well as content that is harvested for aggregation pages. All collections include outbound RSS automatically. 

By combining aggregation of feeds with publication Antenna supports a distributed social web based on RSS 2.0. You can skip the complexity of [AT Protocol](https://en.wikipedia.org/wiki/AT_Protocol "Blue Sky's AT protocol") or [ActivityPub](https://en.wikipedia.org/wiki/ActivityPub "Mastodon's native protocol") and still be social. On my own Antenna site I consume content from both Blue Sky and Mastodon. Others are working on tools that will take an RSS feed and replicate the content using AT Protocol or Activity Pub but in the mean time let's just keep using RSS. It works as it always has. 

Final thoughts, because the feed collections are stored in a SQLite3 database you can opt to write your own page generates, connectors, API or what have you. This includes things like adding support for hash tag lists and '@' tags too. Since it runs on your machine you could extract your '@' tags form your posts and then ping some via SMS or email if you like. You could even write something that would post the item via their preferred social media platform. Where you go with it is up to you. Those features are beyond what I need for Antenna but that shouldn't stop you from taking it further.

- Project Website: <https://rsdoiel.github.io/antennaApp>
- Quick Install: <https://rsdoiel.github.io/antennaApp/INSTALL.html>
- GitHub Repository: <https://github.com/rsdoiel/antennaApp>
