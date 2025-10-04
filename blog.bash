# !/bin/bash

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

# Build home page
cmarkprocess index.txt >index.md
antenna page index.md
