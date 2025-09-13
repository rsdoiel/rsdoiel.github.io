---
title: Build a Blog with Antenna
author: R. S. Doiel
description: |
  This is a short post on using antennaApp to build a traditional blog.
  All you need is antennaApp, a text editor and a little knowledge of
  Markdown.

  antennaApp uses the front matter expressed as YAML as metadata for
  processing the blog post and collecting the metadata for rendering
  a page listing all the posts (an aggregation of posts) as HTML and
  as an RSS 2.0 feeed.

  HTML pages can be customized for your sight in a simple YAML
  configuration file.

dateCreated: "2025-09-05"
dateModified: "2025-09-05"
datePublished: "2025-09-05"
postPath: "blog/2025/09/05/Build_a_Blog_with_Antenna_App.md"
---

# Build a Blog with Antenna

By R. S. Doiel, 2025-09-05

Antenna is a feed orient content management tool. It can use to build a and run a blog. What follows are the steps needed to create a simple blog using only Antenna application, Markdown and the Antenna YAML configuration files.

## Setting up

The first thing we need is a directory to hold our website. That can be done from a terminal on Linux, macOS or Windows using the following command.

~~~shell
mkdir myblog
~~~

We want to change into that directory.

~~~shell
cd myblog
~~~

Now we're ready to begin.

## Initializing the blog

The Antenna application, `antenna` has an "initialization" action. This creates the configuration file needed for your blog. Here's what you need to type in the terminal (same for Linux, macOS and Windows).

~~~shell
antenna init
~~~

This will result in a file called "antenna.yaml" being created. If you are using macOS or Linux you can type the following and see it.

~~~shell
ls -l
~~~

On Windows you would use the `dir` command instead.

~~~shell
dir
~~~

## Defining our blog collection

A blog is built from three parts

- file system path(s) holding the blog posts[^1]
- One or more HTML pages showing the available posts in reverse chronological order
- An RSS feed of the recent blog posts

[^1]: The file paths to posts can be whatever you want. Antenna doesn't impose an structure. Traditionally a structure broken down for year, two digit month and another for two digit days is common. So posts are contained in a director called "blog" it'll have a path broken to by year, month and day. The day directory holds the blog post. Example I have a post called "updates.md" for the date August 5th, 2025. That might be held in `blog/2025/08/05/updates.md` Markdown file.

In terms of Antenna these are contained in a collection which needs to be defined. Then
we use the post action to add Markdown documents, with front matter, as blog posts. The post
action also generates an HTML version of the post based on the settings in the front matter. Finally
the RSS feed and HTML aggregation page are render by Antenna's generate action. That's pretty much it.

Let's first create our collection. I am going to call it "index.md". The reason I call the collection "index.md" is it'll result in an HTML page called "index.html", a RSS file called "index.xml" a configuration page page called "index.yaml" and an SQLite3 database file called "index.db".  Here's an example of a Markdown document defining the blog.

~~~markdown
  ---
  title: My blog
  ---

  # Welcome to My Blog

  This is My blog where I use the Antenna app to curate a simple blog.
  The Markdown forms the definition of the "index.md" collection. The blog
  will be managed in the "index.db" SQLite3 database. It can be configured by
  modifying the "index.yaml" file generated when this collection is added to the
  Antenna configuration using the "add" action.
~~~

That's all that is needed, save this Markdown document as "index.md". Now let's add this to our Antenna collection. We only need to do this once.

~~~shell
antenna add index.md
~~~

If you list the directory you should see "index.db" and "index.yaml". You can modify the "index.yaml" to set the various HTML elements that will host either the list of blog posts or the individual blog post content.

~~~shell
ls -1 index.*
~~~

or for Windows.

~~~shell
dir index.*
~~~

## Adding the first blog post

I am going to assume the first blog post is called "welcome.md". I am also going to assume you'll using a blog oriented directory structure. For this example today's date is September 5th, 2025. I need to create a place to hold my blog post "welcome.md". I will first create a directory to hold it.

~~~shell
mkdir -p blog/2025/09/05
~~~

On Windows

~~~shell
New-Item -ItemType Directory -Force -Path blog\2025\09\05
~~~

Now you need to open the a new file in that directory called "welcome.md". If you have VS Code or Codium installed as your editor you can do the following.

~~~shell
code blog/2025/09/05/welcome.md
~~~

Or for Windows.

~~~shell
code blog\2025\09\05\welcome.md
~~~

In that file create our welcome post. We need to include the following attributes in our front matter, "postPath", "link", "pubDate". Here's my version of "welcome.md" Markdown.

~~~markdown
  ---
  title: Welcome
  postPath: "blog/2025/09/05/welcome.md"
  pubDate: "2025-09-05"
  ---

  # Welcome

  This is a demonstration of Blogging with Antenna.

~~~

NOTE: If you are on Windows, you'll want to use the version of postPath that looks like this, `postPath: blog\2025\09\05\welcome.html`. You can now add the the post using the post action.

~~~shell
antenna post index.md blog/2025/09/05/welcome.md
~~~

Or on Windows

~~~shell
antenna post index.md blog\2025\09\05\welcome.md
~~~

We're are almost done. You should see the version of welcome.md you created and a new "welcome.html" generated when you use the post action. We need to generate the index.html and index.xml files with the updated post.

~~~shell
antenna generate
~~~

You can preview your new blog post at `http://localhost:8000` using the preview action and pointing your web browser at that URL.

~~~shell
antenna preview
~~~

## Updating a post

Any time you run the post command on your Markdown file the post with the matching link and postPath gets updated. Below I open and update the "welcome.md" file. Then I post it again to regenerate the HTML page.

~~~shell
code blog/2025/09/05/welcome.md
antenna post index.md blog/2025/09/05/welcome.md
~~~

That's it you now can add and update posts for your blog. Antenna will manage the index.html and index.xml documents for you when you run the `antenna generate` command again. You then use the preview action to view it in your web browser.

NOTE: If this was your blog you'd change the value I used for the link element to match how your website is structured and use it's URL.  I used a localhost URL with port number just to keep things simple and to allow us to test using the `antenna preview`.

## Enhancing you blog 

You will likely want some navigation and other text on your blog pages. This is accomplished by updating the "index.yaml" file. In this file you can set the path to your custom CSS, to any JavaScript script you might want to include. You can also set your site header, footer and nav elements. Finally you can even include HTML elements before and after the generated content. Here's an example of a customized "index.yaml" file.


~~~yaml
css: css/site.css
header: |
  <header><h1>Welcome to My Blog</h1></header>

nav: |
  <nav>
    <ul>
      <li><a href="/">Home</a></li>
    </ul>
  </nav>

footer: |
  <footer><!-- your custom footer insert HTML goes here --></footer>
~~~

Now re-post your welcome.md then generate followed by preview to see the changes.

~~~shell
antenna post index.md blog/2025/09/05/welcome.md
antenna generate
antenna preview
~~~

You're blog is staged you can now publish on the Internet using the tools provided by your host. If you're using GitHub that might mean committing and pushing to a specific branch setup for your website (see GitHub pages documentation). 

Happy blogging!
