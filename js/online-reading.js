/**
 * Setup a layout for bringing in content from Google Reader
 */
makeReaderDeck = function (item) {
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
 * Setup a layout for bringing in content from Phiz Code at Blogger
 */
makeBloggerDeck = function (item) {
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

makeWatchDeck = function (item) {
  var title, j = 0;
  
  if (typeof item.url !== "undefined") {
    title = '<a href="' + item.url + '">' + item.name + '</a>';
  } else {
    title = item.name;
  }
  if (typeof item.language !== "undefined") {
    return '<li>' + title + ', ' + item.language + '</li>';
  }
  return '<li>' + title + '</li>';
}

$(document).ready(function () {
  /* Grab my shared items from Google Reader. */
  var url = "http://www.google.com/reader/public/javascript/user/05065097874671388976/state/com.google/broadcast?n=17&callback=?";
  
  $.getJSON(url, function (data) {
    for (var i = 0; i < data.items.length; i += 1) {
      $('#recently-read').append(makeReaderDeck(data.items[i]));
    }
  });
  
  /* Grab 3 articles from my Phiz Code blog */
  /*
  url = "http://phizcode.blogspot.com/feeds/posts/default?max-results=3&alt=json&callback=?";
  $.getJSON(url, function (data) {
    var items = data.feed.entry;
    for (var i = 0; i < items.length; i += 1) {
      $('#recently-written').append(makeBloggerDeck(items[i]));
    }
  });
  */
  
  /* Get projects I'm watching on github. */
  url = "http://github.com/api/v2/json/repos/watched/rsdoiel";
  $.getJSON(url, function (data) {
    for (var i = 0; i < data.items.length; i += 1) {
      $('#gitub-watch-list').append(makeWatchDeck(data.items[i]));
    }
  });
  
});

