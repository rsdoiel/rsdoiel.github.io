
# Accelerated Mobile Pages application for library websites

## What problem is being solved

Websites are becoming increasing slow to use. They can become unusable
on mobile devices over cellular networks even when they are "designed for mobile".
This is a largely a problem of forgetting many of our best practices on the web.
[Accelerated Mobile Pages]() is a reaction to this problem. Its usefulness is
that it doesn't add to systems but proscribes an approach to leverage what we have.
Reminds me a lot of "JavaScript the Good Parts" but for the whole website.

Along with AMP (not to be confused with Apache+MySQL+PHP) there are related
HTML structure that have been evolving that complement this. Two important ones
are Twitter Cards and another is Open Graph.  These page level metadata markup
to expose document details in search results and social media.

+ [Accelerated Mobile Pages]() is a set of recommendations from a consortium of publishers to use a efficient subset from HTML, JavaScript and CSS
+ [Web Components]()'s custom elements with HTML templates
  + Custom elements add to the HTML markup available to a web page.
  + They use HTML templates, CSS and JavaScript.
  + Done well
    + Reduce the JavaScript you need to write and maintain
    + Facilitates reuse
    + Lets you innovate by composing HTML rather than coding complex JavaScript/CSS interactions
+ [Twitter Cards and Open Graph]() improve content sharing via social media and search engines


AMP is being developed via a Github repository.


## Who is involved

The backers of AMP are largely publishers but include some of the major news
outlets as well as web media companies. This is an abridged list--

+ BBC
+ Google
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


## How it works

The basic approach is to codify some best practices and limit the amount of JavaScript
executing in the page. There are some longer term objectives like consolidating
analytics scripts to use a single common API or to rely on non-JS tracking mechanisms.


## When do you start wit this

Since AMP is largely an approach we can start today. There is little new technology
to adopt that we are not already adopting (e.g. Custom Elements from the web component spec).
The start is to leverage static content and how we render it.
