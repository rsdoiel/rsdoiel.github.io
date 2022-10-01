#
# Make file for building gophermaps for a Gopher burrow
#
TODAY = $(shell date "+%Y-%m-%d")

TITLE = R. S. Doiel Software Engineer/Analyst

HOST = localhost

PORT = 7000

all: blog/gophermap gophermap

blog/gophermap: phlog.json
    echo "FIXME: build blog/gophermap"

gophermap: *.md
    echo "FIXME: build site gophermap"

status:
	git status

save:
	git commit -am "Quick Save"
	git push origin main

publish: all
	@for FNAME in $(shell findfile -s gophermap); do if [ -f $$FNAME ] then git add $$FNAME; fi; done
	git commit -am "save and publish"
	git push origin main

.FORCE:
