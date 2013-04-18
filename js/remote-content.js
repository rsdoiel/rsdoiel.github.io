/**
 * Setup a layout for bringing in content from various places on 
 * the net.
 */
/*jslint browser: true, undef: true, newcaps: true, indent: 2 */
/*global YUI */
YUI().use("node-base", "jsonp", function (Y) {
  "use strict";

  /**
   * Setup and layout content pulls for Github
   */
  var makeGithubList = function (items) {
    var i = 0, parts = [];

    //  parts.push('<ul>');
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
    // parts.push('</ul>');
    return parts.join("");
  };


  var urls = { 
    'github_rsdoiel' : 'https://github.com/rsdoiel.json',
 	'github_uscwebservices' : 'https://github.com/uscwebservices.json',
   	'phizcode_blog' : 'http://phizcode.blogspot.com/feeds/posts/default?max-results=3&alt=json'
  };
  
  /* urls.github_my_repos */
  Y.jsonp(urls.github_rsdoiel + "?callback={callback}", function (data) {  
    var i = 0, repos = {};
    if (data.length > 0) {
      for (i = 0; i < data.length; i += 1) {
        if (data[i].repository !== undefined &&
             (data[i].repository.owner === "rsdoiel" ||
          data[i].repository.owner === "uscwebservices")) {
          if (repos[data[i].repository.name] === undefined) {
            repos[data[i].repository.name] = data[i].repository;
          }
        }
      }
      Y.one('#github-my-repos').setHTML(makeGithubList(repos));
    }
  });

  /* urls.github_uscwebservices_repos */
  Y.jsonp(urls.github_uscwebservices, function (data) {  
    var i = 0, repos = {};
    if (data.length > 0) {
      for (i = 0; i < data.length; i += 1) {
        if (data[i].repository !== undefined &&
            (data[i].repository.owner === "rsdoiel" ||
          data[i].repository.owner === "uscwebservices")) {
          if (repos[data[i].repository.name] === undefined) {
            repos[data[i].repository.name] = data[i].repository;
          }
        }
      }
      Y.one('#github-uscwebservices-repos').setHTML(makeGithubList(repos));
    }
  });
});
