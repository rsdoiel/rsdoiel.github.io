YUI().use("node", function (Y) {
    "use strict";
    // Step 1, get a handle to the node you want to work with in 
    // this case an anchor element
    var anchor = Y.one("a"),
        // Now get the value of the href attribute.
        href = anchor.get("href"),
        // Get the innerHTML of the anchor
        innerHTML = anchor.get("innerHTML");

    // Too see the results in the JavaScript console of the browser 
    // use Y.log()
    Y.log("The href is " + href);
    Y.log("The innerHTML is " + innerHTML);
    // Step 2, use setHTML() to change the value wrapped by 
    // the anchor
    anchor.setHTML('(links to: <em>' + href + '</em>) '  + innerHTML);
});