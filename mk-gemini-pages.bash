#!/bin/bash

find . -type f | grep -E '\.md$' | while read -r FNAME; do
    printf "Coverting %s\n" "${FNAME}"
    md2gemini -w -m -f -i tab --plain -l at-end \
        -b gemini://sdf.org/rsdoiel/ \
        "${FNAME}"
done

find . -type f | grep -E '\.gmi' | while read -r FNAME; do
	git add "${FNAME}"
done
