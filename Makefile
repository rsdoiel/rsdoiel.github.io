
all: index.html about.html cv.html resume.html library-terminology.html blog/index.html

index.html: author.md blog/index.md index.shorthand
	shorthand index.shorthand > index.html

about.html: author.md bio.md about.shorthand
	shorthand about.shorthand > about.html

cv.html: cv.md cv.shorthand
	shorthand cv.shorthand > cv.html

resume.html: resume.md resume.shorthand
	shorthand resume.shorthand > resume.html

library-terminology.html: library-terminology.md library-terminology.shorthand
	shorthand library-terminology.shorthand > library-terminology.html

blog/index.html: blog/index.md blog/nav.md blog/index.shorthand blog/post.shorthand
	./blog.sh

publish:
	./make-sitemap.sh > sitemap.xml
	./make-rss.sh blog > rss.xml
	git commit -am "save and publish"
	git push origin master
