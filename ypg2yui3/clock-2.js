/*jslint browser: true, indent: 4 */
/*global YUI */
// Define out module using _YUI.add()_
YUI.add("clock", function (Y) {
    "use strict";
    // Create our namespace
    Y.namespace("Clock");

    // Setup a constructor with reasonable defaults
    function Clock() {
        Y.log('clock created', 'debug');
    }
    Clock.prototype.interval = 1000;
    Clock.prototype.int_id = null;
    Clock.prototype.selector = null;
    Clock.prototype.render = function (now) {
        this.element.set("text", now.toString());
    };
    Clock.prototype.run = function (selector, interval, renderCallback) {
        var self = this;

        this.element = Y.one(selector);
        if (renderCallback !== undefined) {
            this.render = renderCallback;
        }
        this.int_id = setInterval(function () {
            self.render(new Date());
        }, interval);
        return this.int_id;
    };
    Clock.prototype.stop = function () {
        if (this.int_id) {
            clearInterval(this.int_id);
        }
    };

    // Add our new Object as Clock
    Y.Clock = Clock;
}, /* Semantic Version number */
    "0.0.2",
    // Configuration with list of modules we 'require'
    {requires: ["node-base"]});