// Define out module using _YUI.add()_
YUI.add("digital-clock", function (Y) {
    // Create our namespace
    Y.namespace("DigitalClock");

    // This is a private function so doesn't need to be added to
    // the Y.DigitalClock instance.
    function checkForAlarm(alarms, previous_time, current_time) {
        alarms.forEach(function (alarm, i) {
            //FIXME: taverse our alarms list and see if any need to trigger notification.
            // Using i calc the CSS id in the UL list to add class of "active"
        });
    }
    
    // Setup a constructor with reasonable defaults
    function DigitalClock () {};
    DigitalClock.prototype.interval = 1000;
    DigitalClock.prototype.int_id = null;
    DigitalClock.prototype.selector = null;
    DigitalClock.prototype.render = function (now) {
        this.element.set("text", now.toString());
    };
    DigitalClock.prototype.run = function (selector, interval, template, alarms) {
        var self = this, previous_time = new Date(), current_time;

        this.element = Y.one(selector);
        if (typeof template === "function") {
            this.render = template;
        }
        // Process our alarms data structure and create a
        // queue of alarms, then inside setInterval check
        // if they have passed and pop the alarm off the list if
        // it has.
        this.int_id = setInterval(function () {
            current_time = new Date();
            self.render(current_time);
            previous_time = current_time;
            checkforAlarm(alarms, previous_time, current_time);
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
"0.0.4",
// Configuration with list of modules we 'require' 
{requires: ["node", "handlebars"]});