/**
 * Check for and try some HTML5-isms if available.
 */
doTheHTML5Things = function (debug_div) {
  var msgs = [], runDemo = true, workarea, editable, canvas;

  if (debug_div.innerHTML.trim() !== '') {
    msgs.push(debug_div.innerHTML);
  } else {
    msgs.push("<p>Checking for HTML 5 support.</p>");
  }

  if (typeof Worker === "undefined") {
    runDemo = false;
    msgs.push("* <i>Web Workers</i> Not available.<br />");
  } else {
    msgs.push("* <i>Web Workers</i> Available.<br />");
  }

  if (typeof document.querySelector === 'undefined') {
    msgs.push("* <i>document.querySelector()</i> Not available.<br />");
    runDemo = false;
  } else {
    msgs.push("* <i>document.querySelector()</i> Available.<br />");
  }
  
  /*
   * Setup A storage example
   */
  if (runDemo === true) {
    var addEvent = (function () {
      if (document.addEventListener) {
        return function (el, type, fn) {
          if (el && el.nodeName) {
            el.addEventListener(type, fn, false);
          } else if (el && el.length) {
            for (var i = 0; i < el.length; i++) {
              addEvent(el[i], type, fn);
            }
          }
        };
      } else {
        return function (el, type, fn) {
          if (el && el.nodeName) {
            el.attachEvent('on' + type, function () { return fn.call(el, window.event); });
          } else if (el && el.length) {
            for (var i = 0; i < el.length; i++) {
              addEvent(el[i], type, fn);
            }
          }
        };
      }
    })();
  
  
    msgs.push("<p>Ready for HTML5 demo</p>");
    debug_div.innerHTML = msgs.join("\n");
    workarea = document.querySelector('#html5things');
    editable = document.createElement('div');
    editable.setAttribute('id','edit-me');
    editable.setAttribute('contenteditable', true);
    editable.setAttribute('style','background-color:silver;');
    editable.innerHTML = localStorage.getItem('contenteditable');
    if (editable.innerHTML.trim() === '') {
      editable.innerHTML = "Type stuff here.";
    }
    addEvent(editable, 'blur', function () {
      // lame that we're hooking the blur event
      localStorage.setItem('contenteditable', this.innerHTML);
      document.designMode = 'off';
    });

    clearme = document.createElement('input');
    clearme.setAttribute('type','button');
    clearme.setAttribute('name','clearme');
    clearme.setAttribute('value','Clear Text');
    addEvent(clearme, 'click', function () {
      localStorage.setItem('contenteditable','Type stuff here');
      editable.innerHTML = localStorage.getItem('contenteditable');
    });    
    
    workarea.innerHTML = "Hello World!";
    workarea.appendChild(editable);
    workarea.appendChild(clearme);
  } else {
    msgs.push("<p>Requirements not met to run demo</p>");
    debug_div.innerHTML = msgs.join("\n");  
  }  
};

doTheHTML5Things(document.getElementById('debug'));
