/*jslint browser: true, indent: 4 */
/*global YUI */
// Define out module using _YUI.add()_
YUI.add("clock", function (Y) {
    "use strict";
    // Create our namespace
    Y.namespace("Clock");

    // This is a private function so doesn't need to be added to
    // the Y.Clock instance.
    function checkForAlarm(alarms) {
        alarms.forEach(function (alarm) {
            var weekDays = [
                    "Sunday",
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday",
                    "Saturday"
                ],
                today = new Date(),
                dayOfWeek = weekDays[today.getDay()];

            if (alarm.day === dayOfWeek) {
                //FIXME: handle case of where we set alarm if the hour hans't passed.
                Y.log('need to set alarm', 'debug');
            } else {
                //FIXME handle case where we're not setting this alarm
                Y.log("don't set alarm", 'debug');
            }
        });
    }

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
    Clock.prototype.run = function (selector, interval, template, alarms) {
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
            checkForAlarm(alarms, previous_time, current_time);
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
},
    // Semantic Version number
    "0.0.4",
    // Configuration with list of modules we 'require' 
    {requires: ["node-base", "handlebars"]});