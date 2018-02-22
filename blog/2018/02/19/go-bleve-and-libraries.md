
# Go, Bleve and Library oriented software

By R. S. Doiel, 2018-02-19
(updated: 2018-02-20)

In 2016, Stephen Davison, asked me, "Why use Go and Blevesearch for
our library projects?" After our conversation I wrote up some notes so
I would remember. It is now 2018 and I am revising these notes. I
think our choice paid off.  What follows is the current state of my
reflection on the background, rational, concerns, and risk mitigation
strategies so far for using [Go](https://golang.org) and
[Blevesearch](https://blevesearch.com) for Caltech Library projects.

## Background

I first came across Go a few years back when it was announced as an
Open Source project by Google at an Google I/O event (2012). The
original Go authors were Robert Griesemer, Rob Pike, and Ken
Thompson. What I remember from that presentation was Go was a rather
consistent language with the features you need but little else.  Go
developed at Google as a response to high development costs for C/C++
and Java in addition to challenges with performance and slow
compilation times.  As a language I would put Go between C/C++ and
Java. It comes the ease of writing and reading you find in languages
like Python. Syntax is firmly in the C/C++ family but heavily
simplified. Like Java it provides many modern features including rich basic
data structures and garbage collection. It has a very complete standard
library and provides very good tooling.  This makes it easy to
generate code level documentation, format code, test, efficiently profile, 
and debug.

Often programming languages develop around a specific set of needs.
This is true for Go. Given the Google origin it should not be
surprising to find that Go's primary strengths are working with 
structured data, I/O and concurrency. The rich standard
library is organized around a package concept. These include packages
supporting network protocols, file and socket I/O as well as various
encoding and compression scheme. It has particularly strong support
for XML, JSON, CSV formatted data out of the box. It has a template
library for working with plain text formats as well as generating safe
HTML. You can browse Go's standard library https://golang.org/pkg/.

An additional feature is Go's consistency. Go code that compiles under
version 1.0 still compiles under 1.10. Even before 1.0 code changes
that were breaking came with tooling to automatically updates existing
code.  Running code is a strong element of Go's evolution.

Go is unsurprising and has even been called boring.  This turns out to
be a strength when building sustainable projects in a small team.


## Why do I write Go?

For me Go is a good way to write web services, assemble websites,
create search appliances and write command line (cli) utilities. When
a shell script becomes unwieldy Go is often what I turn to.  Go is
well suited to building tools as well as systems.  Go based command
line tools are very easy to orchestrate with shell and Python.

Go runs on all the platforms I actively use - Windows, Mac OS X, Linux
on both Intel and ARM (e.g. Raspberry Pi, Pine64). It has experimental
support for Android and iOS.  I've used a tool called
[GopherJS](http://gopherjs.org) to write web browser applications that
transform my command line tools into web tools with a friendlier user
interface (see our [BibTeX Tools](https://caltechlibrary.github.io/bibtex/webapp/)).

Go supports cross compiling out of the box. This means a production
system running on AWS, Google's compute engine or Microsoft's Azure
can be compiled from Windows, Mac OS or even a Raspberry Pi!
Deployment is a matter of copying the (self contained) compiled binary
onto the production system. This contrasts with other
platforms like Perl, PHP, Python, NodeJS and Ruby where you need to
install not only your application code but all dependencies. While
interpretive languages retain an advantage of having a REPL, Go
based programs have advantages of fast compile times and easy deployment.

In many of the projects I've written in Go I've only required a few
(if any) 3rd party libraries (packages in Go's nomenclature). This is
quite a bit different from my experience with Perl, PHP, Python,
NodeJS and Ruby. This is in large part a legacy of having grown up at
Google before become an open source project. While the Go standard
packages are very good there is a rich ecosystem for 3rd party
packages for specialized needs. I've found I tend to rely only on a
few of them. The one I've used the most is
[Bleve](http://blevesearch.com).

Bleve is a Go package for building search engines. When I originally
came across Bleve (around 2014), it was described as "Lucene lite". 
"Lucene lite" was an apt description, but I find it easier
to use than Lucene. When I first used Bleve I embedded its
functionality into the tools I used to process data and present web
services. It did not have much in the way of stand alone command line
tooling.  Today I increasingly think of Bleve as "Elastic Search
lite". It ships with a set of command line tools that include support
for building Bleve's indexes.  My current practice is to only embed the search
portion of the packages. I can use the Bleve command line for the
rest.  In 2018, Bleve is being actively developed, has a small vibrant
community and is used by [Couchbase](https://couchbase.com), a well
established NoSQL player.


## Who is using Go?

Many companies use Go. The short list includes
Google, Amazon, Netflix, Dropbox, Box, eBay, Pearsons and even
Walmart and Microsoft. This came to my attention at developer conferences
back in 2014.  People from many of these companies started
presenting at conferences on pilot projects that had been successful
and moved to production. Part of what drove adoption was the ease
of development in Go along with good system performance. I also think
there was a growing disenchantment with alternatives like C++, C sharp
and Java as well as the weight of the LAMP, Tomcat, and OpenStack.

Highly visible Go based projects include

+ [Docker](http://docker.org) and [Rocket](http://www.docker.com) - Containerization for running process in the cloud
+ [Kubernettes](http://kubernetes.io/) and [Terraform](https://www.terraform.io/) - Container orchestration systems
+ [Hugo](http://hugo.io) - the fast/popular static website generator, an alternative to Jekyll, for those who want speed
+ [Caddy](https://caddyserver.com/) - a Go based web server trying to unseat Apache/NGinX focusing on easy of use plus speed
+ [IPFS](http://ipfs.io) - a cutting edge distributed storage system based on block chains


### Who is using Blevesearch?

Here's some larger projects using Bleve.

+ [Couchbase](http://www.couchbase.com), a NoSQL database platform are replacing Lucene with Bleve.  Currently the creator of Bleve works for them.
+ [Hugo](http://hugo.io) can integrate with Bleve for search and index generation
+ [Caddy](https://caddyserver.com/) integrates with Bleve to provide an embedded search capability


## Managing risks

In 2014 Go was moving from bleeding to leading edge. Serious capital
was behind its adoption and it stopped being an exotic conference
item. In 2014 Bleve was definitely bleeding edge. By late 2015 and early
2016 the program level API stabilized. People were piloting projects
with it. This included our small group at Caltech Library. In 2015
non-English language support appeard followed by a growing list
of non-European languages in 2016. By mid 2016 we started to see 
missing features like alternative sorting added. While Bleve isn't
yet 1.0 (Feb. 2018) it is reliable. The primary challenge for the Bleve
project is documentation targeting the novice and non-Programmer users.
Bleve has proven effective as an indexing and search platform for 
archival, library, and data repository content.

Adopting new software comes with risk. We have mitigated this in two ways.

1. Identify alternative technology (a plan B)
2. Architect our systems for easy decomposition and re-composition

In the case of Go, packages can be compiled to a C-Shared
library. This allows us to share working Go packages with languages
like Python, R, and PHP. We have included shared Go/Python modules
on our current road map for projects.

For Blevesearch the two alternatives are Solr and Elastic
Search. Both are well known, documented, and solid.  The costs would be
recommitting to a Java stack and its resource requirements. We have
already identified what we want to index and that could be converted
to either platform if needed.  If we stick with Go but dropped 
Blevesearch we would swap out the Bleve specific code for Go packages 
supporting Solr and Elastic Search.


The greatest risk in adopting Go for library and archive projects was 
knowledge transfer. We addressed this 
by knowledge sharing and insuring the Go codebase can 
be used via command line programs.  Additionaly 
we are adding support for Go based Python modules.
Training also is available in the form of books, websites and
online courses ([lynda.com](https://www.lynda.com/Go-tutorials/Up-Running-Go/412378-2.html) offers a "Up Running Go" course).


## What are the benefits?

For library and archives software we have found Go's benefits include
improved back end systems performance at a lower cost, ease of development, 
ease of deployment, a rich standard library focused on the types of things 
needed in library and archival software.  Go plays nice with
other systems (e.g. I create an API based service in Go that can easily
be consumed by a web browser running JavaScript or Perl/PHP/Python
code running under LAMP). In the library and archives setting Go 
can become a high performance duck tape. We get the performance and 
reliability of C/Java type systems with code simplicity 
similar to Python.
