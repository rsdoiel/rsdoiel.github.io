# !/bin/bash


THIS_YEAR="$(reldate 0 day | cut -d '-' -f 1)"
LAST_YEAR="$(reldate -- -1 year | cut -d '-' -f 1)"
START_YEAR="2016"


# Build index
echo "Building blog/index.md"
TITLE="Robert's ramblings"

cat <<EOT> blog/index.md
---
title: "${TITLE}"
---

### Recent Posts

EOT


echo "Building Index for ${THIS_YEAR} posts"
antenna posts pages.md "${THIS_YEAR}-01-01" "${THIS_YEAR}-12-31" >>blog/index.md
echo "" >>blog/index.md
cp -vp blog/index.md  blog/recent.md
echo "Building Prior Years $LAST_YEAR to $START_YEAR"
for Y in $(range "$LAST_YEAR" "$START_YEAR"); do
    echo "Building index for year $Y"
    echo "## $Y" >> blog/index.md
    echo "" >> blog/index.md
    antenna posts pages.md "${Y}-01-01" "${Y}-12-31" >>blog/index.md
    echo "" >> blog/index.md
done

# Render all posts
antenna generate
