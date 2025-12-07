#
# Make file for building website
#
TODAY = $(shell date "+%Y-%m-%d")

YEARS = 2025,2024,2023,2022,2021,2020,2019,2018,2017,2016

TITLE = R. S. Doiel Software Engineer/Analyst

PANDOC=pandoc -f markdown -t html5 -B nav.include -A footer.include --lua-filter=links-to-html.lua --lua-filter=link-h2-anchor.lua

all: blog api redirects nav.include footer.include about.html cv.html resume.html library-terminology.html presentations.html rssfeed.html project-index.html series series/index.html projects.html quiddler-scoreboard.html search.html index.html archive.xml index.xml pagefind


nav.include: nav.md .FORCE
	pandoc --from=markdown --to=html5 --lua-filter=links-to-html.lua nav.md > nav.include

footer.include: footer.md
	pandoc --from=markdown --to=html5 --lua-filter=links-to-html.lua footer.md > footer.include

index.html: .FORCE
	antenna page index.txt index.html
	git add index.html

presentations.html: presentations.md footer.include nav.include page.tmpl
	$(PANDOC) --template page.tmpl presentations.md > presentations.html
	git add presentations.html

projects.html: projects.md
	antenna page projects.md projects.html
	git add projects.html

about.html: bio.md
	antenna page bio.md about.html
	git add about.html

search.html: search.md
	antenna page search.md search.html
	git add search.html

pagefind: .FORCE
	if [ -d pagefind ]; then rm -fR pagefind; fi
	pagefind --verbose --exclude-selectors="nav,header,footer" --output-path ./pagefind --site .
	git add pagefind

cv.html: cv.md
	antenna page cv.md cv.html
	git add cv.html

resume.html: resume.md
	antenna page resume.md resume.html
	git add resume.html

project-index.html: project-index.md
	antenna page project-index.md project-index.html
	git add project-index.html

library-terminology.html: library-terminology.md
	antenna page library-terminology.md library-terminology.html
	git add library-terminology.html

series: series/index.html series/deno-and-typescript.html series/mostly-oberon.html series/software-tools.html series/pandoc-techniques.html series/freedos.html series/sql-reflections.html series/pse.html series/books.html

series/index.html: series/index.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/index.md
	antenna page series/index.md series/index.html
	git add series/index.html

series/deno-and-typescript.html: series/deno-and-typescript.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/deno-and-typescript.md
	antenna page series/deno-and-typescript.md series/deno-and-typescript.html
	git add series/deno-and-typescript.html
	
series/mostly-oberon.html: series/mostly-oberon.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/mostly-oberon.md
	antenna page series/mostly-oberon.md series/mostly-oberon.html
	git add series/mostly-oberon.html

series/software-tools.html: series/software-tools.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/software-tools.md
	antenna page series/software-tools.md series/software-tools.html
	git add series/software-tools.html

series/pandoc-techniques.html: series/pandoc-techniques.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/pandoc-techniques.md
	antenna page series/pandoc-techniques.md series/pandoc-techniques.html
	git add series/pandoc-techniques.html

series/freedos.html: series/freedos.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/freedos.md
	antenna page series/freedos.md series/freedos.html
	git add series/freedos.html

series/sql-reflections.html: series/sql-reflections.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/sql-reflections.md
	antenna page series/sql-reflections.md series/sql-reflections.html
	git add series/sql-reflections.html

series/pse.html: series/pse.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/pse.md
	antenna page series/pse.md series/pse.html
	git add series/pse.html

series/books.html: series/books.md
	sed --in-place -E 's/\.md\)/.html\)/g' series/books.md
	antenna page series/books.md series/books.html
	git add series/books.html

redirects: .FORCE
	bash generate-redirect-pages.bash

rss.xml: .FORCE
	antenna generate blog.md
	cp -v blog.xml index.xml
	cp -v blog.xml rss.xml

#FIXME: I need to generate the archive XML for the blog via antenna. To do that
# I need to implement an RSS feed output like the pages action for blog posts.
#
# archive.xml: .FORCE
# 	pttk rss -channel-title="R. S. Doiel Blog" \
# 		-atom-link="https://rsdoiel.github.io/rss.xml" \
# 		-base-url="https://rsdoiel.github.io" \
#         -channel-description="All posts from Robert's ramblings and wonderigs" \
#         -channel-link="https://rsdoiel.github.io/blog" blog >archive.xml

# NOTE: Need to add current year after the first post of the year.
blog: .FORCE
	bash blog.bash
	git add blog/index.html
	git add blog/blog.json

api: .FORCE
	-flatlake --source . --dest api

rssfeed.html: rssfeed.md
	antenna page rssfeed.md rssfeed.html
	git add rssfeed.html


blog.zip: .FORCE
	-rm blog.zip >/dev/null 2>&1
	-zip -r blog.zip *.md *.html twtxt.txt
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
	@if [ -f index.md ]; then rm index.md; fi

.FORCE:
