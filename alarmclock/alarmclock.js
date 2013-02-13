//
// alarmclock.js
//
/*jslint browser: true */
/*global YUI */
YUI({
	debug: true
}).use("node", "io", "datatype-date",  function (Y) {
	var clock = Y.one("#clock"),
		clock_rate = 1000,
		weather = Y.one("#weather"),
		alarms = Y.one("#alarms");

	// FIXME: Need to only run the setInterval if the page
	// is visible. Check the Moz APIs for their Firefox OS
	// platform to see how to keep from burning battery
	// unnecessarily
	Y.log("Setting up, setInterval()", "debug");
	setInterval(function () {
		clock.setHTML(Y.Date.format(new Date(), {format: "%H:%I:%S %p"}));
	}, clock_rate);
});
