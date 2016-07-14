#!/bin/bash

BLOG_DIR="blog"

if [ "$1" != "" ]; then
    BLOG_DIR="$1"
fi

#
# Make a simple RSS feed
#
TODAY=$(timefmt -output RFC1123)
cat <<EOT
<?xml version="1.0"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>R. S. Doiel</title>
    <link>https://rsdoiel.github.io/</link>
    <description>Robert's ramblings</description>
    <language>en-us</language>
    <docs>http://blogs.law.harvard.edu/tech/rss</docs>
    <generator>A Bash script</generator>
    <pubDate>$TODAY</pubDate>
    <atom:link href="http://rsdoiel.github.io/rss.xml" rel="self" type="application/rss+xml" />
EOT

findfile -s .html $BLOG_DIR | grep -E "20[0-9][0-9]/" | sort -r | while read FNAME; do
    TM=${FNAME:0:10}
    TITLE=$(grep -Ei "<h1>" $BLOG_DIR/$FNAME)
    LINK="http://rsdoiel.github.io/blog/$FNAME"
    PUBDATE=$(timefmt -input "2006/01/02 15:04:05 -0700" -output RFC1123 "$TM 08:00:00 -0700")
    GUID="http://rsdoiel.github.io/blog/$FNAME"

    #FIXME: I need to pull an extract from the article
    # may need something to strip tags 
    # DESCRIPTION="blah, blah, blah"
    #echo "Description: $DESCRIPTION"
    cat <<ITEM
    <item>
        <title>${TITLE:7:-5}</title>
        <link>$LINK</link>
        <pubDate>$PUBDATE</pubDate>   
        <guid>$GUID</guid>
    </item>
ITEM

done

cat <<EOT
  </channel>
</rss>
EOT
