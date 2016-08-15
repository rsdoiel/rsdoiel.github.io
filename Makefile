
all: index.html about.html cv.html resume.html library-terminology.html blog/index.html presentations.html

index.html: nav.md footer.md author.md blog/index.md presentations.md cli-tools.md index.tmpl
	mkpage "blogPosts=blog/index.md" "presentations=presentations.md" "cliTools=cli-tools.md" "aboutAuthor=author.md" "nav=nav.md" "footer=footer.md" index.tmpl > index.html


presentations.html: presentations.md footer.md nav.md presentations.tmpl
	mkpage "presentations=presentations.md" "nav=nav.md" "footer=footer.md" presentations.tmpl > presentations.html

about.html: nav.md footer.md author.md bio.md about.tmpl
	mkpage "aboutAuthor=author.md" "pageContent=bio.md" "nav=nav.md" "footer=footer.md" about.tmpl > about.html

cv.html: nav.md footer.md cv.md cv.tmpl
	mkpage "pageContent=cv.md" "nav=nav.md" "footer=footer.md" cv.tmpl > cv.html

resume.html: nav.md footer.md resume.md resume.tmpl
	mkpage "pageContent=resume.md" "nav=nav.md" "footer=footer.md" resume.tmpl > resume.html

library-terminology.html: nav.md footer.md library-terminology.md library-terminology.tmpl
	mkpage "pageContent=library-terminology.md" "nav=nav.md" "footer=footer.md" library-terminology.tmpl > library-terminology.html

blog:
	./blog.bash

blog/index.html: nav.md blog/index.md blog/nav.md blog/index.tmpl blog/post.tmpl
	./blog.bash

save:
	git commit -am "Quick Save"
	git push origin master

publish:
	./blog.bash
	./make-sitemap.bash > sitemap.xml
	./make-rss.bash blog > rss.xml
	git commit -am "save and publish"
	git push origin master
