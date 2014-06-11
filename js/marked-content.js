/**
 * marked-content.js - This is a web component based on x-tags/Brick for rendering Markdown content directly into a page.
 */
/*jslint browser: true, indent: 4 */
/*global xtag, console, httpGET */
(function () {
    "use strict";
    xtag.register('marked-content', {
        'extends': 'div',
        lifecycle: {
            create: function () {
                this.innerHTML = '<em>Hello World!</em>';
                console.log("DEBUG this.href:", this.href);
                // Get this.href
                // Run through markdown
                // replace into <marked-content></marked-content> element
            }
        }
    });
}());