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
echo "+ [up](/blog/)" >> $BLOG/nav.md

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
    mkpage \
        "year=text:$(date +%Y)" \
        "title=text:$TITLE" \
        "contentBlock=${POST_PATH:0:4}/$ITEM" \
        "nav=../nav.md" \
        "footer=footer.md" \
        "mdfile=text:$(basename $ITEM)" \
        post.tmpl > "${POST_PATH:0:4}/${ITEM/.md/.html}"
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
echo "" >> index.md
echo "## [2016](/blog/)" >> index.md
echo "" >> index.md
findfile -s .html 2016 | while read FNAME; do
    ARTICLE=$(basename $FNAME | sed -e 's/.html//g;s/-/ /g')
    echo " + [$ARTICLE](/blog/2016/$FNAME)" >> index.md
done
mkpage \
    "year=text:$(date +%Y)" \
    "title=text:$TITLE" \
    "pageContent=index.md" \
    "nav=nav.md" \
    "footer=footer.md" \
    index.tmpl > index.html

cd $START_PATH
