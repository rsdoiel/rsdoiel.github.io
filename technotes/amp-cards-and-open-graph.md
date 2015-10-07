
# Accelerated Mobile Pages, Twitter Cards and Open Graph

This article is an overview of three web content organizations that
can improve the web experience for our audiences.

## Three approaches promising to improve the web experience

### The problem

The web has gotten slow. Average page weight in 2015 is multi-megabyte and the
average number of network requests need to deliver all the content to render a page
is beging to count in the hundreds. On an expectation collision coarse is
slow or saturated networks (e.g. cell networks for mobile devices), public assumption
of responsiveness (studies show that you have less than 3 seconds before people)
will assume your page is broken an leave. We know how to be fast but we're not
building things on the web that way. We need to pick the right abstractions to
simplify content delivery, use and interaction. This tech note is looks at three
different approaches that resonate together to help address that challenge.

+ [Twitter Cards](https://dev.twitter.com/cards/overview) and [Open Graph](http://ogp.me/)
  + Exposing your content via social media, search results or embedded in pages via an aside element
+ [Accelerated Mobile Pages](https://www.ampproject.org/) (also called AMP)
  + A simplification in content delivery to improve web reading experience
  + Its usefulness is it proscribes an approach to leverage what we have
  + AMP works well with Twitter Cards, Open Graph and can leverage Web Components

## Who are the players in these technologies?

### Twitter Cards and Open Graph

The usual suspects are Twitter for Titter Cards and Facebook for Open Graph. Both
protocols build off of existing meta HTML elements in the HTML page's document
head. They are named space to avoid collisions but supporting both will still
result in some content duplication.

Adopting either or both is a matter of adjusting how your render your web page's
header block.  This can be done easily in manually edit pages but easier still
using some sort of template system that renders the appropriate meta elements
based on the content type and contents in the page being rendered.

Google search and possibly other search engine crawlers also can leverage this
rich source of meta data and integrate it into their results. Google's Now
application can render content cards based on either semantics. It also appears
that "content cards" are being leverage selectively for aside and related content
on Google search results pages.

Content Cards offer intriguing opportunity for web crawlers and  search engines.
This is particularly true when combined with  mature feed formats like RSS,
Atom and maturing efforts like JSON-LD.

### AMP

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
of news content delivery this effort seems likely to grain a modest level of
adoption. Like Twitter Cards and Open Graph the recommendations for Accelerated
Mobile Pages has some strong benefits for web crawlers and search engines as the
content is surfaced more clearly and less likely to be confused with third
party content such as advertisements.

## How do these impact building content?

All three require changes in your production of your HTML sent to the browser.
Twitter Cards and Open Graph change what you put in the HEAD element of the HTML
pages.  AMP proscribes what you should put in the BODY element of the webpage.
Both can be implemented via your template system or page generate scripts.

I would expect major CMS like Wordpress and Drupal to have plugins for these
emerging soon. Like wise they are easy enough to include in manually create pages
or pages generated using a static site generator like Hugo or Jehkyll.


## When do you start wit this

Because these approaches ultimately boil down to content assembly adoption
can be done ad-hoc or whole hog depending on your development and maintenance schedule.
For many it will be a mater of updating their templates used to generate the website
or in the case of dynamic CMS like Drupal or Wordpresss adding an appropriate
plugin when one is available. Long range adopting these
approaches could also mean improved performance in the web browser itself and not
only because of the smaller network foot print and limitted JavaScript. Finally
because all three approaches boil down to presenting your content the risk of
adoption is low so why not start today?
