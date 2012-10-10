/**
 * An experiment in making a dashboard for social networks as a 
 * Javascript/Web Page Application.
 */

/*
 * Setup Storage Objects
 */

/*
 * Setup location Object
 */

/*
 * Setup web workers
 */

/*
 * Attach all the event handlers to the page.
 */
$(document).ready(function () {
  processFeed = function (feed) {
    /*/* $('#debug').html('type: ' + typeof feed.recenttracks.track + '<pre>' + JSON.stringify(feed.recenttracks.track) + '</pre>'); /**/
    if (typeof feed.recenttracks.track[0] !== 'object') {
      $('#lastfm').html("QM: Sounds like <i>" + feed.recenttracks.track.name +
                          "</i> by " + 
                          feed.recenttracks.track.artist['#text'] + "<br />");
      if (feed.recenttracks.track.date) {
        $('#lastfm').append("QM: But I think it is an echo from " + feed.recenttracks.track.date['#text'] + "<br />");
      } else {
        $('#lastfm').append("QM: Someone might be listening now.<br />");
      }
    } else if (feed.recenttracks.track) {
      $('#lastfm').html("QM: Sounds like <i>" + 
                        feed.recenttracks.track[0].name +
                        "</i> by " + 
                        feed.recenttracks.track[0].artist['#text'] + "<br />");
      if (feed.recenttracks.track[0].date) {
        $('#lastfm').append("QM: But I think it is an echo from " + feed.recenttracks.track.date + "<br /");
      } else {
        $('#lastfm').append("QM: Someone might be listening now.<br />");
      }
    } else {
      $('#lastfm').html("QM: Don't known, I can't hear Last.fm.");
    }
  };
  $.getJSON("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=rsdoiel&api_key=bfa9e860b48e8b8ebf18180483f10a0f&limit=5&format=json&limit=1&callback=?", processFeed);
});  
