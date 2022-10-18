#
# Make file for building gophermaps for a Gopher burrow
#
TODAY = $(shell date "+%Y-%m-%d")

TITLE = R. S. Doiel Software Engineer/Analyst

HOST = localhost

PORT = 7000

YEARS="2022,2021,2020,2019,2018,2017,2016"

MARKDOWN_FILES = $(shell find . -type f | grep -E '\.md$' | grep -v 'nav.md')

all: blog/gophermap gophermap

blog/gophermap: blog/phlog.json

blog/phlog.json: blog/_masthead
	pttk phlogit -prefix=blog -refresh="$(YEARS)" -masthead=blog_masthead

blog_masthead: .FORCE
	touch blog_masthead

gophermap: site_masthead $(MARKDOWN_FILES)
	pttk gophermap -refresh="$(MARKDOWN_FILES)" -masthead=site_masthead

site_masthead: .FORCE
	touch site_masthead

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
