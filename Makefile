
TODAY = $(shell date "+%Y-%m-%d")
#
# Make file for building website
#
all: index.html about.html cv.html resume.html library-terminology.html presentations.html blog blog/index.html rssfeed.html series

index.html: nav.md footer.md author.md blog/index.md presentations.md cli-tools.md series.md index.tmpl
	mkpage "blogPosts=blog/index.md" "presentations=presentations.md" "cliTools=cli-tools.md" "series=series.md" "about-author=author.md" "nav=nav.md" "footer=footer.md" index.tmpl > index.html
	git add index.html


presentations.html: presentations.md footer.md nav.md presentations.tmpl
	mkpage "mdfile=text:presentations.md" "presentations=presentations.md" "nav=nav.md" "footer=footer.md" presentations.tmpl > presentations.html
	git add presentations.html

about.html: nav.md footer.md author.md bio.md about.tmpl
	mkpage "mdfile=text:bio.md" "about-author=author.md" "content=bio.md" "nav=nav.md" "footer=footer.md" about.tmpl > about.html
	git add about.html

cv.html: nav.md footer.md cv.md cv.tmpl
	mkpage "mdfile=text:cv.md" "content=cv.md" "nav=nav.md" "footer=footer.md" cv.tmpl > cv.html
	git add cv.html

resume.html: nav.md footer.md resume.md resume.tmpl
	mkpage "mdfile=text:resume.md" "content=resume.md" "nav=nav.md" "footer=footer.md" resume.tmpl > resume.html
	git add resume.html


library-terminology.html: nav.md footer.md library-terminology.md library-terminology.tmpl
	mkpage "mdfile=text:library-terminology.md" "content=library-terminology.md" "nav=nav.md" "footer=footer.md" library-terminology.tmpl > library-terminology.html
	git add library-terminology.html

series.html: nav.md series.md page.tmpl

series: series/index.html series/mostly-oberon.html series/software-tools.html series/pandoc-techniques.html
	git add series/index.html

series/index.html: series/index.md
	mkpage "title=text:Series" "content=series/index.md" "nav=nav.md" page.tmpl > series/index.html
	git add series/index.html

series/mostly-oberon.html: series/mostly-oberon.md
	mkpage "title=text:Mostly Oberon Series" "content=series/mostly-oberon.md" "nav=nav.md" page.tmpl > series/mostly-oberon.html
	git add series/mostly-oberon.html

series/software-tools.html: series/software-tools.md
	mkpage "title=text:Software Tools Series" "content=series/software-tools.md" "nav=nav.md" page.tmpl > series/software-tools.html
	git add series/software-tools.html

series/pandoc-techniques.html: series/pandoc-techniques.md
	mkpage "title=text:Pandoc Techniques Series" "content=series/pandoc-techniques.md" "nav=nav.md" page.tmpl > series/pandoc-techniques.html
	git add series/pandoc-techniques.html

blog: blog/index.html
	git add blog/index.html

blog/index.html:
	bash blog.bash

rssfeed.html: rssfeed.md
	mkpage "mdfile=text:rssfeed.md" "content=rssfeed.md" "nav=nav.md" "footer=footer.md" about.tmpl > rssfeed.html
	git add rssfeed.html

status:
	git status

save:
	git commit -am "Quick Save"
	git push origin main

website: all .FORCE
	bash blog.bash
	mkrss -channel-title="R. S. Doiel" \
	    -channel-description="Robert's ramblings and wonderigs" \
	  -channel-pubdate="$(TODAY)" \
	  -channel-link="https://rsdoiel.github.io/blog" \
	  blog rss.xml 
	sitemapper . sitemap.xml https://rsdoiel.github.io

publish: all
	bash blog.bash
	mkrss -channel-title="R. S. Doiel" \
	   	  -channel-description="Robert's ramblings and wonderigs" \
		  -channel-link="https://rsdoiel.github.io/blog" \
		  blog rss.xml 
	sitemapper . sitemap.xml https://rsdoiel.github.io
	git commit -am "save and publish"
	git push origin main

# Clean now breaks the blog as I have examples and other docs that should
# note be removed (e.g. Pandoc-Partials examples index?.html files).
#clean:
#	rm $(shell findfile -s .html)

.FORCE:
