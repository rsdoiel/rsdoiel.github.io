ITS Web Services
================
JavaScript Style Guide
----------------------

By R. S. Doiel <rsdoiel@usc.edu>

Based on Douglas Crockford's _JavaScript, the good parts_,
Nicholas Zakas' _Maintainable JavaScript_ and Daniel Clifford's 
[Breaking the JavaScript Speed Limit with V8](https://developers.google.com/events/io/sessions/gooio2012/224/)

Last Updated: Dec. 2013


## Coding Style Axioms

+ Write readable code
+ Write testable code
+ Write working code

These axioms help you create sustainable software and a style guide is intended to help you address the first axiom. 

Readability-- Code is read more than it is typed out.  It is read as you're typing it, you read it  when you fix bugs and you read some more when you modifiy it or need to determine how it works.  Reading code is a big part of writing software.  Sharing a common coding style helps readility by providing enough predictability that the reader can focus on the meaningful specifics of the code action.

Testability-- When you can test code you build trust in what the code does. The tests themselves show how the code can be used.  When you change codes that have sufficient tests you avoid introducing bugs that would cause a regression on effectiveness of the code. Finally writing tests first helps the developer debug and find problems early in the structure of the program they are building. If it is difficult to write the test then the problem is probably illunderstood. If the test gets complex then purhaps the code it is testing has too much functionality overloaded into it. Tests shouldn't be complicated. Writing test code can be as easy as using an assert function or writing an if statement.

Working code-- at the end of the day we're writing things for people to use, working code is what your custom experiences. Making it readable and testable helps you have working code.


## Our Style

For JavaScript jslint is a program that will analyze your source code and report back common
mistakes and help point you to best practices.  It'll also help your write readable code in
the sense that it can spot things like lazy variable declaration, inconstant indentation, 
dangerous coding practices.  When I code I run it through jslint to help keep it readable.
Beyond that there are a few more conventions I use.

+ Object Constructors start with a capital letter
+ Public function names use camel case
+ underscores help readability but I restrict them to variable and functions names that are not public
+ Global varables used to namespace an object are in all caps (e.g. YUI is a global variable of the YUI library)
+ variables used to index in a for loop are single letters (e.g. i, j, k, l, m)
+ variables are declared at the top of the function
+ "use strict" is included in the outer most name space (e.g. wrapping anonymous function)
+ filenames uses dashes instead of underscores to separate words
+ Open brackets at end of line, closing ones with start of line

Most of this can be achieved by using one of two jslint directives at the start of your JavaScript files (e.g. the browser directive or the NodeJS directive). jslint will warn you when you stray too far. When in doubt follow Douglas Crockford's [Code Conventions for JavaScript](http://javascript.crockford.com/code.html).  If you must depart from the code conventions be consistent in the manner you depart from it. Do so with specific purpose and not as an expression of personal taste or habit.

jslint can also be your first "test" of your code. After all if it is not readable you can't really fix it.


### the browser directive

```JavaScript
	/*jslint browser: true, sloppy: true, css: true,
	  indent: 4, maxcomplexity: 10, maxparams :4, maxdepth: 4, maxstatements: 100 */

```


### the NodeJS directive

```JavaScript
	/*jslint node: true, sloppy: true, css: false,
	  indent: 4, maxcomplexity: 10, maxparams :4, maxdepth: 4, maxstatements: 100 */
```

## Files and filenames

Filenames should be lowercase alphanumeric without spaces. Periods and dash characters are OK.
Underscore is OK when it is use to append the word "test" to the end of the file's basename.
JavaScript files should end in **.js**. Examples - **my-file.js** and **my-file_test.js**.

Referencing JavaScript in an HTML page should happen at the end of the body tag when possible.  Example -

```HTML
	<!DOCTYPE html>
	<html>
		<head>
			<title>Example HTML with JavaScript</title>
		</head>
		<body>
			<h1>Example HTML</h1>
			<p>blah, blah, blah</p>
			<!-- JavaScript files should go at the bottom of
			of the body tag -->
			<script src="js/myscript.js"></script>
		</body>
	</html>
```

## Comments and comment markup

At the head of each JavaScript file you need to have a name and description of what the JavaScript does.  It is recommended that you also include an @author line and copyright line showing USC's ownership of code written as a result of your employment at USC. If you are modifying an existing JavaScript file you can also include a @contributor or @updated line.

```JavaScript
	/**
	 * myProject.js - This file attaches a helloworld paragraph
	 * using DOM methods.
	 * @author Tina Trojan <tina.trojan@usc.edu>
	 * @updated Tommy Trojan <ttrojan@usc.edu>, 2012-07-10
	 *
	 * copyright © 2012 University of Southern California
	 */
```

alternately like-

```JavaScript
	//
	// myProject.js - This file attaches a helloworld paragraph
	// using DOM methods.
	// @author Tina Trojan <tina.trojan@usc.edu>
	// @updated Tommy Trojan <ttrojan@usc.edu>, 2012-07-10
	//
	// copyright © 2012 University of Southern California
	//
```

Using comment markup allows document extractors like jsdoc to yuidoc to create source code
documentation straight from the code itself.  This can be very helpful on larger projects when
you get into 1000 of lines of code.


### Testable code

Tests can be simplistic. At a minimum they confirm an exposed function exists and returns a valid result for expected input.  It helps to write tests first rather than after the fact. If you are writing code which will run under NodeJS then use the **assert** module.  If you are writing browser you can easily create your own "assert" functions.  Here's some examples

```javascript
    function Assert () {
        return {
            ok: function (expr, msg) {
                if (! expr) {
                    throw msg;
                }
            },
            isTrue: function (expr, msg) {
                if (!expr) {
                    throw msg;
                }
            },
            isFalse: function (expr, msg) {
                if (expr) {
                    throw msg;
                }
            },
            isEqual: function (expr1, expr2, msg) {
                if (expr1 != expr2) {
                    throw msg;
                }
            },
            isNotEqual: function (expr1, expr2, msg) {
                if (expr1 == expr2) {
                    throw msg;
                }
            },
            strictIsEqual: function (expr1, expr2, msg) {
                if (expr1 !== expr2) {
                    throw msg;
                }
            },
            strictIsNotEqual: function (expr, msg) {
                if (expr1 === expr2) {
                    throw msg;
                }
            }
        };
    }
```

Here's an example if using the previous **Assert** object.

```JavaScript
    var assert = new Assert();
    
    assert.ok(true, "This message should not show up!");
    assert.ok(false, "This message should throw and error!");
```


Here's an example of a simple test using the [assert-this.js](https://raw.github.com/rsdoiel/assert-this/master/assert-this.js) library.

**my-lib\_test.js** would look like.

```JavaScript
	// my-lib_test.js - Tests for my_lib.js. Blah, blah, blah
	// my-lib_test.html loads my_lib.js before running these
	// tests
	//
	// @author George Tirebiter <george.tirebiter@usc.edu>
	// copyright © 2012 University of Southern California
	
	// testMyFunc should add two numbers.
	assert.equal(myAdd(1,1), 2, "1 + 1 should equal two.");
```

**my-lib\_test.html** would look like-

```HTML
	<!DOCTYPE html>
	<html>
		<head>
			<title>Test my_lib.js</title>
		<head>
		<body>
			<h1>Running tests for my_lib.js</h1>
			<h2>Loading assert-this.js</h2>
			<script src="assert-this.js"><script>
			<h2>Loading my_lib.js</h2>
			<script src="my_lib.js"></script>
			<h2>Loading my_lib_test.js</h2>
			<script src="my_lib_test.js"></script>
			<h2>Loading complete</h2>
		</body>
	</html>
```

**my-lib.js** might look like this-

```JavaScript
	// my_lib.js - provide shorthand math function for
	// style guide demo.
	// @author George Tirebiter <george.tirebiter@usc.edu>
	// copyright © 2012 University of Southern California
	
	var myAdd = function (a, b) {
		return a + b;
	};
```

If you put **my-lib.js**, **my-lib\_test.js** and **my-lib\_test.html** a web server your and point your browser at **my-lib\_test.html**. You should not be able to run your test.

If you build your tests to run under Node then you don't need **my-lib\_test.html** and **my-lib\_test.js** will look a little different.

```JavaScript
	// my_lib_test.js - tests for my_lib.js. Tests require Node
	// @author George Tirebiter <george.tirebiter@usc.edu>
	// copyright © 2012 University of Southern California
	
	var assert = require("assert"),
		my_lib = require("./my_lib");
	
	// Test that my_lib.myAdd() works
	assert.equal(my_lib.myAdd(1,1), 2, "1 + 1 should equal two.");
```


## Indentation

Prefer tabs unless you feed strongly. If you use spaces use 4 spaces to indent. Do not use both tabs and spaces in the same file. jslint is good at catching this problem.


## Naming variable, functions and objects

Public variables and functions names should use camel case (e.g. myFunctions, myVar). If they
are private (e.g. not used outside the module or constrained by a closure) they can be written
using an underscore (e.g. my_inside_private_function, my_private_inner_variable). This helps
quickly identify what is the public contract of the object.

If the function is a object constructor or factory it should be capitalized (e.g. MyObjectConstructor). This helps indentify those things created using the "new" JavaScript 
keyword (e.g. @var my_thingy = new Thingy();@).

If an Object or variable is in the global scope, or is a constant then use all caps (e.g. _var USC = {};_ or _var PI = 3.14159265359;_ ).

### Use strict mode

Since we're still supporting legacy JavaScript engines we should always use the "use strict" directive in the enclosing function or module definition. This helps us write future proof
JavaScript and avoid some of JavaScript's older implementation issues.

### Browser example

```JavaScript
	// Here is an object we've named USC and push safely
	// into the global scope.
	(function (global_scope) {
        "use strict";
		var USC = {
			counter: 1,
			inc: function (i) {
				if (i === undefined) { i = 1; }
				this.counter += i;
				return this.counter;
			}
		};
		global_scope.USC = USC;
	}(this));
```


### Node example

```JavaScript
    "use strict";
	// Here is an object we've named USC and exported
	// for use by other node programs and modules.
	var USC = {
		counter: 1,
		inc: function (i) {
			if (i === undefined) { i = 1; }
	
			this.counter += i;
			return this.counter;
		}
	};
	
	exports.USC = USC;
```


### Multi-word variables

A common practice when picking variable and function names to use two or more words. This helps avoid keyword collisions. If they will be used in an outer scope then use camelcase. If they are strictly limited to an inner scope then you can use underscores if you like. Underscores also work nicely for parameter names.

```JavaScript
	// Here is an inner and outer variable declaration.
	USC.docCount = 1;
	
	// Functions are worthy of their own "var" line
	// so the closing brace lines up with the opening "var"
	USC.myFunc = function (multiply_me) {
		var my_local_var = 2;
		if (multiply_me === undefined) {
		   return this.docCount * my_local_var;
		} else {
		   return this.docCount * multiply_me;
		}
	};
```


### Single letter variable names

Avoid using single letter variables unless they are counters in a local scope or tempory strings restricted to local scope.  Always initialize them.

```JavaScript
	(function (global_scope) {
		var i = 0, USC = { count: 0 };
	
		for (i = 0; i < 5; i += 1 ) {
			console.log("i is now:", i);
		}
	
		USC.count = i;
		global_scope.USC = USC;
	}(this));
```


## Strings and quoting

Declare your strings as object literals. Favor single quotes.  For either single or double quotes try to be consistant. Avoid concatenated strings (e.g. strings assembled with the plus operator)
that mix single and double quotes.

```JavaScript
    // these are all OK
	var string1 = 'Hello World',
		string2 = 'Jane said, "Hello World"',
		string3 = 'Jane\'s, "friend" said, "It gets complicated' +
			' sometimes."',
		string4 = "Jane's friend is Mary. Mary's claim is" +
			" \"I agree it gets complicated but...\". Since we " +
			"have single quotes too we're just going to escape " +
			" the double ones.";
```

Try to avoid sequences of quotes that are hard to read. E.g.
	
```JavaScript
	var hard_to_read = "\"...\"" +
                      '\'"+"\'...+\'' +
                      "= \"'hard to_read\"'";
```


## Braces

Braces need to match. Normally the opening brace should be at the end of the line and the closing brace should match the indentation of the line which contained the opening one.


#### If, else and switch

```JavaScript
	// Multi-line if/else, opening brace at end of line,
	// closing brace aligns with the if
	if (something === true) {
		console.log("Something is true");
	} else {
		console.log("Something was not true");
	}
	
	// Single line statements, opening brace not at the end.
	if (something === true) { console.log("Something is true"); }
	
	// If/else on two lines
	if (something === true) { console.log("Something is true"); }
	else { console.log("Something was not true"); }
	
	// And here's an example of a switch statement.
	// modern way
	switch (somevar) {
	case true:
		console.log("Something is true");
		break;
	default:
		console.log("Maybe not");
		break;
	}
	
	// More traditionally
	switch (somevar) {
		case true:
			console.log("Something is true");
			break;
		default:
			console.log("Maybe not.");
			break;
	}
```


## Arrays

When possible declare an array using an object literal. If they can be pre-populated do so. Store the same type of data in the array when possible. Don't use an array to store key/value pairs. 

```JavaScript
	// This is OK
	var myArray = [],
		aBetterArray = [1, 2, 3, 4, 5],
		okButLessEfficientArray = ["fred", 36, true];
	
	// Do not do these things to arrays:
	// * Assuming myArray.length is 0 adding something at
	//   position 1000 will cause the array to be converted
	//   to an object (i.e. you're creating gaps in the array).
	// * Using a string as an index is also bad because
	//   you're coercing the array into an Object.
	myArray[1000] = "Added beyond the end of the array";
	myArray["one"] = "making the index a string is a bad thing.";
```

Well formed arrays tend to have faster access than an object. Converting arrays types to object types uses CPU and memory.  At a minimum you'll slow things down, worse is that it is very easy to have things misbehave.


## Functions

Favor the modern function definition.  If you are going to use your constructor with the "new" keyword then use the older style function definition capitalizing the funciton name.  Function names which are NOT a constructor should be camelcase.  These are all acceptable examples of
defining functions.

```JavaScript
	// This is a constructor
    function MyThing() {
        return {
            helloWorld: function () {
                console.log("Hello World!");
            }
        };
    }
    
    // This is a function and a object instance declaration.
	var myAdd = function (a, b) {
			return a + b;
		},
        thatThing = new MyThing();

    // This is defining the myAdd method on thatThing 
    thatThing.myAdd = myAdd();
```


## Objects

The preferred method of creating an object is with an object literal.

```JavaScript
	// Best if you can use object literal notation
	var myObject = {
			name: "Tina Trojan",
			email: "tina.trojan@usc.edu",
			setName: function (name) {
				this.name = name;
		   },
			setEmail = function (email) {
			   this.email = email;
		   },
			displayName: function () { console.log(this.name); },
			displayEmail: function () {
				console.log(this.email);
			}
		};
	
	// Here's the object created
	console.log(myObject);
	
	// Second best using a constructor and new.
	// Constructors should have a capitalized first letter.
	var myObject;
	
	function MakeObject () {
		var self = {
			name: "Tina Trojan";
			email: "tina.trojan@usc.edu";
			setName: function (name) {
				this.name = name;
			},
			setEmail: function (email) {
				this.email = email;
			},
			displayName: function () {
				console.log(this.name);
			},
			displayEmail: function () {
				console.log(this.email);
			}
		};
		return self;
	};
	
	myObject = new MakeObject();
	
	// Here's the myObject created with the constructor approach
	console.log(myObject);
	
	
	// If you want to use prototypes for inheritance then
	// use this style.
	var myObject, MakeObject;
	
	MakeObject = function () {
		this.name = "Tina Trojan";
		this.email = "tina.trojan@usc.edu";
	};
	MakeObject.prototype.setName = function (name) {
		this.name = name;
	};
	MakeObject.prototype.setEmail = function (email) {
		this.email = email;
	};
	MakeObject.prototype.displayName = function () {
		console.log(this.name);
	};
	MakeObject.prototype.displayEmail = function () {
		console.log(this.email);
	};
	myObject = new MakeObject();
	
	// Here's myObject created using the prototype approach
	console.log(myObject);
	
	// An object factory might look like
	var USC = {
		// This is the factory
		create: function () {
			var Self = function () {};
			Self.prototype.hello = function () {
				if (typeof alert === "undefined") {
					console.log("Hello World!");
				} else {
					alert("Hello World!");
				}
			};
			return new Self();
		}
	}, localObj;
	
	// Now use USC's factory to create new objects.
	localObj = USC.create();
```


## Comments

Comments are good when they increase understanding.  They generally are needed in three cases-

* Explaining complicated code when the code cannot be simplified to be more readable
* Serve as a hook for navigating through the source code (e.g. a
  comment at the end of a block that is longer than the screen)
* Serve as a hook for documentation generation in literate programming

Clear code is always preferable to comments because it conveys explicitly what you are expecting the computer to do.


## Node specific style

Node programs should start with a "Bang" line followed by a comment block. Node modules don’t need the bang line.  The bang line should use the Unix env program to locate the preferred version of Node (or other JS environment) you’re using.  The comment block should include the name of the file, author/updater information and the USC copyright block. E.g. 

```JavaScript
	#!/usr/bin/env node
	//
	// myprogram.js - this is a demo program to show formatting
	//
	// @author: Tina Trojan <tina.trojan@usc.edu>
	// @updates: Tommy Trojan <tommy.trojana@usc.edu>
	//
	// copyright © 2012 all rights reserved
	// University of Southern California
	//
```

This should be followed by all the required modules needed. Order the modules by being part of Node’s core, then well supported 3rd party modules and finally custom modules supported by your application or other USC Web Services projects. E.g.

```JavaScript
	// Core modules (fs, path), 3rd project modules (opt), then
	// local modules (myproj)
	var fs = require("fs"),
		path = require("path").
		opt = require("opt"),
		t1 = require("./t1"),
		t2 = require("./t2");
	
	var myObj = t1.create();
```

You can also group those with separate var blocks if the list is long.

After opening comments and modules you can include variables global to your application or module, utility methods and general object constructors and method assignment.  Literally definitions is generally preferred per Crockford's JavaScript the Good Parts.  Here's several examples still allowing for a wide range of expressiveness.

```JavaScript
	//
	// t1.js - example module styled (declarative oriented)
	//
	var self = {
		inc: function (amount) {
			if (this._counter === undefined) {
				this._counter = 0;
			}
			if (amount === undefined) {
				amount = 1;
			}
	
			this._counter += amount;
			return this._counter;
		},
		create: function () {
		  var newObj = {};
	
			// Now build the custom object.
			newObj.inc = this.inc;
			return newObj;
		}
	};
	
	// If node export the create function
	/*jslint undef:true */
	if (exports === undefined) {
		exports.create = self.create;
	}
	/*jslint undef:false */
```
Or

```JavaScript
	//
	// t2.js - example node module in a more
	// functional oriented style
	//
	"use strict";
	
	var inc = function (amount) {
		if (this._counter === undefined) {
			this._counter = 0;
		}
		if (amount === undefined) {
			amount = 1;
		}
	
		this._counter += amount;
		return this._counter;
	};
	
	var create = function () {
		var NewObj = function () {
			this.inc = inc;
		};
	
		return new NewObj();
	};
	
	exports.inc = inc;
	exports.create = create;
```

finally-

```JavaScript
	//
	// t3.js - example module styled (more prototype oriented)
	//
	"use strict";
	
	var create = function () {
		var self = this.prototype;
	
		self.prototype.counter = 0;
	
		self.prototype.inc = function (amount) {
			if (this.counter === undefined) {
				this.counter = 0;
			}
			if (amount === undefined) {
				amount = 1;
			}
	
			this.counter += amount;
			return this.counter;
		};
	
		return new self();
	};
	
	exports.create = create;
```


### Browsers

Here is an example of using a anonymous function wrapper and exposing a USC object globally-

```JavaScript
	// t4.js - Global object safely exposed style.
	// Each object is initialized from the global
	// USC object each time create() is invoked but
	// the created objects maintain independent counter
	// and amount properties.
	(function (global_scope) {
		"use strict";
		// Object literal used to defined usc
		var USC = {
			// counter and amount are shared
			counter: 0,
			amount: 1,
			create: function () {
				var self = this, obj = {
					// Initialize from the main USC object
					counter: self.counter,
					amount: self.amount,
					inc: function (amount) {
						if (amount === undefined) {
							this.counter += this.amount;
						} else {
							this.counter += amount;
						}
						return this.counter;
					}
				};
	
				return obj;
			}
		};
	
		// USC is passed to the global scope.
		global_scope.USC = USC;
	}(this));
```

