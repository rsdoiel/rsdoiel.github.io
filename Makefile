#
# Make file for building website
#
TODAY = $(shell date "+%Y-%m-%d")

YEARS = 2025,2024,2023,2022,2021,2020,2019,2018,2017,2016

TITLE = R. S. Doiel Software Engineer/Analyst

all: blog api redirects about.html cv.html resume.html library-terminology.html presentations.html rssfeed.html project-index.html series series/index.html projects.html quiddler-scoreboard.html search.html index.html archive.xml index.xml pagefind


index.html: index.md
	antenna page index.md
	git add index.html

presentations.html: presentations.md
	antenna page presentations.md
	git add presentations.html

projects.html: projects.md
	antenna page projects.md
	git add projects.html

about.html: bio.md
	antenna page bio.md
	mv bio.html about.html
	git add about.html

search.html: search.md
	antenna page search.md
	git add search.html

pagefind: .FORCE
	pagefind --verbose --exclude-selectors="nav,header,footer" --output-path ./pagefind --site .
	git add pagefind

cv.html: cv.md
	antenna page cv.md
	git add cv.html

resume.html: resume.md
	antenna page resume.md
	git add resume.html

project-index.html: project-index.md
	antenna page project-index.md
	git add project-index.html

library-terminology.html: library-terminology.md
	antenna page library-terminology.md
	git add library-terminology.html

series: .FORCE
	antenna page series/index.md
	git add series/index.html
	antenna page series/deno-and-typescript.md
	git add series/deno-and-typescript.html
	antenna page series/mostly-oberon.md
	git add series/mostly-oberon.html
	antenna page series/software-tools.md
	git add series/software-tools.html
	antenna page series/pandoc-techniques.md
	git add series/pandoc-techniques.html
	antenna page series/freedos.md
	git add series/freedos.html
	antenna page series/sql-reflections.md
	git add series/sql-reflections.html
	antenna page series/pse.md
	git add series/pse.html
	antenna page series/books.md
	git add series/books.html

redirects: .FORCE
	bash generate-redirect-pages.bash

rss.xml: .FORCE
	antenna generate blog.md
	antenna generate archive.md
	cp -v blog.xml index.xml
	cp -v blog.xml rss.xml

archive.xml: .FORCE
	pttk rss -channel-title="R. S. Doiel Blog" \
		-atom-link="https://rsdoiel.github.io/rss.xml" \
		-base-url="https://rsdoiel.github.io" \
        -channel-description="All posts from Robert's ramblings and wonderigs" \
        -channel-link="https://rsdoiel.github.io/blog" blog >archive.xml

# NOTE: Need to add current year after the first post of the year.
blog: .FORCE
	bash blog.bash
	git add blog/index.html
	git add blog/blog.json

api: .FORCE
	-flatlake --source . --dest api

rssfeed.html: rssfeed.md
	antenna page rssfeed.md
	git add rssfeed.html


blog.zip: .FORCE
	-rm blog.zip >/dev/null 2>&1
	-zip -r blog.zip *.md *.html
	-zip -r blog.zip $(find blog -type f)
	-zip -r blog.zip $(find series -type f)

status:
	-git status

refresh:
	-git fetch origin
	-git pull origin main
save:
	-git commit -am "Quick Save"
	-git push origin main

# NOTE: this is just here for muscle memory, "all" builds the website and blog quickly with antenna and Pandoc
website: all .FORCE

#sitemap.xml: .FORCE
#	sitemapper . sitemap.xml https://rsdoiel.github.io

publish: rss.xml all
	bash blog.bash
	git commit -am "save and publish"
	git push origin main

# Clean now breaks the blog as I have examples and other docs that should
# note be removed (e.g. Pandoc-Partials examples index?.html files).
clean:
	@for FNAME in $(shell findfile -s .html); do if [ -f $$FNAME ] && [ $$FNAME != "quiddler-scoreboard.html" ]; then rm $$FNAME; fi; done
	@if [ -f nav.include ]; then rm nav.include; fi
	@if [ -f footer.include ]; then rm footer.include; fi
	@if [ -f index.txt ]; then rm index.txt; fi

.FORCE:
