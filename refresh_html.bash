#!/bin/bash

# Redo blog posts
for YEAR in 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026; do
  find "blog/${YEAR}" -type f | grep -E '.md$' | while read -r FNAME;do
    if antenna post pages.md "${FNAME}"; then
      printf "OK, generated post ${FNAME}\n"
    else
      printf "Problem with post %s\n" "${FNAME}"
      exit 1
    fi
  done
done

for FOLDER in series; do
  find "${FOLDER}" -type f | grep -E '.md$' | while read -r FNAME; do
    if antenna page "${FNAME}"; then
      printf "OK, generated page ${FNAME}\n"
    else
      printf "Problem with page %s\n" "${FNAME}"
      exit 1
    fi
  done
done	

for FNAME in blog/index.md blog/recent.md cv.md library-terminology.md mars-2020.md moon-2026.md presentations.md resume.md search.md; do
  if antenna page "${FNAME}"; then
    printf "OK, generated page ${FNAME}\n"
  else
    printf "Problem with page %s\n" "${FNAME}"
    exit 1
  fi
done


# Find other pages
antenna pages pages.md | while read -r LINE; do
  if [ "$LINE" != "" ]; then
    INAME=$(echo "${LINE}" | cut -f 1)
    ONAME=$(echo "${LINE}" | cut -f 2)
    printf "md: %s html: %s\n" "${INAME}" "${ONAME}"
  fi
done
