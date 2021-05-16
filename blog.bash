#!/bin/bash

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

#
# Add post - create a date directory if needed and then
# render markdown file in direct directory
#
if [[ "$#" = "2" ]]; then
    POST_PATH=$(echo "${2}" |tr - /)
    FILENAME="${1}"
    echo "Posting markdown file into blog path $POST_PATH"
    echo "Generating directory $POST_PATH"
    blogit -verbose -prefix=blog "$FILENAME" "${2}"

    echo "Resolving $FILENAME to basename"
    FILENAME=$(basename "$FILENAME")
    echo "Adding to git $POST_PATH/$FILENAME"
    git add "$BLOG/$POST_PATH/$FILENAME"
    # Make sure we have a place holder stub to keep in the repo
    # After running clean
    touch "$BLOG/$POST_PATH/${FILENAME/.md/.html}"
    git add "$BLOG/$POST_PATH/${FILENAME/.md/.html}"
    git commit -am "Added $BLOG/$POST_PATH/$FILENAME"
elif [[ "$1" != "" ]]; then
    POST_PATH=$(reldate 0 day| tr - /)
    echo "Posting markdown file into blog path $POST_PATH"
    echo "Generating directory $POST_PATH"
    blogit -verbose -prefix=blog "$FILENAME" "${2}"

    FILENAME=$(basename "$FILENAME")
    echo "Resolving $FILENAME to basename"
    FILENAME=$(basename "$FILENAME")
    echo "Adding to git $POST_PATH/$FILENAME"
    git add "$BLOG/$POST_PATH/$FILENAME"
    # Make sure we have a place holder stub to keep in the repo
    # After running clean
    touch "$BLOG/$POST_PATH/${FILENAME/.md/.html}"
    git add "$BLOG/$POST_PATH/${FILENAME/.md/.html}"
    git commit -am "Added $BLOG/$POST_PATH/$FILENAME"
else
    echo "No post to add"
fi

echo "Changing work directory to $BLOG"
cd "$BLOG"
echo "Work directory now $(pwd)"
THIS_YEAR="$(reldate 0 day | cut -d '-' -f 1)"
LAST_YEAR="$(reldate -- -1 year | cut -d '-' -f 1)"
START_YEAR="2016"
# Render all posts
for Y in $(range "$THIS_YEAR" "$START_YEAR"); do
    echo "Rendering posts for $CUR_YEAR"
    findfile -s ".md" "${Y}" | sort -r | while read FNAME; do
        TITLE=$(titleline -i "${Y}/${FNAME}")
        POST_DATE="${Y}-"$(dirname "${FNAME}" | sed -e 's/blog\///g;s/\//-/g')
        echo "Rendering ${Y}/${FNAME}: \"${TITLE}\", ${POST_DATE}"
        pandoc \
            -M "year:${POST_DATE:0:4}" \
            -M "title:${TITLE}" \
            -B ../nav.include \
            -A ../footer.include \
            --template post.tmpl \
            "${Y}/${FNAME}" \
            > "${Y}/$(dirname "${FNAME}")/$(basename "${FNAME}" '.md').html"
    done 
done

# Build index
echo "Building $BLOG/index.md"
TITLE="Robert's ramblings"

cat <<EOT> index.md
---
title: "${TITLE}"
---

Recent Posts
------------

EOT

echo "Building Index for $THIS_YEAR posts"
findfile -s .md "$THIS_YEAR" | sort -r | while read ITEM; do
    echo "Processing index.md <-- $THIS_YEAR/$ITEM"
    POST_FILENAME=$THIS_YEAR/$ITEM
    POST_TITLE=$(titleline -i "$POST_FILENAME")
    REL_PATH="$THIS_YEAR/$ITEM"
    POST_DATE=$(dirname "$REL_PATH")
    POST_DATE=${POST_DATE//\//-}
    echo "+ [$POST_TITLE](/blog/$THIS_YEAR/${ITEM/.md/.html}), $POST_DATE" >> index.md
done
echo "" >> index.md
echo "Building Prior Years $LAST_YEAR to $START_YEAR"
for Y in $(range "$LAST_YEAR" "$START_YEAR"); do
    echo "Building index for year $Y"
    echo "$Y" >> index.md
    echo "----" >> index.md
    echo "" >> index.md
    findfile -s .html "$Y" | sort -r | while read FNAME; do
        POST_FILENAME="$(dirname $FNAME)/$(basename "${FNAME}" ".html")"
        ARTICLE=$(titleline -i "${Y}/${POST_FILENAME}.md")
        POST_DATE=$(dirname "$FNAME" | sed -e 's/blog\///g;s/\//-/')
        echo " + $POST_DATE, [$ARTICLE](/blog/$Y/$FNAME)" >> index.md
    done
    echo "" >> index.md
done
pandoc \
    -M "year:$(date +%Y)" \
    -M "title:$TITLE" \
    -B ../nav.include \
    -A ../footer.include \
    --template ../page.tmpl \
    index.md \
    > index.html

cd "$START_PATH"
