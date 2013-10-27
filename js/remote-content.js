/**
 * Setup a layout for bringing in content from various places on 
 * the net.
 */
/*jslint browser: true, undef: true, newcaps: true, indent: 4 */
/*global YUI */
YUI({debug: false}).use("node-base", "jsonp", "handlebars", function (Y) {
    "use strict";
    var source = Y.one("#github-activities-template").getHTML(),
        template = Y.Handlebars.compile(source);

    Y.log("getting jsonp response", "debug");
    /* Grab interesting items */
    Y.jsonp("https://api.github.com/users/rsdoiel/events?callback={callback}", function (json) {  
        var repos = {},
            items = [],
            i = 0,
            data = json.data;

        Y.log("jsonp responded", "debug");
        Y.log(data, "debug");
        if (data.length > 0) {
            Y.log("jsonp data length " + data.length);
            for (i = 0; i < data.length; i += 1) {
                Y.log("ith " + i, "debug");
                Y.log(data[i], "debug");
                // Pull events that are interesting to list on langing page.
                if (data[i].actor.login === "rsdoiel" &&
                        typeof repos[data[i].repo.name] === "undefined") {
                    repos[data[i].repo.name] = true;
                    items.push({
                        name: data[i].repo.name,
                        url: 'https://github.com/' + data[i].repo.name,
                        activity: data[i].type.trim(),
                        when: new Date(data[i].created_at)
                    });
                }
            }
            Y.log(items, "debug");
            Y.one('#recent-experiments').setHTML(template({items: items}));
        }
    });
});
