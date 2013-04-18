/**
 * Setup a layout for bringing in content from various places on 
 * the net.
 */
/*jslint browser: true, undef: true, newcaps: true, indent: 2 */
/*global YUI */
YUI().use("node-base", "jsonp", function (Y) {
  "use strict";
  /**
   * Setup and layout content for activity at Google Reader
   */
  var makeReaderDeck = function (item) {
    var title;

    if (typeof item.alternate.href !== "undefined") {
      title = '<a href="' + item.alternate.href + '">' + item.title + '</a>';
    } else {
      title = item.title;
    }
    if (typeof item.summary !== "undefined") {
      return '<li>' + title + ' -<br />' + item.summary + '</li>';
    }
    return '<li>' + title + '</li>';
  };

  /**
   * Setup a layout for bringing in content from Blogger
   */
  var makeBloggerDeck = function (item) {
    var title, j = 0;
  
    if (typeof item.link !== "undefined") {
      j = 0;
      while(j < item.link.length) {
        if (item.link[j].rel === 'alternate') {
          title = '<a href="' + item.link[j].href + '">' + item.title.$t + '</a>';
          j = item.link.length;
        }
        j += 1;
      }
    } else {
      title = item.title.$t;
    }
    if (typeof item.summary !== "undefined") {
      return '<li>' + title + ' -<br />' + item.summary.$t + '</li>';
    }
    return '<li>' + title + '</li>';
  };

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
  Y.jsonp(urls.github_rsdoiel + "?callback={callback}", 
          function (data) {  
              var i = 0, repos = {};
              Y.log("DEBUG got data, setting up to render it now.", "debug");
              Y.log(data, "debug");
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
                    Y.one('#github-my-repos').append(makeGithubList(repos));
                } else {
                    Y.one('#github-my-repos').append("Can't reach github.com");
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
                Y.one('#github-uscwebservices-repos').append(makeGithubList(repos));
            } else {
                Y.one('#github-uscwebservices-repos').append("Can't reach github.com");
            }
         });
});
