
# Go, Bleve and library oriented software

By R. S. Doiel, 2018-02-19

In 2016, Stephen Davison, asked me, "Why use Go and Blevesearch for
our library projects?" After our conversation I wrote up some notes so
I would remember. It is now 2018 and I am revising these notes. I
think our choice payed off.  What follows is the current state of my
reflection on the background, rational, concerns, and risk mitigation
strategies so far at Caltech Library for [Go](https://golang.org) and
[Blevesearch](https://blevesearch.com) based projects.

## Background

I first came across Go a few years back when it was announced as an
Open Source project by Google at an Google I/O event (2012). The
original Go authors were Robert Griesemer, Rob Pike, and Ken
Thompson. What I remember from that presentation was Go is a rather
consistent language with the features you need but little else.  Go
developed at Google as a response to high development costs for C/C++
and Java in addition to challenges with performance and slow
compilation times.  As a language I would put Go between C/C++ and
Java. It comes the ease of writing and reading you find in languages
like Python. Syntax is firmly in the C/C++ family but heavily
simplified. Like Java it provides many modern features - rich basic
data structures, garbage collection. It has a very complete standard
library.  It also provides very good tooling making it easy to
generate code level documentation, formatting code, testing as well as
efficient profiling, and debugging.

Often programming languages develop around a specific set of needs.
This is true for Go. Given the Google origin it should not be
surprising to find that working with structured data , I/O and
concurrency are some of Go's primary strengths. The rich standard
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
interface (see the [BibTeX](https://caltechlibrary.github.io/bibtex).

Go supports cross compiling out of the box. This means a production
system running on AWS, Google's compute engine or Microsoft's Azure
can be compiled from Windows, Mac OS or even a Raspberry Pi!
Deployment is a matter of copying the compiled binary (it is self
contained) onto the production system. This contrasts with other
platforms like Perl, PHP, Python, NodeJS and Ruby where you need to
install not only your application code but all dependencies. While
interpretive languages retain an advantage of having a REPL the fast
compile times and easy of deployment gives Go based programs
advantages too.

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
came across Bleve, it was described as "Lucene lite". I think that was
in about 2014. "Lucene lite" was an apt description. I find it easier
to use than Lucene. When I first used Bleve I embedded its
functionality into the tools I used to process data and present web
services. It did not have much in the way of stand alone command line
tooling.  Today I increasingly think of Bleve as "Elastic Search
lite". It ships with a set of command line tools that include support
for building Bleve's indexes.  Today generally I only embed the search
portion of the packages. I can use the Bleve command line for the
rest.  In 2018, Bleve is being actively developed, has a small vibrant
community and is used by [Couchbase](https://couchbase.com), a well
established NoSQL player.


## Who is using Go?

The companies use Go for various systems and network services,
e.g. Google, Amazon, Netflix, Dropbox, Box, eBay, Pearsons and even
Walmart and Microsoft. I first noticed this trend back in 2014 at
developer conferences. People from many of these companies started
presenting at conferences on pilot projects that had been successful
and had moved to production. Part of what drove adoption was the ease
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

Here's some larger projects using Bleve (notice the overlap).

+ [Couchbase](http://www.couchbase.com), a NoSQL database platform are replacing Lucene with Bleve, currently the creator of Bleve works for them.
generating complex static websites. The Hugo project also powers' their website search with Bleve in addition to integrating with it.
+ [Hugo](http://hugo.io) can integrate with Bleve for search and index generation
+ [Caddy](https://caddyserver.com/) integrates with Bleve to provide an embedded search capability

There isn't a central registry of projects using Bleve and since
Blevesearch really got off the ground in 2013/2014 it is too early to
see a large number conference presentations though you'll find
smattering of them along with introductory articles with the search
string "Blevesearch". That said our initial pilot usage in the
archives website has proved effective.

## Managing risks

In 2014 Go was moving from bleeding to leading edge. Serious capital
was behind its adoption and it stopped being an exotic conference
item. 2014 Bleve was definitely bleeding edge. By late 2015 and early
2016 the program level API stabilizes. People were piloting projects
with it. This included our small group at Caltech Library. During 2015
non-English language support appears with the list expanding beyond
European languages in 2016. Summer 2016 we start to see a shift to
support missing features like alternative sorting. While Bleve isn't
yet 1.0 (Feb. 2018) it is however quite solid and we rely on it. In
the Go community 1.x releases have been solid and well vetted. Given
the momentum I suspect Bleve will have moved from bleeding to leading
edge this 2018. There primary challenge is documenting the system for
non-Programmer or novice usage.  It has proven effective for our
purposes (e.g. archives and library repository feeds search engines).

Even leading edge software is a risk. We have mitigated this in two ways.

1. Identify alternative technology
2. Architect our systems to allow easy decomposition and re-composition

In the case of Go, packages can be compiled to a C-Shared
library. This means we could expose that capability in other languages
like Python, R, and PHP. Since we have more staff that knows Python
than Go we have this on our current road map for projects.

For Blevesearch the two alternatives are - Solr and Elastic
Search. Both are well known, documented and solid.  The costs would be
recommitting to a Java stack and its resource requirements. We have
already identified what we want to index and that could be converted
to either platform if needed.

If we stuck with Go but dropped Blevesearch we would swap out the
Bleve specific code for similar packages supporting Solr and Elastic
Search.  These are have become increasingly mature over time given the
large Solr/Elastic Search adoption. Targeting our custom code leverage
these packages is likely to be only a matter of gaining familiarity
with the specific platform as wrapping the API to fit existing calling
methods in our programs.

The greatest level of risk I worry about with developing library and
archives software in Go is knowledge transfer. I am currently the only
fluent member of our team in developing with Go.  I think this can be
addressed by knowledge sharing, some training and the opportunity for
others to experiment with and apply Go to real library problems.  All
our development staff has at least a passing familiarity with
Python. In Go's early evolution the largest group adopting go were
Python programmers not Java/C++ programmers. I think this in part was
because the need in the Python community for performance and the easy
at which you can consume or produce API in both languages. Today you
can write Python libraries in Go as well as in C/C++ or Java (for
Jython). Go is a complementary platform to Python.

### Challenges in adopting Go

Fixing and extending code written in Go does require getting familiar
with Go.  Go supports modern data types (e.g. int, floats, arrays,
maps, strings) so in many cases maintenance of Go code is about the
same as other language where familiarity is limited. It boils down to
mapping general concepts to specifics in Go. It helps to be willing to
pickup some Go "idioms" as these have become prevalent through out the
Go community. Because of Go's tool chain (e.g. gofmt, golint, godoc)
the variance you see in coding style is considerable less than you'll
find in communities like Perl, Ruby, PHP, NodeJS, C/C++ or Java. This
is one of Go's strengths. The more idiomatic the Go code base the more
similar it looks regardless of who wrote it. Additionally there are
now ample books, tutorials, forums and classes covering learning Go.
I expect these to continue to grow. Many of the books are in their 2nd
editions which also suggests a maturing market for learning
Go. E.g. [lynda.com](https://www.lynda.com/Go-tutorials/Up-Running-Go/412378-2.html)
offers a "Up Running Go" course.


## What are the benefits?

For library and archival projects Go's benefits are in performance for
back end systems, ease of deployment, a rich standard library focused
on the types of things we use, sharing of code between projects and
systems and a growing ecosystem of useful packages. It plays nice with
other systems (e.g. I create an API go based service that can easily
be consumed by a web browser running JavaScript or Perl/PHP/Python
code running under LAMP). I think of Go as high performance duck
tape. We get the performance and reliability of C/Java type systems
with the code cognitive weight of similar to Python.
