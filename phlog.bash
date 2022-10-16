# !/bin/bash

START_PATH=$(pwd)
BLOG=blog

#
# Add post - create a date directory if needed and then
# render markdown file in direct directory
#
if [[ "$#" = "2" ]]; then
    POST_PATH=$(echo "${2}" |tr - /)
    FILENAME="${1}"
    printf 'Posting markdown file into blog path %s\n' "$POST_PATH"
    printf 'Generating directory %s' "$POST_PATH"
    pttk phlogit -verbose -prefix=blog "$FILENAME" "${2}"

    printf 'Resolving %s to basename' "$FILENAME"
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
    pttk phlogit -verbose -prefix=blog "$FILENAME" "${2}"

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
START_YEAR="2016"

# Build index
echo "Building $BLOG/gophermap"
TITLE="Robert's ramblings"

printf '\n%s\n\n' "${TITLE}" >gophermap

printf 'Building Prior Years %s to %s\n' "$THIS_YEAR" "$START_YEAR"
for Y in $(range "$THIS_YEAR" "$START_YEAR"); do
    printf 'Building index for year %s\n' "$Y"
    printf '1%s\t%s\n' "$Y" "$Y" >> gophermap
    printf '\n' >> gophermap
    findfile -s .md "$Y" | sort -r | while read FNAME; do
        POST_FILENAME="${Y}/${FNAME}"
        ARTICLE=$(titleline -i "${Y}/${FNAME}")
        POST_DATE=$(dirname "${FNAME}" | sed -e 's/blog\///g;s/\//-/')
        if [ "${ARTICLE}" != "" ]; then
          printf '0%s\t/users/rsdoiel/blog/%s\tsdf.org\t70\n' "${POST_DATE}, ${ARTICLE}" "${POST_FILENAME}" >>gophermap
        fi
    done
    printf '\n' >> gophermap
done

cd "$START_PATH"

find blog -type f | grep -v -E ".html$" | while read FNAME; do
    chmod 664 "${FNAME}"
done
find blog -type d | while read DNAME; do
    chmod 775 "${DNAME}"
done

zip -r phlog.zip gophermap *.md
zip -r phlog.zip $(find blog -type f | grep -v -E ".html$")
zip -r phlog.zip $(find series -type f | grep -v -E ".html$")
