//
// Simple server to test page with.
//
var express = require("express"),
	server = express();

server.get("/", function (request, response) {
	response.sendfile("./index.html");
});

server.get("/style.css", function (request, response) {
	response.sendfile("./style.css");
});

server.get("/alarmclock.js", function (request, response) {
	response.sendfile("./alarmclock.js");
});

server.listen(process.env.PORT || 3000);
