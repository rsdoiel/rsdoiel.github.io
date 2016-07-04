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

# Build nav
echo "Building blog nav"
cat nav.md > $BLOG/nav.md
echo "+ [up](../)" >> nav.md
echo "Building blog footer"
cat footer.md > $BLOG/footer.md

#
# Add post - create a date directory if needed and then
# render markdown file in direct directory
#
POST_PATH=$(reldate 0 day| tr - /)
echo "Generating directory $POST_PATH"
mkdir -p $BLOG/$POST_PATH

if [ "$1" != "" ]; then
    FILENAME="$1"

    echo "Copying markdown file into blog path $POST_PATH"
    cp -v "$FILENAME" "$BLOG/$POST_PATH/"
    echo "Resolving $FILENAME to basename"
    FILENAME=$(pathparts -b $FILENAME)
    echo "Adding to git $POST_PATH/$FILENAME"
    git add $BLOG/$POST_PATH/$FILENAME
    git add $BLOG/$POST_PATH/${FILENAME/.md/.html}
    git commit -am "Added $BLOG/$POST_PATH/$FILENAME"
fi


echo "Changing work directory to $BLOG"
cd $BLOG
echo "Work directory now $(pwd)"

# Render all posts
findfile -s .md ${POST_PATH:0:4} | sort -r | while read ITEM; do
    echo "Rendering ${POST_PATH:0:4}/$ITEM"
    TITLE=$(fileTitle "${POST_PATH:0:4}/$ITEM")
    shorthand \
    -e "{{year}} :!: echo -n $(date +%Y)" \
    -e "{{title}} :=: $TITLE" \
    -e "{{contentBlock}} :[<: ${POST_PATH:0:4}/$ITEM" \
    -e "{{nav}} :[<: nav.md" \
    -e "{{footer}} :[<: footer.md" \
    -e "html :{<: post.shorthand" \
    -e "html :>: ${POST_PATH:0:4}/${ITEM/.md/.html}" \
    -e ":exit:"
done 
echo "Commit changes"
git commit -am "refreshed blog"

# Build index
TITLE="Robert's ramblings"
echo "" > index.md
findfile -s .md ${POST_PATH:0:4} | sort -r | while read ITEM; do
    echo "Processing index.md <-- ${POST_PATH:0:4}/$ITEM"
    POST_FILENAME=${POST_PATH:0:4}/$ITEM
    POST_TITLE=$(fileTitle "$POST_FILENAME")
    REL_PATH="${POST_PATH:0:4}/$ITEM"
    POST_DATE=$(pathparts -d $REL_PATH)
    POST_DATE=${POST_DATE//\//-}
    echo "+ [$POST_TITLE](/blog/${POST_PATH:0:4}/${ITEM/.md/.html}), $POST_DATE" >> index.md
done
shorthand \
    -e "{{year}} :!: echo -n $(date +%Y)" \
    -e "{{title}} :=: $TITLE" \
    -e "{{pageContent}} :[<: index.md" \
    -e "{{nav}} :[<: nav.md" \
    -e "{{footer}} :[<: footer.md" \
    -e "html :{<: index.shorthand" \
    -e "html :>: index.html" \
    -e ":exit:"

cd $START_PATH
