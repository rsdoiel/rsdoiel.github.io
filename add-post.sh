#!/bin/bash

START_PATH=$(pwd)
BLOG=blog

function fileTitle {
    FILENAME=$(echo "$1" | sed -e "s/\s$//g")
    if [ -f "$FILENAME" ]; then
      echo $(grep "# " "$FILENAME" | head -1 | sed -e "s/# //g")
    else
      echo "Can't find $FILENAME"
      exit 1
    fi
}

#
# Add post - create a date directory if needed and then
# render markdown file in direct directory
#
POST_PATH=$(reldate 0 day| tr - /)
echo "Generating directory $POST_PATH"
mkdir -p $POST_PATH

if [ "$1" = "" ]; then
    echo -n "What is markdown filename? "
    read -e FILENAME
else
    FILENAME="$1"
fi

echo "Copying markdown file into blog path $POST_PATH"
cp -v "$FILENAME" "$BLOG/$POST_PATH/"
echo "Resolving $FILENAME to basename"
FILENAME=$(pathparts -b $FILENAME)
echo "Adding to git $BLOG/$POST_PATH/$FILENAME"
git add $BLOG/$POST_PATH/$FILENAME
git commit -am "Added blog post"

echo "Changing work directory to $BLOG"
cd $BLOG
echo "Work directory now $(pwd)"
# Build nav
echo "" > nav.md
echo "+ [Home](/)" >> nav.md
echo "+ [Blog](/blog/)" >> nav.md
findfile -s .md ${POST_PATH:0:4} | while read ITEM; do
    echo "Processing ${POST_PATH:0:4}/$ITEM"
    POST_FILENAME=${POST_PATH:0:4}/$ITEM
    POST_TITLE=$(fileTitle "$POST_FILENAME")
    echo "+ [$POST_TITLE](/blog/${POST_PATH:0:4}/${ITEM/.md/.html})" >> nav.md
done

# Render post
TITLE=$(fileTitle "$POST_PATH/$FILENAME")
shorthand \
    -e "{{year}} :!: echo -n $(date +%Y)" \
    -e "{{title}} :=: $TITLE" \
    -e "{{contentBlock}} :[<: $POST_PATH/$FILENAME" \
    -e "{{nav}} :[<: nav.md" \
    -e "html :{<: post.shorthand" \
    -e "html :>: $POST_PATH/${FILENAME/.md/.html}" \
    -e ":exit:"

# Build index
TITLE="Robert's ramblings"
echo "" > $index.md
findfile -s .md ${POST_PATH:0:4} | sort -r | while read ITEM; do
    echo "Processing index.md <-- ${POST_PATH:0:4}/$ITEM"
    POST_FILENAME=${POST_PATH:0:4}/$ITEM
    POST_TITLE=$(fileTitle "$POST_FILENAME")
    echo "+ [$POST_TITLE](/blog/${POST_PATH:0:4}/${ITEM/.md/.html})" >> index.md
done
shorthand \
    -e "{{year}} :!: echo -n $(date +%Y)" \
    -e "{{title}} :=: $TITLE" \
    -e "{{pageContent}} :[<: index.md" \
    -e "{{nav}} :[<: nav.md" \
    -e "html :{<: index.shorthand" \
    -e "html :>: index.html" \
    -e ":exit:"

cd $START_PATH
