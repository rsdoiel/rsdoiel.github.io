

This is a early draft based on my recent reading. It will likely change. 2014-06-10

# What are Web Components?

Web Components are a coming W3C spec that allow you to safely and easily extend HTML markup with custom
tags that have default appearences (CSS), behavior (JS) and semantics (HTML). The most high profile projects dealing with 
web components are [Brick](http://mozilla.github.io/brick/) from Mozilla, [Polymer Project](http://www.polymer-project.org/)
from Google.

Web Components replace much of what we'd have hack together with libaries like Dojo, jQuery+jQuery UI or YUI+YUI Widgets.
Why switch? Past Widget libraries and frameworks have tended to work against the DOM rather than with it. Web Components
are designed to work along side and with DOM. Today you use them via polyfils. Those polyfils are giving way to native
implementations in most of the evergreen browsers (even I.E. 9). Expect some clever performance improvements as time goes
forward. 

With Web Components we only need to load what we use. Also you only download them once even when you load them multiple
places in the page.  Unlike legacy frameworks widgets are compatible across libraries supporting web components.  I can use
a component from Mozilla's Brick or [X-Tags](http://x-tags.org) in a project built on Google's Polymer. I don't
carring extra over head and a second framework or library in doing that.

Web Components are built from four important specifications

+ Custom Elements
+ HTML Templates
+ Shadow DOM
+ HTML Imports

If you're starting out focus on Custom Elements.  You can use and create them with a minimum of polyfils. Overtime when
they become supported natively in browser HTML Imports and Shadow DOM will become invaluable tools in the Web Component 
tool box. You can experiment with all four parts by using Google's Polymer Project but doing so caries a noticable
penalty in browser performances (e.g. implementing Shadow DOM is very browser intrusive). You can try out each al la carte.
The X-Tag project by Mozilla offers HTML Templates and HTML Imports as polyfils. Additionally in the spirit of 
Open Source both Polymer and X-Tag are now sharing code base.  For the purposes of introduction I am
going to focus on the Mozilla efforts. 

## Getting started

Today you create a Custom element by invoking a registration function on document in the DOM.  Brick is an example of a collection of currated custom elements you can use today (I've used the x-calendar component in a work project going into production in July 2014). Custom elements can be UI based like a specialized button or branding element or service based (e.g. Polymer Project has a component that manages Ajax transaction and does data binding with other DOM elements).

Below I will step through three of parts of the spec supported by x-tags

1. Custom Elements
2. HTML Templates
3. HTML Imports

But before I dive into details let's look at the simple case of using custom elements since some very good ones are
already available in Mozilla's [Brick](http://mozilla.github.io/brick/).

### Getting setup

We're going to leverage Mozilla's [Brick](http://mozilla.github.io/brick) project for learning about Web Components.
Before we begin the you need to get a bunle of [Bricks](http://mozilla.github.io/brick/download.html). If you're
experimenting I recommend selecting all the components they list and downloading the whole collection.
Once that is available we're ready to starting working with components.

Here's the basic steps we're going to use for each of our examples

1. Load the x-tag's core polyfil via the Brick bundle (e.g. brick.1.0.1.mins.js)
2. Load any additional custom compent(s) we want to use 
3. Wait for the event _DOMComponentsLoaded_ before interacting with the component's content

That's it. three steps and you're good to go.


### Using Brick's app bar


### Writing a custom element to pull in remote content

### Writing a markdown processing custom element

### Adding support for HTML Templates

If you have HTML Templates available you can start to encapsulate markup, Javascript and style into a single document which is 
then render to produce a custom element. Likewise HTML Imports will let us easily bring custom elements into a page via a link element with a rel attribute of import.

Shadow DOM has gotten allot of buzz. Shadow DOM allows you to create DOM nodes without causing the browser to re-render until you
are ready to clone them into the actually non-shadow tree.  Shadow DOM is actually what browers have used to describe things like the new time input type of date picker.  Only when it is cloned into the page do the elements overhead have an impact on rendering.

### Adding support for HTML Imports

#### What's the big deal about HTML Imports?

HTML imports are an extension to the link element that allow you to easily bring in HTML, CSS and JavaScirpt
into a webpage as a unit (e.g. as a Web Component). Say you your employer wants to provide consistent branding
bar across different websites. One way is to distribute specific CSS and HTML markup to implement the common brand bar.
This might looks something like this--

```CSS
    .branding-bar {
        font-family: National;
        font-size: 18px;
        color: white;
        background-color: red;
    }
    .branding-logo {
        border: 0.15em solid back;
        background-image: http://example.com/company-logo.png;
    }

    .branding-bar h1 {
	font-size: 2em;
    }
```

And markup like--

```HTML
   <div class="branding-bar"><h1>My Big Company</h1> <div class="branding-logo"</div><div>
```

You have several files that have to be touched to implement this simple element.  Of you can use HTML Imports then you have two lines
in the HTML that need to be add

1. A link in the head to import the branding bar
2. A new HTML element called "company-branding-bar"

Here's an HTML fragment showing how you would use this.

```HTML
    <!DOCTYPE>
    <html>
        <head>
            <script src="//cdnjs.cloudflare.com/ajax/libs/polymer/0.3.1/polymer.js"></script>
            <link rel="import" href="http://example.com/components/company-branding.html">
        </head>
        <body>
            <company-branding></company-branding>
```

And the branding bar would jsut work.  When you consider how site re-use content elements like share bars, nav menus, footers/headers, lists using HTML import to expose each of these as a custom element can be a powerful way to quickly wire up
in HTML a working prototype.

## HTML Templates anyone?

HTML Templates are inert HTML fragments that are contained in a template element. The [coming releases](http://caniuse.com/#search=html%20template) in the evergreen browsers are supporting HTML Templates. HTML Templates allow you to create
HTML fragments including fragment specific CSS and JavaScript that can be instanciated and inserted into the DOM by
the web browser when needed.  They replace what we often had to do with a more heavey iframe. Think about calendar integration. Rather then a library for the Ajax call, cruft JS DOM intereaction you could do something like this in a page--

```javascript
    <section>
        <h3>My Calendar</h3>
        <my-event-calendar-list calendar_id="32" start="2014-06-01" end="2014-06-30" view="summaries">
        </my-event-calendar-list>
    </section>
```

And that would render out a list of events, stylable via the site's CSS. The HTML template would take care of the layout of the custom element and appropriate integrating style. The Custom Element would include the JS needed to fetch the event list for the date range listed in the element and might setup a link to event details. For the person doing integration in the CMS is this easier than merging CSS, adding JavaScript, etc.

I think the biggest game changer is in how CSS interacts with the fragment. Using an HTML Template and Custom Element you can prevent CSS leaking into and out of your HTML template. You can also selectively allow content or CSS to enter your rendered template. This means you can break out things like footers, navigation, branding and other major elements into composible units which are then resolved browser side.


## What are Custom Elements

Custom elements are HTML elements created through a library or by you that have a hyphen in the name. They are built out of HTML, CSS and JavaScript. They can work with HTML Templates and potentionally be include via HTML Imports when that becomes natively supported in browsers.

Font end developer will like need to create new custom elements to meet specific unique website/app requirements and will also likely consume other Custom elements that solve common problems (e.g. x-calendar is a ready made datepicker you can use today).

Elements are declarative and their behavior is modified by their attributes (think the select/option tags in a web form).  They can be UI elements (e.g. button or my-super-button if you made a special component of one) or non-UI elements like ways of accessing storage, remote resource (this would be like the link element or script element in a page, not normally displayed but providing increased functionality).

### How does this help?

Web Components provide a missing feature in HTML markup. It allows you to easily create composible elements that can then be made available to the webpage as simple markup. The elements can include HTML, CSS, JavaScript working together. It can event include custom elements made up of other custom elements.

## Tools you may find helpful

Getting started today with Web Components does require some familiarity with command line tools like _npm_, _bower_ and _grunt-cli_. As more component libraries become available this may deminish over time (e.g. Brick and Polymer Project both offer pre-built downloads).

Browser side web compents already are support by the developer tools that come with Firefox and Chrome. You can drill into a component by using the inspector tool.


## Getting started


## Summary

We are still at the early end of Web Component adoption.  Work started back in 2012, implementations were appearing and being refined 2013 and evergreen browsers are beginning to turn on native implimentations in 2014. Use Web Components in mid-2014 still means using some level of polyfils.  The lightest weight are those that come with Brickjs. More featureful are those from the Polymer Project. Code is now being shared between X-Tag/Brick and Polymer so expect the foot print to shrink as native implementations appear in the wild.

Getting started today is a bit rough. There is a bit of "clear only if known" in some documentations.  The biggest challenge today is not in finding documentation but finding current documentation.  Examples and Tutorials from early 2013 often are wrong based on today's implementations and polyfils. On the other hand even when the specific examples are no longer accurate the concepts are generally there but have been revised and stablized since originally conceived or proposed.

Here's some videos and articles I found helpful and largely still current:

+ [Brick](http://mozilla.github.io/brick/) - Mozilla currate components used in Firefox OS
+ [Polymer Project](http://www.polymer-project.org/) - Google's polymer project including polyfils for exposing HTML Imports in legacy browsers
+ Angelina Fabbro
	- Video: [Web Components and HTML5](https://www.youtube.com/watch?v=dW2ib0bkxGQ&index=2&list=LLZZeV_1MGZKINsvizdVIZOw)
	- Video: [Web Components a Year later](http://vimeo.com/78899868)
	- Article: [Custom Elements for Custom Applications](https://hacks.mozilla.org/2014/03/custom-elements-for-custom-applications-web-components-with-mozillas-brick-and-x-tag/)
+ Eric Bedlemen:
	- Video: [Web Components: A Tectonic Shift for Web Development](https://developers.google.com/events/io/sessions/318907648)
	- Article list: [Web Component Resources](http://ebidel.github.io/webcomponents/)
	- Article: [HTML Imports](http://www.html5rocks.com/en/tutorials/webcomponents/imports/)
	- Article: [Custom Elements](http://www.html5rocks.com/en/tutorials/webcomponents/customelements/)
	- Article: [HTML Templates](http://www.html5rocks.com/en/tutorials/webcomponents/template/)
	- Article: [Shadow DOM 101](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom/)
	- Article: [Shadow DOM 201](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom-201/)
	- Article: [Shadow DOM 301](http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom-301/)
+ Mozilla MDN
	- [X-Tag and the Web Components Family](https://developer.mozilla.org/en-US/Apps/Tools_and_frameworks/x-tags#HTML_Imports)
        - [Web components and Mozilla Brick](https://developer.mozilla.org/en-US/Apps/Tools_and_frameworks/Web_components)
        - [Your own bricks: Creating custom elements using X-Tag](https://developer.mozilla.org/en-US/Apps/Tools_and_frameworks/Web_components#Your_own_bricks.3A_Creating_custom_elements_using_X-Tag)
+ Mozilla Hack site
	- [Web Component Article List](https://hacks.mozilla.org/category/web-components/)

