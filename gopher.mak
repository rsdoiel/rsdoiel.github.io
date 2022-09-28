#
# Make file for building gophermaps for a Gopher burrow
#
TODAY = $(shell date "+%Y-%m-%d")

TITLE = R. S. Doiel Software Engineer/Analyst

HOST = localhost

PORT = 7000

all: blog/gophermap gophermap

blog/gophermap:
    echo "FIXME: build blog/gophermap"

gophermap:
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

# Clean now breaks the blog as I have examples and other docs that should
# note be removed (e.g. Pandoc-Partials examples index?.html files).
clean:
	@for FNAME in $(shell findfile -s gophermap); do if [ -f $$FNAME ] then rm $$FNAME; fi; done

.FORCE:
