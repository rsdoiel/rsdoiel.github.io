---
title: Build a Static Web Server with Deno
author: R. S. Doiel
byline: R. S. Doiel
abstract: |
  This post discusses static web server implementation using Deno.
dateCreated: '2025-06-30'
pubDate: 2025-06-30T00:00:00.000Z
dateModified: '2025-07-23'
series: Deno and TypeScript
number: 8
keywords:
  - web service
  - static web site
  - JavaScript
copyright: 'copyright (c) 2025, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2025
copyrightHolder: R. S. Doiel
datePublished: '2025-06-30'
seriesNo: 8
---

# Build your own static web server with Deno

One of things I have in my web toolbox is a static site web server. It only runs on localhost. It amazes me how often I wind up using it. PHP and Python can launch one easily from the command line but I have always found they were lacking. What I want is a simple web server that runs only on localhost. It can serve content from a specified directory and should handle common content types appropriately (e.g. JavaScript files are served as "application/javascript" not as "text/plain"). I should be able choose the port the server runs on. I should be able to specify a document root for the content I want to expose. It should default to a sensible location like the "htdocs" directory in my current working directory.

When I started working with the web (when people used the NCSA web server), web servers were considered complex and hard to implement. I remember most network systems were presumed complex. Today most programming languages have some sort of library, module or package that makes implementing a web server trivial. This is true for JavaScript running under a JavaScript run time engine.

Deno is a JavaScript and TypeScript runtime. I prefer Deno over other JavaScript runtimes like NodeJS. Deno runs sandboxed. This is similar to how the web browser treats JavaScript. Deno's standard library aligns with web browser implementation too. Deno has a good set of standard modules. Many modules can also be used browser side. 

I'll be using some Deno standard JavaScript modules in this post. The standard module "@std/http/file-server" provides most of what you need to implement a static content server. Two other modules will round things out in how I want my web server to behave. They are "@std/fs/exists" and "@std/yaml/parse".

Let's build a simple but useful static web server and add it to our web toolbox.

Before I build my static web server I need some web content. I'm going to need an HTML file and a JavaScript file. This will provide content to test. The web content should be created in a directory called "htdocs". On macOS, Linux and Windows the command I run from in the terminal application to create the "htdocs" directory is `mkdir htdocs`. Using your my editor, I created the HTML file called "helloworld.html" inside the "htdocs" directory.

~~~html
<!DOCTYPE html>
<head>
  <script type="module" src="helloworld.js"></script>
</head>
<html lang="en-US">
  <body>Hello World</body>
</html>
~~~

I created a "helloworld.js" inside the "htdocs" directory too.

~~~JavaScript
const body = document.querySelector("body");
const elem = document.createElement("div");
elem.innerText = 'Hello World 2!';
body.append(elem);
~~~

This provides content to test my prototypes. Using these files I can make sure the prototype properly serves out a web page, handles a file listing and properly services the JavaScript.

Your directory tree should look something like this.

~~~shell
tree htdocs
htdocs/
├── helloworld.html
└── helloworld.js

1 directory, 2 files
~~~

## First prototype

Using a text editor, I create a file called `webserver_v1.js`. I need to do several things in JavaScript to build our static web server.

1. import a function called `serveDir` from the "@std/http/file-server" module
2. I need to set two constants, a port number and a root document path
3. It is helpful to display the setting for the port and document root when the server starts up
4. I can using Deno's built in `serve` method to handle inbound requests and then dispatch them to `serveDir`

Let's start with the import, `"@std/http/file-server`.  Notice that it starts with and "@". This indicates to the JavaScript runtime that the full URL to the module is defined by an import map. When you build a Deno project you can generate a file called `deno.json`. It can include an import map. The `deno add` command provides a really easy way to manage this mapping. As of Deno 2 the standard modules are available from [jsr.io](https://jsr.io), a reliable JavaScript registry. This includes our standard module `@std/http/file-server`. I can "add" it  to my project using the following command.

~~~shell
deno add jsr:@std/http/file-server
~~~

If the "deno.json" file does not exist this command will create it. If it does exist Deno will update it to reflect the new module. I can look inside the "deno.json" file after running this command and see my import map.

~~~json
{
  "imports": {
    "@std/http": "jsr:@std/http@^1.0.18"
  }
}
~~~

The Deno runtime knows how to contact jsr.io and use it to retrieve the module requested.  By default it picks the current stable version. In my case that is v1.0.18. Deno updates happen pretty steadily through out the year. When I try this a month from now it'll probably be a different version number.

Now that Deno is setup, I need to write my first prototype static web server.

~~~JavaScript
/**
 * webserver_v1.js - A simple static file server for serving files from the "htdocs" directory.
 */
import { serveDir } from "@std/http/file-server";

const port = 8000;
const rootPath = "htdocs"; // Serve files from the "htdocs" directory

console.log(`Server running on http://localhost:${port}/, serving ${rootPath}`);

// Start a simple server
Deno.serve({
  port,
}, async (req) => {
  try {
    // Serve files from the specified directory
    return await serveDir(req, {
      fsRoot: rootPath,
      urlRoot: "",
      showDirListing: true,
      showDotfiles: false, // Exclude files starting with a period
    });
  } catch (err) {
    console.error(err);
    // Return a 404 response if something goes wrong
    return new Response("404: Not Found", { status: 404 });
  }
});
~~~
 
The `Deno.serve` manages the inbound request and the async anonymous function handles the mapping to the file server module function called `serveDir`. A try catch wraps the `serveDir` function. If that function fails a 404 response is created and returned. Pretty simple.

Let's see if the code we typed in works. Deno provides three helpful commands for working with your program code 

1. check 
2. lint
3. fmt

Check reads the JavaScript (or TypeScript) file and makes sure it makes sense from the compilation point of view.  The lint command goes a step further. It checks to see if best practices have been followed. Lint is completely optional but check needs to pass before Deno will attempt to run or compile the program. The `fmt` command will format your source code in a standard way. I'm going to use check and lint.

~~~shell
deno check webserver_v1.js
deno lint webserver_v1.js
~~~

All went well. In both cases I see a line indicating it checked the file. If I had made errors check and lint would have complained and included lines describing errors.

Deno can run our JavaScript and TypeScript files. To test my program I try the following. 

~~~shell
deno run webserver_v1.js
~~~

When I tried this I saw the following message. 

~~~shell
Server running on http://localhost:8000/, serving htdocs
┏ ⚠️  Deno requests net access to "0.0.0.0:8000".
┠─ Requested by `Deno.listen()` API.
┠─ To see a stack trace for this prompt, set the DENO_TRACE_PERMISSIONS environmental variable.
┠─ Learn more at: https://docs.deno.com/go/--allow-net
┠─ Run again with --allow-net to bypass this prompt.
┗ Allow? [y/n/A] (y = yes, allow; n = no, deny; A = allow all net permissions) > 
~~~

I type "y" and press enter. New lines appear.

~~~shell
Server running on http://localhost:8000/, serving htdocs
✅ Granted net access to "0.0.0.0:8000".
Listening on http://0.0.0.0:8000/ (http://localhost:8000/)
~~~

I point my web browser to "http://localhost:8000/". Do I see anything? No. In my terminal window I see another prompt about permissions.

~~~shell
┏ ⚠️  Deno requests read access to "htdocs".
┠─ Requested by `Deno.stat()` API.
┠─ To see a stack trace for this prompt, set the DENO_TRACE_PERMISSIONS environmental variable.
┠─ Learn more at: https://docs.deno.com/go/--allow-read
┠─ Run again with --allow-read to bypass this prompt.
┗ Allow? [y/n/A] (y = yes, allow; n = no, deny; A = allow all read permissions)
~~~

Again answer "y". I then see something this in my terminal window.

~~~shell
[2025-06-30 16:27:31] [GET] / 200
No such file or directory (os error 2): stat '/Users/rsdoiel/Sandbox/Writing/Books/A_Simple_Web/htdocs/favicon.ico'
[2025-06-30 16:27:31] [GET] /favicon.ico 404
~~~

I reload my web browser page, what do I see? A list of files. I know that file directory listing works.
One of the files is "helloworld.html".  I click on it. I my simple web page with the words "Hello World" and "Hello World 2". Yippee, I've created a static web server.

You might be wondering how I shutdown the web server. In the terminal window I press control and the letter c, aka "Ctrl-C". This will shuts down the web server. I can confirm it is shutdown in the web browser by reloading the page. I see an connection error page now.

I don't want to answer questions about permissions each time I run my prototype. I can specify the permissions I want to grant on the command line.  I know from my test that my program needs "net" and "read" permissions. I can grant this using the following command.

~~~shell
deno run --allow-net --allow-read webserver_v1.js
~~~

Better yet I can compile our JavaScript program into an executable file. An executable is handy because I can run it without Deno being installed on a different computer as long as it runs the same operating system and has the same CPU type. Compiling to an executable makes this prototype similar to our tools in my web tool box. It let's me treat it just like my terminal application, text editor and web browser.

~~~shell
deno compile --allow-net --allow-read webserver_v1.js
~~~

This results in a file being created called "webserver_v1" (or on Windows, "webserver_v1.exe"). This file can be run from this directory or moved to another directory where I store other programs (e.g. `$HOME/bin` or `$HOME\bin` on Windows).

## Improving on v1

While webserver_v1.js is helpful it could be more friendly. What if I want to use a different port number? What if I want to server out content my current directory or maybe I want to service content on a different mounted drive? I can do that by adding support for command line arguments.

~~~JavaScript
/**
 * webserver_v2.js - A simple static file server with configurable port and root directory.
 */
import { serveDir } from "@std/http/file-server";

const defaultPort = 8000;
const defaultRoot = "htdocs";

// Parse command-line arguments
const args = Deno.args;
let rootPath = defaultRoot;
let port = defaultPort;

// Check the command arguments and set the port and rootPath appropriately
if (args.length > 0) {
  // Check if the first argument is a port number
  const portArg = parseInt(args[0], 10);
  if (!isNaN(portArg)) {
    port = portArg;
  } else {
    // If not a port number, assume it's the root path
    rootPath = args[0];
  }

  // Check if the second argument is a root path
  if (args.length > 1) {
    rootPath = args[1];
  }
}

console.log(`Server running on http://localhost:${port}/, serving ${rootPath}`);

// Start a simple server
Deno.serve({
  port,
}, async (req) => {
  try {
    // Serve files from the specified directory
    return await serveDir(req, {
      fsRoot: rootPath,
      urlRoot: "",
      showDirListing: true,
      showDotfiles: false, // Exclude files starting with a period
    });
  } catch (err) {
    console.error(err);
    // Return a 404 response if something goes wrong
    return new Response("404: Not Found", { status: 404 });
  }
});
~~~

I can compile that using the following deno compile command

~~~shell
deno compile --allow-net --allow-read webserver_v2.js
~~~

We can run the new webserver using the following command.

~~~shell
./webserver_v2 8001 .
~~~

Point the web browser at <http://localhost:8001>. What do I see the directory? Yep, I see the files in my root directory of my project including the "htdocs" directory I created. Can I find and display "helloworld.html"? Yep and it works as in the first prototype. I shutdown the web server and then start it again using just the executable name.

macOS and Linux

~~~shell
./webserver_v2
~~~

on Windows

~~~shell
.\webserver_v2
~~~

What do you see? Can you find "helloworld.html"? Stop the web server. I copy "helloworld.html" to "index.html". After copying I restart the web server again.

On macOS and Linux

~~~shell
cp htdocs/helloworld.html htdocs/index.html
./webserver_v2
~~~

On Windows

~~~pwsh
copy htdocs\helloworld.html htdocs\index.html
.\webserver_v2
~~~

I point the web browser at <http://localhost:8000>, what do I see? I don't see the file directory any more, I see the contents of  I copied into the "index.html" file, "Hello World" and "Hello World 2".

Can this be improved?  It'd be nice to web able to just type "webserver_v2" and have the program using a default port and htdocs directory of my choice. That can be supported by using a configuration file. YAML is an easy to read and easy to type notation. It even supports comments which is nice in configuration files. YAML expresses the same types of data structures as JSON (JavaScript Object Notation). Below an example of a configuration file. I type it in and save it using the filename "webserver.yaml".

~~~yaml
# Set root path for web content to the current directory.
htdocs: .
# Set the port number to listen on to 8002
port: 8002
~~~

From the point of the view of my prototype it'll need to check if the "webserver.yaml" file exists before attempting to read it. Deno has a module for that. It'll also need to read the YAML, parse it and get an object that exposes my preferred settings. Deno has a standard model for working with YAML too. The modules I'm interested in are `@std/fs/exists` and `@std/yaml`. I'll need to "add" them to my deno project.

~~~shell
deno add jsr:@std/fs/exists
deno add jsr:@std/yaml
~~~

Time for an improved version of the static web server. This prototype should be called, "webserver_v3.js".

~~~JavaScript
/**
 * webserver_v3.js - A simple static file server with configurable port and root directory via YAML.
 */
import { serveDir } from "@std/http/file-server";
import { parse } from "@std/yaml/parse";
import { exists } from "@std/fs/exists";

const defaultPort = 8000;
const defaultRoot = "htdocs";

// Function to read and parse YAML configuration file
async function readConfigFile(filePath) {
  try {
    const fileContent = await Deno.readTextFile(filePath);
    return parse(fileContent);
  } catch (err) {
    console.error("Error reading or parsing YAML file:", err);
    return null;
  }
}

// Parse command-line arguments
const args = Deno.args;
let rootPath = defaultRoot;
let port = defaultPort;

if (args.length > 0) {
  // Check if the first argument is a port number
  const portArg = parseInt(args[0], 10);
  if (!isNaN(portArg)) {
    port = portArg;
  } else {
    // If not a port number, assume it's the root path
    rootPath = args[0];
  }

  // Check if the second argument is a root path
  if (args.length > 1) {
    rootPath = args[1];
  }
} else {
  // Check for YAML configuration file
  const configFilePath = "webserver.yaml";
  if (await exists(configFilePath)) {
    const config = await readConfigFile(configFilePath);
    if (config) {
      rootPath = config.htdocs || defaultRoot;
      port = config.port || defaultPort;
    }
  }
}

console.log(`Server running on http://localhost:${port}/, serving ${rootPath}`);

// Start a simple server
Deno.serve({
  port,
}, async (req) => {
  try {
    // Serve files from the specified directory
    return await serveDir(req, {
      fsRoot: rootPath,
      urlRoot: "",
      showDirListing: true,
      showDotfiles: false, // Exclude files starting with a period
    });
  } catch (err) {
    console.error(err);
    // Return a 404 response if something goes wrong
    return new Response("404: Not Found", { status: 404 });
  }
});
~~~

Like before I compile it with the my desired permissions.

~~~shell
deno compile --allow-net --allow-read webserver_v3.js
./webserver_v3
~~~

I point the web browser at <http://localhost:8002>. What do I see? I see the contents of the index.html file. Can I display "helloworld.html" too? Yep. I remove the "index.html" file, then use my browser back button to go to the initial URL, yep I see a file directory listing again. Looks like this prototype works.

I think I have a useful localhost static content web server. It's time to rename my working prototype, compile and install it so it is available in my toolbox.

1. Copy `webserver_v3.js` to `webserver.js` 
2. Use `deno compile` to create an executable
3. Create a "$HOME/bin" directory if necessary
4. Move the executable to a location in the executable PATH with, example "$HOME/bin"
5. Try running the program

NOTE: If you are following along and have to create "$HOME/bin" then you may need to added to your environment's PATH.

On macOS and Linux

~~~shell
cp webserver_v3.js webserver.js
deno compile --allow-net --allow-read webserver.js
mkdir -p $HOME/bin
mv ./webserver $HOME/bin
webserver
~~~

On Windows

~~~shell
copy webserver_v3.js webserver.js
deno install --global --allow-net --allow-read webserver.js
New-Item -ItemType Directory -Path "$HOME\bin" -Force
move webserver.exe $HOME\bin\
webserver
~~~

There you have it. I have a new convenient static web server for serving static content on localhost.