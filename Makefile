#
# Make file for building website
#
TODAY = $(shell date "+%Y-%m-%d")

YEARS = 2025,2024,2023,2022,2021,2020,2019,2018,2017,2016

TITLE = R. S. Doiel Software Engineer/Analyst

PANDOC=pandoc -B nav.include -A footer.include --lua-filter=links-to-html.lua

all: blog api redirects nav.include footer.include about.html cv.html resume.html library-terminology.html presentations.html rssfeed.html project-index.html series series/index.html projects.html quiddler-scoreboard.html search.html index.html rss.xml sitemap.xml pagefind


nav.include: nav.md .FORCE
	pandoc --from=markdown --to=html5 --lua-filter=links-to-html.lua nav.md > nav.include

footer.include: footer.md
	pandoc --from=markdown --to=html5 --lua-filter=links-to-html.lua footer.md > footer.include

index.md: index.txt blog/index.md presentations.md projects.md cli-tools.md
	pttk include index.txt >index.md

index.html: nav.include footer.include index.md page.tmpl
	$(PANDOC) --template index.tmpl index.md > index.html
	git add index.html

reading_list: .FORCE
	pandoc --metadata title="Readings from the web" --from=markdown --to=html5 --template page.tmpl reading_list.md > reading_list.html

presentations.html: presentations.md footer.include nav.include page.tmpl
	$(PANDOC) --template page.tmpl presentations.md > presentations.html
	git add presentations.html

projects.html: projects.md
	$(PANDOC) --template page.tmpl projects.md > projects.html
	git add projects.html

about.html: nav.include footer.include author.md bio.md index.tmpl
	$(PANDOC) --template page.tmpl author.md bio.md > about.html
	git add about.html

search.html: nav.include footer.include search.md search.tmpl
	$(PANDOC) --template search.tmpl search.md > search.html
	git add search.html

pagefind: .FORCE
	pagefind --verbose --exclude-selectors="nav,header,footer" --output-path ./pagefind --site .
	git add pagefind

cv.html: nav.include footer.include cv.md page.tmpl
	$(PANDOC) --template page.tmpl cv.md > cv.html
	git add cv.html

resume.html: nav.include footer.include resume.md page.tmpl
	$(PANDOC) --template page.tmpl resume.md > resume.html
	git add resume.html

project-index.html: nav.include footer.include project-index.md page.tmpl
	$(PANDOC) --template page.tmpl project-index.md > project-index.html
	git add project-index.html

library-terminology.html: nav.include footer.include library-terminology.md index.tmpl
	$(PANDOC) --template index.tmpl library-terminology.md > library-terminology.html
	git add library-terminology.html

series: series/index.html series/mostly-oberon.html series/software-tools.html series/pandoc-techniques.html series/freedos.html series/sql-reflections.html series/pse.html

series/index.html: nav.include footer.include series/index.md
	$(PANDOC) -M "title:Article Series" --template page.tmpl series/index.md > series/index.html
	git add series/index.html

series/mostly-oberon.html: nav.include footer.include series/mostly-oberon.md
	$(PANDOC) --template page.tmpl -M "title:Mostly Oberon Series" series/mostly-oberon.md > series/mostly-oberon.html
	git add series/mostly-oberon.html

series/software-tools.html: nav.include footer.include series/software-tools.md
	$(PANDOC) --template page.tmpl -M "title:Software Tools Series" series/software-tools.md > series/software-tools.html
	git add series/software-tools.html

series/pandoc-techniques.html: series/pandoc-techniques.md
	$(PANDOC) --template page.tmpl -M "title:Pandoc Techniques Series" series/pandoc-techniques.md > series/pandoc-techniques.html
	git add series/pandoc-techniques.html

series/freedos.html: series/freedos.md
	$(PANDOC) --template page.tmpl -M "title:Exploring FreeDOS" series/freedos.md > series/freedos.html
	git add series/freedos.html

series/sql-reflections.html: series/sql-reflections.md
	$(PANDOC) --template page.tmpl -M "title:SQL Reflections" series/sql-reflections.md >series/sql-reflections.html
	git add series/sql-reflections.html

series/pse.html: series/pse.md
	$(PANDOC) --template page.tmpl -M "title:A Personal Search Engine" series/pse.md > series/pse.html
	git add series/pse.html

redirects: .FORCE
	bash generate-redirect-pages.bash

rss.xml: .FORCE
	pttk rss -channel-title="R. S. Doiel Blog" \
		-atom-link="https://rsdoiel.github.io/rss.xml" \
		-base-url="https://rsdoiel.github.io" \
        -channel-description="Robert's ramblings and wonderigs" \
        -channel-link="https://rsdoiel.github.io/blog" blog >rss.xml
	pttk rss -channel-title="R. S. Doiel Website" \
		-atom-link="https://rsdoiel.github.io/index.xml" \
		-base-url="https://rsdoiel.github.io" \
        -channel-description="Robert's Website" \
        -channel-link="https://rsdoiel.github.io" . >index.xml

# NOTE: Need to add current year after the first post of the year.
blog: .FORCE
	pttk blogit -prefix=blog -refresh=$(YEARS)
	bash blog.bash
	git add blog/index.html
	git add blog/blog.json

api: .FORCE
	-flatlake
	git add api

rssfeed.html: nav.include footer.include rssfeed.md
	$(PANDOC) --template index.tmpl author.md rssfeed.md > rssfeed.html
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

# NOTE: this is just here for muscle memory, "all" builds the website and blog quickly with pttk
website: all .FORCE

sitemap.xml: .FORCE
	sitemapper . sitemap.xml https://rsdoiel.github.io

publish: rss.xml sitemap.xml all
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
