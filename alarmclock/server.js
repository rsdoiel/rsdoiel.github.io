//
// Simple server to test page with.
//
var express = require("express"),
	server = express();

server.use(express.logger());
console.log("Serving files from", __dirname);
server.use(express.static(__dirname));

server.listen(process.env.PORT || 3000);
console.log("Listening on port", process.env.PORT || 3000);
