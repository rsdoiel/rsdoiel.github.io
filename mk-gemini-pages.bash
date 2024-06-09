#!/bin/bash

if [ -f "pyvenv.cfg" ]; then
   export PATH="./bin:$PATH"
fi


find . -type f | grep -E '\.md$' | while read -r FNAME; do
    printf "Coverting %s\n" "${FNAME}"
	DNAME=$(dirname "${FNAME}")
    if ! python3 -m md2gemini -m -w -d "${DNAME}" -f -i tab --plain -l paragraph \
        -b gemini://sdf.org/rsdoiel/ \
        "${FNAME}"; then
	cat <<EOT
 Can't find md2gemini. Try installing with pip

 	python3 -m pip install md2gemini

EOT
	exit 1
    fi
done

find . -type f | grep -E '\.gmi' | while read -r FNAME; do
	git add "${FNAME}"
done
