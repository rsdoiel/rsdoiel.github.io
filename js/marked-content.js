/**
 * marked-content.js - This is a web component based on x-tags/Brick for rendering Markdown content directly into a page.
 */
/*jslint browser: true, indent: 4 */
/*global xtag, console, httpGET */
(function () {
    "use strict";
    xtag.register('marked-content', {
        lifecycle: {
            created: function () {
                console.log("DEBUG creating marked-content");
                console.log("DEBUG created, href", this.href);
                console.log("DEBUG created, innerHTML", this.innerHTML);
            }
        },
        accessors: {
            href: {
                attribute: { url: ""}
            },
            innerHTML: {
                attribute: { string: "" }
            }
        }
    });
}());
