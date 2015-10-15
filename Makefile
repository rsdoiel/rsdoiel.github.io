
all: index.html cv.html resume.html library-terminology.html

index.html: bio.md index.shorthand
	shorthand index.shorthand > index.html

cv.html: cv.md cv.shorthand
	shorthand cv.shorthand > cv.html

resume.html: resume.md resume.shorthand
	shorthand resume.shorthand > resume.html

library-terminology.html: library-terminology.md library-terminology.shorthand
	shorthand library-terminology.shorthand > library-terminology.html