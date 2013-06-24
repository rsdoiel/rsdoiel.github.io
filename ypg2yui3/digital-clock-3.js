// Define out module using _YUI.add()_
YUI.add("digital-clock", function (Y) {
    // Create our namespace
    Y.namespace("DigitalClock");

    // Setup a constructor with reasonable defaults
    function DigitalClock () {};
    DigitalClock.prototype.interval = 1000;
    DigitalClock.prototype.int_id = null;
    DigitalClock.prototype.selector = null;
    DigitalClock.prototype.render = function (now) {
        this.element.set("text", now.toString());
    };
    DigitalClock.prototype.run = function (selector, interval, template) {
        var self = this;

        this.element = Y.one(selector);
        if (typeof template === "function") {
            this.render = template;
        }
        this.int_id = setInterval(function () {
            self.render(new Date());                
        }, interval);
        return this.int_id;
    };
    DigitalClock.prototype.stop = function () {
        if (this.int_id) {
            clearInterval(this.int_id);
        }
    };

    // Add our new Object as DigitalClock
    Y.DigitalClock = DigitalClock;
},
// Semantic Version number
"0.0.3",
// Configuration with list of modules we 'require' 
{requires: ["node", "handlebars"]});