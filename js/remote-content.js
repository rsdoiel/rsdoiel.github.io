/**
 * Setup a layout for bringing in content from various places on 
 * the net.
 */
/*jslint browser: true, undef: true, newcaps: true, indent: 4 */
/*global YUI */
YUI().use("node-base", "jsonp", function (Y) {
    "use strict";

    /**
     * Setup and layout content pulls for Github
     */
    function makeGithubList (items) {
        var i = 0, parts = [];
        
        Y.log(items, "debug");
        Object.keys(items).forEach(function (ky, i) {
            var name = items[ky].name,
                description = items[ky].description,
                url = items[ky].url,
                language = items[ky].language;
            if (! language) {
                language = "text";
            }
            parts.push('<li><a href="' +
            url + '">' + name + '</a> (' + language + ') ' + description + '</li>');
        });
        return parts.join("");
    }

    /* urls.github_my_repos */
    Y.jsonp("https://github.com/rsdoiel.json?callback={callback}", function (data) {  
        var i = 0, repos = {};
        Y.log(data, "debug");
        if (data.length > 0) {
            for (i = 0; i < data.length; i += 1) {
                if (typeof data[i].repository !== "undefined" &&
                    (data[i].repository.owner === "rsdoiel" || data[i].repository.owner === "uscwebservices")) {
                    repos[data[i].repository.name] = data[i].repository;
                }
            }
            Y.one('#github-repos').setHTML(makeGithubList(repos));
        }
    });
});
