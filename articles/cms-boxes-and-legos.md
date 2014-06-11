
Web Services is an odd beast. We know allot about content but we actually build boxes for content. That creates a disconnect for us and our customers.  Often our customers insist on a specific box like an egg carton and then put eggplants in them. We wonder why the container is broken or has become ugly.  Sometimes out customers notice, sometimes not. It can be hard convincing someone that an egg and a eggplant are the same thing.

More recently we've specialized in adapting comodity boxes (e.g. Wordpress, Drupal, MT). For the most part that's worked.  It simplifies having outside consultants help. Our customers have a more consistent experience so avoid the egg versus eggplant problem easier.  We focuses our efforts on decorating the box and sometime cutting holes in it. At this stage I'd say we are very good at adapting comodity boxes.


What are some of the properties of comodity boxes that work for us?

1. Familiarity (for staff and clients)
2. We only build parts (e.g. themes) rather than the whole box
3. The community that uses the box is a resource (e.g. security, best practice, new plugins)
4. There is a promise of faster development cycles since in principle you can use your theme code and design


What are some of the properties of comodity that work against us?

1. Limitations on performance (keep WP fast is non-trivial)
2. Business model is still based on one offs, not much re-use
3. Designing and implementing re-use takes more effort, doubly so in a highly customized installation
4. We only think inside our shiny new box


That last one is a kicker.  It really chafes.  If our boxes work only one way (and they do right now) we are constrained by the overhead of the outer container (LAMP has allot of overhead). We contort our solutoins to fit container. By the time we get to interesting the design the budget in CPU cycles, network, memory, is already spent. How do we keep the benefits of our boxes and jetison the limitations?  Is that possible?


Let's shift the metaphor from boxes to lego bricks. A CMS is a brick. Today we use the brick as an end in itself. It is tempting to melt the lego brick to get get another effect but when we do that we loose the benefits that come with a comodity. Leveraging that a lego means understanding how it can be combined and what other lego types might do something better.

What is our CMS lego really good at? It is very good at presenting a safe way to save content for display on the web. It is easy constrain (via roles) who can change what content.  It is servicable for displaying the content (e.g. our virtual hosted websites). It is ackward at adapting to other uses (though we've become very good at fitting square pegs into round holes). Buy itself it is a little boring. It is a pain to scale well.


When I was a kid and first discovered legos I was with another older kid named Bobby Vanix. He build really cool stuff with legos. Watching Bobby I learned quickly that I could attach legos in different ways. I also learned  that sometimes using the smaller or larger legos enabled a better result.  The work horse lego was the 2x8.  I think of our CMS as a 2x8.  It is used everything but is also constraining.  Do we have other legos to build with besides a 2x8?

Let's back and think about sites. We build lots of brochure-ware sites. They are organized around pages.  A page can be thought of as a lego brick.  In our CMS rendering a page co-mingles allot of content with HTML, CSS, JavaScript and other assets sent down to the brower.  Visually we'll identify elements (e.g. branding bar, footer, icon) but in implementation this stuff is complete spaghetti.  What if it wasn't?  What if we had smaller elements as distinct legos?

1. Organizational Branding bar
2. vertical, horizontal, menu navigation
3. Footers
4. Layouts

We could assemble those elements into pages using the right lego to achieve the desired effect.  It would require that we design and implement those legos and not just the bug 2x8 themes.  We'd need to think about the small and how they combine. 

Furtunately we have a new technology arriving in the web browser - Web Components.  They let us design and implement reusable legos that can be easily and safely assembled into a page. Depending on what we choose as a our legos these Web Components can off-load some tests from our servers and that may lead us to more flexibly designs and implementation. If we don't insist on each lego being a custom brick then we will gain the benefits of re-use too.

Web components may give us some flexibilty without warping our CMS. A good example is user roles. In our CMS we've implemented a parallel role system because the native rolls are
not appropriately privileged.  A good example is currating menus. To allow a client to currate the menus using the native CMS roles means we over privilege that user.

We warp our CMS brick by creating more and more roles.  We do this because the native roles don't allow users to do what we'd like them to do.  With each customization you loose the comodity benefit of our comodity CMS without removing the liabilities of comodification. Ultimately that is head-ache for everyone.

What if the menu was a lego brick of content that the user's role could edit.  How do we make that brick? A menu could be a web component.  A web component could be a simple page in the CMS.  The component is pulled into the browser render page and resovled there. The nice thing about this approach is we already have native roles that are not over privileged allowing users to edit a page. The menu would be a page that help a list (possibly a nested list) that the component renders into the menu. Having the small brick of a menu turns the menu problem into one aligned with our CMS's native roles.  Something to think about.


What about other legos? 

One of the ways we warp our CMS into doing our bidding is by using plugins.  A few well behaved plugins is not a problem. Always adding plugins and stacking them together where they interact across the whole CMS effecting the hundreds of sites causes problems.  We need to think about what problem we're trying to solve with the plugin before we opt to add it. We need to find the right lego brick (which may be a plugin or something else).

Another way

If we allow other large legos beyond the CMS we have interesting oppurtunities.  The other legos must snap togher with the CMS but can be implemented independently.

Let's say your building a high traffic site
and you want a complex behavior not available in WP natively.  You don't have to
be in WP to achieve that. You can use WP as an input brick for managing the content
and then use another mechanism to render it. A good example of where we have different
choices once we think beyond WP is menus.  We've had to create a whole range of USC roles
to allow WP to added and remove permissions based on a sites' requirements.  If you think
of WP as a content input system a simple page can be the menu which specific native WP
rights of who can edit. If the page renders as a Web Component (a small brick) it can
now be included in other pages browser side to achieve the desired result.

Another brick is aggregation and feed management.  WP has an RSS Widget for bring in feed content. It doesn't have a good way to currate feeds outside of the blog producing the feed.  An aggregation engine can suck all the WP content out of our customsites and provide various feed management features (e.g. ad-hoc feeds, feeds based on content types, and item categories or excluded categories). An aggregation engine, because WP has solved the ingest problem) can also serve as a platform for rich content search. You could even
render your site from the aggregation engine rather than from WP if the specific needs (e.g. high performance, high traffic) required it.  An Aggregation Engine is just another lego brick and if you design it to connect with other systems you now can stack those bricks uniquely to build sites that aren't limited by their original container or punching wholes in the original container.

Where does this lead us?

The web platform is changing. When I started building web systems back in the pre-apache era systems rendered database content to disc as "static" HTML pages.  Apache came along and with Perl we begin building more complex and dynamic systems.  PHP furthered that trend. Eventually JavaScript showed up and things could happen in the browser.  All these systems have matured but they aren't the only legos out there. We need to be familar with more types of legos and use them where they make sense.

Heres' some interesting legos I'd like to see us use in the commoning year--

1. Web Components so we can design and build less while creating more and richer experiences
2. Move beyond LAMP to PHP+MongoDB and even NodeJS+MongoDB, if we make faster server side systems that get content to the browser quicker our users will stay on our sites longer and find them useful.
3. I would everyone to explore the bare metal of the web - HTML, CSS, JavaScript, HTTP protocol when we are familiar with these we can make the right choices about which bricks to build with

Finally I'd like to point out one of the reasons the lego system works is because each brick is simple, it does one thing, and that makes it easy to compose them into complex expressions which delight the viewer as well as the builder.

