//
// editor.js - this is an experiment in learning YUI3, 
// it's CSS handling by recreating a write-space like editor page.
// @author R. S. Doiel, <rsdoiel@gmail.com>
//
// copyright (c) 2012 all rights reserved
// Released under the Simplified BSD License
// See http://opensource.org/licenses/BSD-2-Clause
// for details.
//
/*jslint browser: true */
/*global YUI */
YUI({}).use('editor-base', function(Y) {
        var editor = new Y.EditorBase({
                content: '<strong>This is <em>a test</em></strong> <strong>This is <em>a test</em></strong> '
        }); 
        //Add the BiDi plugin
        editor.plug(Y.Plugin.EditorBidi);
        //Focusing the Editor when the frame is ready..
        editor.on('frame:ready', function() { this.focus(); });
        //Rendering the Editor.
        editor.render('#editor');
});
 
 