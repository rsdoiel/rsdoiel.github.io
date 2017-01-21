
# Instant Articles, Accelerated Mobile Pages, Twitter Cards and Open Graph

2016-05-30, [R. S. Doiel](/)

## The problem

The web has gotten slow. In [2016](http://httparchive.org/trends.php) the 
average page weight is in multi-megabytes and the average number of network 
requests needed to deliver the content is counted in 
the hundreds. In the mix are saturated networks and a continued public 
expectation of responsiveness (web wisdom suggests you have about 3 seconds 
before people give up).  The odd thing is we've known how to build fast 
websites for a [decade](https://www.stevesouders.com/) or so.  
Collectively we don't build them [fast](https://www.sitepoint.com/average-page-weight-increased-another-16-2015/). 


## Meet the new abstractions

Corprations believe they have the answer and they are providing us 
with another set of abstractions. In a few years maybe these will 
get distilled down to a shared common view but in the mean time disc 
costs remain reasonably priced and generating these new forms of 
pages or feeds is a template or so away.

+ [Twitter Cards](https://dev.twitter.com/cards/overview) and [Open Graph](http://ogp.me/)
  + Exposing your content via social media, search results or embedded in pages via an aside element
+ [Accelerated Mobile Pages](https://www.ampproject.org/) (also called AMP)
  + A simplification in content delivery to improve web reading experience
  + Its usefulness is it proscribes an approach to leverage what we have
  + AMP works well with Twitter Cards, Open Graph and can leverage Web Components
+ [Instant Articles](https://instantarticles.fb.com/)
  + a format play to feed the walled garden of Facebook for iOS and Android devices


## The players 

### Twitter Cards and Open Graph

Twitter's Titter Cards and Facebook's Open Graph offer approaches to 
build off of our existing meta elements in an HTML page's document 
head.  They are named space to avoid collisions but supporting both 
will still result in some content duplication. The k-weight 
difference in the resulting HTML pages isn't too bad. 

Adopting either or both is a matter of adjusting how your render your 
web page's head block.  It is easy enough to do manually but easier 
still using some sort of template system that renders the appropriate 
meta elements based on the content type and contents in the page 
being rendered.  

Google and other search engines can leverage this richer meta 
data and integrate it into their results. Google's Now application can 
render content cards based on either semantic. It also appears that 
content cards are being leverage selectively for an aside and related 
content on Google search results pages. You could even built this into 
your own indexing process for use with the Solr or Elasticsearch.

Content Cards offer intriguing opportunity for web crawlers and search 
engines.  This is particularly true when combined with mature feed 
formats like RSS, OPML, Atom and the maturing efforts in the linked 
data community around JSON-LD.


### AMP - Accelerated Mobile Pages

The backers of AMP (not to be confused with Apache+MySQL+PHP) are largely
publishers including major news outlets and web media
companies in the US and Europe. This is an abridged list from 2015--

+ BBC
+ Atlantic Media
+ Vox Media
+ Conde Nast
+ New York Times
+ Wall Street Journal
+ The Daily Mail
+ Huffington Post
+ Gannet
+ The Guardian
+ The Economist
+ The Financial Times

In additional to the publishers there is participation by tech companies
such as Google, Pinterest, Twitter, LinkedIn and Wordpress.com.  Accelerated
Mobile Pages offer benefits for web crawlers and search engines supporting
surfacing content is clearly and enabling easier distinction from 
advertisements. 


### Instant Articles

In additional to Open Graph Facebook has put forward [Instant Articles](https://developers.facebook.com/docs/instant-articles).
Like AMP it is targetting content delivery for mobile. Unlike AMP Instant Articles is an
explicit binding into Facebook's walled garden only exposing the content on supported
versions of iOS and Android. You don't see Instant Articles in your Facebook timeline or when  
your browser from a deskop webbrowser.  Unlike the previous
examples you actually need to sign up to participate in the Instant Article publishing
process.  Sign up cost is having a Facebook account, being approved by Facebook and compliance
with their terms of service. Facebook does provide some publishing tools, publishing controls
as well as some analytics. They do allow 3rd party ads as well as encourage access to
their advertising network.  Once approved the burden on your content manage process 
appears managable.  

You can submit Instant Articles via a modified RSS feed or directly through their API. 
In this sense the overhead is about the same as that for implementing support for Twitter Cards
Open Graph, and AMP. Facebook does a good job of quickly propogating changes to your
Instant Articles across their platform. That's nice.

Why go through the trouble? If you're a content producer and your audience lives on Facebook
Facebook commands the attention of a lot of eye balls.  Instant Articles privides 
another avenue to reach them.  For some Facebook effectively controls the public view of the 
web much as America Online and Prodegy did decades ago. [Dave Winer](https://twitter.com/davewiner) 
has written extensively on how he implemented Instant Article support along with 
some very reasoned pros and cons for doing so. The landscape is evolving and 
[Dave's river of news](http://scripting.com) is worth following.


## Impact on building content

These approaches require changes in your production of your HTML and RSS sent to the browser.
Twitter Cards and Open Graph change what you put in the HEAD element of the HTML
pages.  AMP proscribes what you should put in the BODY element of the webpage.
Instant Articles tweaks your RSS output.  Not surprisingly the major content management 
systems Wordpress and Drupal have plugins for this.  All can be implemented via your template 
system or page generatation process.


## Whither adopt?

Because these approaches boil down to content assembly the adoption risk 
is low.  If your audience views Twitter, Facebook or Google search results 
then it is probably worth doing.  All allow you to continue to publish your 
own content and own your URLs as opposed to being a tenent on one or another 
platform. That benefits the open web.

