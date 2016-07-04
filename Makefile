
all: index.html about.html cv.html resume.html library-terminology.html blog/index.html

index.html: nav.md footer.md author.md blog/index.md index.shorthand
	shorthand index.shorthand > index.html

about.html: nav.md footer.md author.md bio.md about.shorthand
	shorthand about.shorthand > about.html

cv.html: nav.md footer.md cv.md cv.shorthand
	shorthand cv.shorthand > cv.html

resume.html: nav.md footer.md resume.md resume.shorthand
	shorthand resume.shorthand > resume.html

library-terminology.html: nav.md footer.md library-terminology.md library-terminology.shorthand
	shorthand library-terminology.shorthand > library-terminology.html

blog/index.html: nav.md blog/index.md blog/nav.md blog/index.shorthand blog/post.shorthand
	./blog.sh

publish:
	./blog.sh
	./make-sitemap.sh > sitemap.xml
	./make-rss.sh blog > rss.xml
	git commit -am "save and publish"
	git push origin master
