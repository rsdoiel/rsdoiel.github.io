# !/bin/bash

START_PATH=$(pwd)
BLOG=blog

#
# Add post - create a date directory if needed and then
# render markdown file in direct directory
#
if [[ "$#" = "2" ]]; then
    POST_PATH=$(echo "${2}" | tr - /)
    FILENAME="${1}"
elif [[ "$1" != "" ]]; then
    POST_PATH=$(reldate 0 day | tr - /)
    FILENAME="${1}"
else
    echo "No post to add"
    POST_PATH=""
    FILENAME=""
fi

if [[ "$POST_PATH" != "" ]]; then
    printf 'Posting markdown file into blog path %s\n' "$POST_PATH"
    printf 'Generating directory %s\n' "$POST_PATH"
    pttk phlogit -verbose -prefix=blog "$FILENAME" "${2}"

    FILENAME=$(basename "$FILENAME")
    printf 'Resolving %s to basename\n' "$FILENAME"
    FILENAME=$(basename "$FILENAME")
    printf 'Adding to git %s\n' "$POST_PATH/$FILENAME"
    git add "$BLOG/$POST_PATH/$FILENAME"
    # Make sure we have a place holder stub to keep in the repo
    # After running clean
    touch "$BLOG/$POST_PATH/${FILENAME/.md/.html}"
    git add "$BLOG/$POST_PATH/${FILENAME/.md/.html}"
    git commit -am "Added $BLOG/$POST_PATH/$FILENAME"
fi

#
# Refresh the phlog
#
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
    pttk phlogit -refresh="$Y"
    printf 'Building index for year %s\n' "$Y"
    CNT=$(find "$Y" -type f | grep -E '.md$' | wc -l)
    printf '1%s (%d posts)\t%s\n' "$Y" "$CNT" "$Y" >>gophermap

    find "$Y" -type f | grep -E '.md$' | sort -r | while read FNAME; do
        POST_FILENAME="${FNAME}"
        ARTICLE=$(pttk frontmatter "${FNAME}" | jq -r .title)
        POST_DATE=$(dirname "${FNAME}" | sed -e 's/blog\///g;s/\//-/')
        if [ "${ARTICLE}" != "" ]; then
            printf '0%s\t%s\r\n' "${POST_DATE}, ${ARTICLE}" "${POST_FILENAME}" >>gophermap
        fi
    done
    printf '\n' >>gophermap
done

cd "$START_PATH"

