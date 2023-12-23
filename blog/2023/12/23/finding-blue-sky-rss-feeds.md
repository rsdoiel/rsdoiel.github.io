---
title: Finding Bluesky RSS feeds
byline: R. S. Doiel, 2023-12-23
keywords: [ "bluesky", "rss" ]
---

# Find Bluesky RSS Feeds

With the update to [1.60](https://bsky.app/profile/bsky.app/post/3kh5rjl6bgu2i) of Bluesky we can now follow people on Bluesky via RSS feeds. This makes things much more convienient for me. 
The RSS feed is visible via the HTML markup on a person's profile page (which are now public). E.g. My Bluesky profile page is
at <https://bsky.app/profile/rsdoiel.bsky.social> and if you look at that pages HTML markup you'll see a link element in the head

```html
 <link rel="alternate" type="application/rss+xml" href="/profile/did:plc:nbdlhw2imk2m2yqhwxb5ycgy/rss">
```

That's the RSS feed. So now if you want to follow you can expand the URL to 

```
https://bsky.app/profile/did:plc:nbdlhw2imk2m2yqhwxb5ycgy/rss
```

And use if via your feed reader. This is a sweat feature. It allows me to move my reading from visiting the website
to getting updates via my feed reader.


