# !/bin/bash

START_PATH=$(pwd)
BLOG=blog

THIS_YEAR="$(reldate 0 day | cut -d '-' -f 1)"
LAST_YEAR="$(reldate -- -1 year | cut -d '-' -f 1)"
START_YEAR="2016"
# Render all posts
for Y in $(range "$THIS_YEAR" "$START_YEAR"); do
    echo "Rendering posts for $Y"
    find "blog/${Y}" -type f | grep -E '.md$' | sort -r | while read FNAME; do
      HNAME="$(basename ${FNAME} ".md").html"
      printf "Rendering ${FNAME} -> ${HNAME}\n"
      antenna post blog.md "${FNAME}" || exit 2
      antenna post archive.md "${FNAME}" || exit 3
    done
done

exit 0 # DEBUG

cd "$BLOG"
echo "Work directory now $(pwd)"
# Build index
echo "Refreshing Posts"
for YEAR in 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025; do
  find "blog/${YEAR}" -type f | grep -E '.md$' | while read -r FNAME;do
    if antenna post blog.md "${FNAME}"; then
      printf "OK, ${FNAME}\n"
    else
      printf "Problem with post ${FNAME}\n"
      exit 1
    fi
  done
done
echo "Building blog.md"
antenna generate blog.md
cp -v blog.html recent.html

antenna page index.md
git add index.html

cd "$START_PATH"

