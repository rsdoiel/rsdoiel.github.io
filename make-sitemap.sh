#!/bin/bash

#
# Make sitemap
#
# Find all the .html files and build a sitemap from them
#
FREQ="weekly"

cat <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
<urlset>
EOT

findfile -m -s .md | sort -r | while read ITEM; do
    FILENAME=$(echo "$ITEM" | cut -d\  -f 4-1000)
    LAST_MODIFIED=$(echo "$ITEM" | cut -d\  -f 1)
    HTML_FILENAME=${FILENAME/.md/.html}
    if [ -f "$HTML_FILENAME" ]; then
        cat <<EOT
  <url>
    <loc>/$HTML_FILENAME</loc>
    <changefreq>$FREQ</changefreq>
    <lastModified>$LAST_MODIFIED</lastModified>
  </url>"
EOT
   fi
done
echo "</urlset>"
