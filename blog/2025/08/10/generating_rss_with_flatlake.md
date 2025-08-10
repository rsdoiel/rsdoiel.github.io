---
title: Generating RSS with FlatLake
abstract: >
  A show post describing a prototype in Deno+TypeScript for generating RSS 2.0
  feeds from a FlatLake generated JSON API.
author: R. S. Doiel
dateCreated: '2025-08-10'
dateModified: '2025-08-10'
keywords:
  - FlatLake
  - JSON API
  - RSS 2.0
datePublished: '2025-08-10'
---

# Generating RSS with FlatLake

By R. S. Doiel, 2025-08-10

One of the must have features missing from many static websites are RSS feeds.
Many people produce blogs using CommonMark/Markdown documents with front matter.
[FlatLake](https://flatlake.app "an open source tool from Cloud Cannon")
produces a JSON API from front matter. The API makes it easy to generate various
types of feeds. All that is needed is something to translate the JSON API
documents to the feed format you want. In this post I will show a proof of
concept using Deno+TypeScript to process the Flatlake generate JSON API into an
RSS feed.

## Requirements for your site

You need [FlateLake](https://flatlake.app) installed. You also need to have
front matter in your CommonMark/Markdown documents. No front matter, no API. I
rely on front matter in my publication process for blog so FlatLake is a good
fit. I only use a mimum of features in FlatLake. Here's the configuration file I
use.

```yaml
global:
  outputs:
    - "list"
collections:
  - output_key: "posts"
    page_size: 24
    sort_key: "datePublished"
    sort_direction: "desc"
    list_elements:
      - "data"
      - "content"
    inputs:
      - path: "./blog"
        glob: "**/*{md}"
```

## Generating the json api

Once you have FlatLake configured generating the JSON API is as simple as
running the command

```shell
flatlake
```

That's it. It scans the directory named "blog" in the directory where I stage my
website. The output goes to a directory called "api". If you prefer a diffent
path FlatLake has options to support that. See `flatlake --help` or the website
[FlatLake/docs](https://flatlake.app/docs). The verbose and logging options are
helpful in understanding what FlatLake is doing.

## Short anatomy of RSS XML

The RSS XML has two parts. A channel description and the items in the feed. The
items map the data about your blog posts. The channel description isn't directly
available from the FlatLake generated data. The easy solution I've chosen is to
describe the channel in a YAML. Here's the example I use for my blog.

```yaml
title: "Robert's Ramblings"
description: "Robert's website and blog posts"
link: "https://rsdoiel.github.io"
```

## JSON API to RSS

In my publication process the next thing I do is used a Deno+TypeScript program
to convert the JSON API into an RSS feed. I have one feed for my site contains
recent posts. The path in the api tree I use it `api/posts/all/page-1.json`.
Based on my configuration file this contains the most recent 24 posts sorted by
descending publication date. At this point it's just a matter of cross walking
the content of "page-1.json" into an RSS XML feed file.

Here's a TypeScript module I knock together to test out the concept.

~~~TypeScript
/**
 * flatlakeToRSS2.ts translate a FlatLake JSON API document to RSS2 XML.
 *  
 *  Copyright (C) 2025  R. S. Doiel
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
// Define the structure of your input data
export interface Post {
  content: string;
  data: {
    abstract: string;
    author: string;
    dateCreated?: string;
    dateModified?: string;
    datePublished?: string;
    keywords: string[];
    pubDate?: string;
    title: string;
    url: string;
  };
}

// Define the structure of the RSS feed
export interface RSSFeed {
  title: string;
  description: string;
  link: string;
  language?: string;
  copyright?: string;
  managingEditor?: string;
  webMaster?: string;
  items: RSSItem[];
}

export interface RSSItem {
  title: string;
  description: string;
  link: string;
  pubDate: string;
  author: string;
  categories: string[];
}

// Function to convert JSON data to RSS feed with YAML configuration
export function convertToRSS(
  posts: Post[],
  channelInfo: Partial<RSSFeed>,
): RSSFeed {
  const feed: RSSFeed = {
    title: channelInfo.title || "My Blog",
    description: channelInfo.description || "A collection of blog posts",
    link: channelInfo.link || "http://example.com",
    language: channelInfo.language,
    copyright: channelInfo.copyright,
    managingEditor: channelInfo.managingEditor,
    webMaster: channelInfo.webMaster,
    items: [],
  };

  posts.forEach((post) => {
    const item: RSSItem = {
      title: post.data.title,
      description: post.data.abstract,
      link: `http://example.com/${post.data.url}`,
      pubDate: new Date(
        post.data.datePublished || post.data.pubDate || post.data.dateCreated ||
          post.data.dateModified || Date.now(),
      ).toUTCString(),
      author: post.data.author,
      categories: post.data.keywords,
    };
    feed.items.push(item);
  });

  return feed;
}

// Function to generate the RSS XML
export function generateRSS(feed: RSSFeed): string {
  const itemsXML = feed.items
    .map(
      (item) => `
        <item>
            <title><![CDATA[${item.title}]]></title>
            <description><![CDATA[${item.description}]]></description>
            <link>${item.link}</link>
            <pubDate>${item.pubDate}</pubDate>
            <author>${item.author}</author>
            ${
        item.categories.map((category) => `<category>${category}</category>`)
          .join("")
      }
        </item>
    `,
    )
    .join("");

  return `<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
    <channel>
        <title><![CDATA[${feed.title}]]></title>
        <description><![CDATA[${feed.description}]]></description>
        <link>${feed.link}</link>
        ${feed.language ? `<language>${feed.language}</language>` : ""}
        ${feed.copyright ? `<copyright>${feed.copyright}</copyright>` : ""}
        ${
    feed.managingEditor
      ? `<managingEditor>${feed.managingEditor}</managingEditor>`
      : ""
  }
        ${feed.webMaster ? `<webMaster>${feed.webMaster}</webMaster>` : ""}
        ${itemsXML}
    </channel>
</rss>`;
}
~~~

## Putting it all together

The demo program can be compiled with the follow.

```shell
git clone https://github.com/rsdoiel/flatlakeToRSS2
cd flatlakeToRSS2
deno task build
```

The program in the `bin` directory can then be used to generate the RSS XML from
your FlatLake API. Copy it to some place in your PATH.

Now I go to my website staging directory. I can take the following steps to test
RSS generation from FlatLake.

```shell
cd $HOME/Sites/rsdoiel.github.io
flatlake
edit rss_channel.yaml # Create the YAML file above
flatlakeToRSS2 rss_channel.yaml api/posts/all/page-1.json >rss.xml
```

## Lessons learned

There are some very good feed libraries out there like
[Dave Winer's](https://scripting.com)
[ReallySimple](https://github.com/scripting/reallysimple). That could save using
format strings to render XML. It also has the advantage that is can be use to
read feeds as well.

Ideally I'd like the generation of RSS feeds to be in integrated into my
[BlogIt](/BlogIt) tool I am working on.

This experiment showed that inspite of the limitted documentation of the
FlatLake website that it's worth exploring as an off the shelf open source
solution. It might just earn a place along side [PageFind](https://pagefind.app)
and [Pandoc](https://pandoc.org) as part of my regular web toolkit.