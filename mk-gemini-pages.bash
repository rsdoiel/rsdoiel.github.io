#!/bin/bash

find . -type f | grep -E '\.md$' | while read -r FNAME; do
    printf "Coverting %s\n" "${FNAME}"
	DNAME=$(dirname "${FNAME}")
    md2gemini -m -w -d "${DNAME}" -f -i tab --plain -l paragraph \
        -b gemini://sdf.org/rsdoiel/ \
        "${FNAME}"
done

find . -type f | grep -E '\.gmi' | while read -r FNAME; do
	git add "${FNAME}"
done
