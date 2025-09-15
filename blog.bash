# !/bin/bash

START_PATH=$(pwd)
BLOG=blog

# Build blog nav
if [ ! -f nav.include ]; then
  echo "Building blog nav"
  pandoc nav.md >> "nav.include"
fi

if [ ! -f footer.include ]; then
  echo "Building blog footer"
  pandoc footer.md >> "footer.include"
fi

THIS_YEAR="$(reldate 0 day | cut -d '-' -f 1)"
LAST_YEAR="$(reldate -- -1 year | cut -d '-' -f 1)"
START_YEAR="2016"
# Render all posts
for Y in $(range "$THIS_YEAR" "$START_YEAR"); do
    echo "Rendering posts for $Y"
    find "blog/${Y}" -type f | grep -E '.md$' | sort -r | while read FNAME; do
      HNAME="$(basename ${FNAME} ".md").html"
      printf "Rending ${FNAME} -> ${HNAME}\n"
      antenna post blog.md "${FNAME}" || exit 2
    done
done

cd "$BLOG"
echo "Work directory now $(pwd)"
# Build index
echo "Building $BLOG/index.md"
TITLE="Robert's ramblings"

cat <<EOT> index.md
---
title: "${TITLE}"
---

### Recent Posts

EOT

echo "Building Index for $THIS_YEAR posts"
findfile -s .md "$THIS_YEAR" | sort -r | while read ITEM; do
    echo "Processing index.md <-- $THIS_YEAR/$ITEM"
    POST_FILENAME=$THIS_YEAR/$ITEM
    POST_TITLE=$(pttk frontmatter "$POST_FILENAME" | jq -r .title)
    REL_PATH="$THIS_YEAR/$ITEM"
    POST_DATE=$(dirname "$REL_PATH")
    POST_DATE=${POST_DATE//\//-}
    echo "- [$POST_TITLE](/blog/$THIS_YEAR/${ITEM}), $POST_DATE" >> index.md
done
echo "" >> index.md
cp -vp index.md ../recent.md
echo "Building Prior Years $LAST_YEAR to $START_YEAR"
for Y in $(range "$LAST_YEAR" "$START_YEAR"); do
    echo "Building index for year $Y"
    echo "$Y" >> index.md
    echo "----" >> index.md
    echo "" >> index.md
    findfile -s .html "$Y" | sort -r | while read FNAME; do
        POST_FILENAME="$(dirname $FNAME)/$(basename "${FNAME}" ".html").md"
        ARTICLE=$(pttk frontmatter "${Y}/${POST_FILENAME}" | jq -r .title)
        POST_DATE=$(dirname "$FNAME" | sed -e 's/blog\///g;s/\//-/')
        if [ "${ARTICLE}" != "" ]; then
          echo " - $POST_DATE, [$ARTICLE](/blog/$Y/${POST_FILENAME})" >> index.md
        fi
    done
    echo "" >> index.md
done

pandoc \
    -M "year:$(date +%Y)" \
    -M "title:$TITLE" \
    -B ../nav.include \
    -A ../footer.include \
	--lua-filter=../links-to-html.lua \
    --template ../page.tmpl \
    index.md \
    > index.html

cd "$START_PATH"

