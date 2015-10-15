#!/bin/bash

#
# Make posts - create a date directory if needed and then
# prompt for title and slugify the name and edit with $EDITOR
#
POST_PATH=$(reldate 0 day| tr - /)
if [ -d "$POST_PATH" ]; then
    echo "Using $PATH_PATH for article"
else
    echo "Generating directory $POST_PATH"
    mkdir -p $POST_PATH
fi

if [ "$1" = "" ]; then
    echo -n "What is the title? "
    read -e TITLE
else
    TITLE="$1"
fi
echo "Generating file for '$TITLE'"
FILENAME=$(slugify "$TITLE")
if [ -f "$POST_PATH/$FILENAME.md" ]; then
    echo "Opening $POST_PATH/$FILENAME.md"
else
    touch $POST_PATH/$FILENAME
    echo "Created '$TITLE' as $POST_PATH/$FILENAME.md"
    echo "# $TITLE" >> $POST_PATH/$FILENAME.md
    echo "## $(reldate 0 day)" >> $POST_PATH/$FILENAME.md
fi
echo "" > nav.md
echo "+ [Home](/)" >> nav.md
echo "+ [Blog](/blog/)" >> nav.md
find ${POST_PATH:0:4} -type f | grep -E '\.html$' | while read ITEM; do
    POST_FILENAME=${ITEM:10}
    POST_TITLE=$(unslugify -e .html $POST_FILENAME)
    echo "+ [${POST_TITLE:1}](/blog/$ITEM)" >> nav.md
done
$EDITOR "$POST_PATH/$FILENAME.md"
shorthand \
    -e "{{year}} :!: echo -n $(date +%Y)" \
    -e "{{title}} :=: $TITLE" \
    -e "{{contentBlock}} :[<: $POST_PATH/$FILENAME.md" \
    -e "{{nav}} :[<: nav.md" \
    -e "html :{<: post.shorthand" \
    -e "html :>: $POST_PATH/$FILENAME.html" \
    -e ":exit:"

