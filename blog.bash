# !/bin/bash


THIS_YEAR="$(reldate 0 day | cut -d '-' -f 1)"
LAST_YEAR="$(reldate -- -1 year | cut -d '-' -f 1)"
START_YEAR="2016"


# Build index
echo "Building blog/index.txt"
TITLE="Robert's ramblings"

cat <<EOT> blog/index.txt
---
title: "${TITLE}"
---

### Recent Posts

EOT


echo "Building Index for ${THIS_YEAR} posts"
antenna posts pages.md "${THIS_YEAR}-01-01" "${THIS_YEAR}-12-31" >>blog/index.txt
echo "" >>blog/index.txt
cp -vp blog/index.txt blog/recent.txt
echo "Building Prior Years $LAST_YEAR to $START_YEAR"
for Y in $(range "$LAST_YEAR" "$START_YEAR"); do
    echo "Building index for year $Y"
    echo "## $Y" >> blog/index.txt
    echo "" >> blog/index.txt
    antenna posts pages.md "${Y}-01-01" "${Y}-12-31" >>blog/index.txt
    echo "" >> blog/index.txt
done
# Fix the relative link blog post links
sed -i.bak -E 's/\(blog/\(\/blog/g' blog/index.txt
sed -i.bak -E 's/\(blog/\(\/blog/g' blog/recent.txt

antenna page blog/index.txt blog/index.md blog/index.html

