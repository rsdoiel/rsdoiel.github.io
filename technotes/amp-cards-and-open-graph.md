
# Instant Articles, Accelerated Mobile Pages, Twitter Cards and Open Graph

    2016-05-30, [R. S. Doiel](http://rsdoiel.github.io)

This article is an overview of several web content organizations that
suggest an improved the web experience for our audiences.

## The problem

The web has gotten slow. In 2015 the average page weight was in multi-megabytes and the
average number of network requests needed to deliver all the content to render a page
was counted in the hundreds. In the mix was saturated networks 
and a continued public expectation of responsiveness
(web wisdom suggests people will wait about 3 seconds before giving up on your page).
The odd thing is we've known how to build fast websites for over a decade.
Collectively we don't build them fast. 

## Meet the new abstractions

Corprations believe they have the answer and they are providing us with a new
set of abstractions. In a few years maybe these will get distilled down to a shared
common view but in the mean time disc costs remain reasonably priced and generating 
these new types of pages is only a script and template or two away.

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

Our usual suspects are Twitter for Titter Cards and Facebook for Open Graph. Both
protocols build off of existing meta HTML elements in the HTML page's document
head. They are named space to avoid collisions but supporting both will still
result in some content duplication. The k-weight difference in the resulting HTML
pages isn't too bad. Not particularly hostile to the open web.

Adopting either or both is a matter of adjusting how your render your web page's
header block.  This can be done easily in manually edited pages but easier still
using some sort of template system that renders the appropriate meta elements
based on the content type and contents in the page being rendered.

Google and possibly other search engine crawlers leverage this
rich source of meta data and integrate it into their results. Google's Now
application can render content cards based on either semantic. It also appears
that "content cards" are being leverage selectively for an aside and related content
on Google search results pages.

Content Cards offer intriguing opportunity for web crawlers and search engines.
This is particularly true when combined with mature feed formats like RSS, OPML,
Atom and the maturing efforts in the linked data community like JSON-LD.

### AMP

    Accelerated Mobile Pages

The backers of AMP (not to be confused with Apache+MySQL+PHP) are largely
publishers but include some of the major news outlets as well as web media
companies in the US and Europe. This is an abridged list--

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
such as Google, Pinterest, Twitter, LinkedIn and Wordpress.com. In the area
of news content delivery these efforts seems likely to grain a modest level of
adoption. Like Twitter Cards and Open Graph the recommendations for Accelerated
Mobile Pages has some strong benefits for web crawlers and search engines as the
content is surfaced clearly and less likely to be confused with third
party content such as advertisements.


### Instant Articles

In additional to Open Graph Facebook has put forward [Instant Articles](https://developers.facebook.com/docs/instant-articles).
Like AMP it is targetting delivery for mobile. Unlike AMP Instant Articles is an
explicit binding into Facebook's walled garden on iOS and Android. You don't see them 
in your Facebook timeline or when on your deskop/laptop.  Additionally unlike the previous
examples you actually need to sign up to participate in the Instant Article publishing
process.  Sign up cost is having a Facebook account, being approved by Facebook and complience
with their terms of service. Facebook does provide some publishing tools, publishing controls
as well as some analytics. They do allow adds to pass through as well as encourage access to
their ad network.  Once approved the burden on your content manage process is reasonable.  

You can submit Instant Articles via a modified RSS feed or directly through their API. 
In this sense the overhead is about the same as that for implementing support for Twitter Cards
Open Graph or AMP. Facebook as done a good job of quickly propogating changes to your
feeds across their platform. That's nice.

Why go through the trouble? If you're a content producer and your audience lives on the Facebook
you can reach them when they are on their mobile iOS or Android device. 
Facebook has allot of eye balls. In some places they effectively control the public view of 
the web much as America Online and Prodegy did in the days of yore. [Dave Winer](http://scripting.com)
has written extensively on how he implemented Instant Article support along with some
very reasoned pros and cons for doing so. The landscapes are evolving and his river
is worth following.


## Impact on building content

These approaches require changes in your production of your HTML and RSS sent to the browser.
Twitter Cards and Open Graph change what you put in the HEAD element of the HTML
pages.  AMP proscribes what you should put in the BODY element of the webpage.
Instant Articles tweaks your RSS output. All can be implemented via your template 
system or page generatation scripts.

Not surprisingly the major content management systems Wordpress and Drupal have plugins for this.
Like wise it is easy enough to include in manually create pages or pages generated using a 
static site generator like Hugo or Jehkyll.


## When to adopt?

Because these approaches boil down to content assembly the adoption risk 
is low.  If your audience views Twitter, Facebook or Google search results 
then it is probably worth doing.  All allow you to continue to publish your 
own content and own your URLs as opposed to being a tenent on one or another 
platform. That benefits the open web.

