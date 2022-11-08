#!bash

find . -type d | while read DNAME; do
	chmod 755 "${DNAME}";
done
find . -type f | while read FNAME; do
	chmod 644 "${FNAME}";
done
