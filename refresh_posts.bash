#!/bin/bash

for YEAR in 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025; do
  find "blog/${YEAR}" -type f | grep -E '.md$' | while read -r FNAME;do
    if antenna post pages.md "${FNAME}"; then
      printf "OK, ${FNAME}\n"
    else
      printf "Problem with post ${FNAME}\n"
      exit 1
    fi
  done
done
