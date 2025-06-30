---
title: Build a Static Web Server with Deno
author: R. S. Doiel
byline: R. S. Doiel
abstract: |
  This chapter demonstrates how to build a static web server using Deno.
dateCreated: 2025-06-30
pubDate: 2025-06-30
dateModified: 2025-06-30
series: Deno and TypeScript
number: 8
keywords:
  - web service
  - static web site
copyright: copyright (c) 2025, R. S. Doiel
license: https://creativecommons.org/licenses/by-sa/4.0/
---

# Build your own static web server with Deno

One of things I have in my web toolbox is a static site web server. It only runs on localhost. It amazes me how often I wind up using it. PHP and Python can launch one easily from the command line but I have always found they were lacking. What I want is a simple web server that runs only on localhost. It can serve content from a specified directory and should handle common content types appropriately (e.g. JavaScript files are served as "application/javascript" not as "text/plain"). I should be able choose the port the server runs on. I should be able to specify a document root for the content I want to expose. It should default to a sensible location like the "htdocs" directory in my current working directory.

Deno is a JavaScript and TypeScript runtime. I prefer Deno for several reasons over other runtimes like NodeJS. First Deno runs sandboxed similar to the web browser. Deno's standard library follows browser where there is overlap between running on your machien versus the browser. Deno good set  of standard modules. This includes "@std/http/file-server" which I'll use to create a static site web server. Other modules I'll be using are "@std/fs/exists" and "@std/yaml/parse". Normally when I write for Deno I write TypeScript but for this article I'm going to use plain old JavaScript.

Let's build a simple but useful static web server for our web toolbox.

Before we build our static web server some web content, an HTML file. Create a directory "htdocs" directory. On macOS, Linux and Windows the command we want to run in the terminal is `mkdir htdocs`. Using your text editor, create the HTML file called "helloworld.html" inside the "htdocs" directory.

~~~html
<!DOCTYPE html>
<head>
  <script type="module" src="helloworld.js"></script>
</head>
<html lang="en-US">
  <body>Hello World</body>
</html>
~~~

Now let's create a "helloworld.js" inside the "htdocs" directory too.

~~~JavaScript
const body = document.querySelector("body");
const elem = document.createElement("div");
elem.innerText = 'Hello World 2!';
body.append(elem);
~~~

This will give us some content to test with.

Your directory tree shoud look something like this.

~~~shell
tree htdocs
htdocs/
├── helloworld.html
└── helloworld.js

1 directory, 2 files
~~~

I'll use these two files to for tesitng the web server.

## First take

Using a text editor, create a file called `webserver_v1.js`. We need to do several things in JavaScript to build our static web server.

1. import a function called `serveDir` from the "@std/http/file-server" module
2. We need to set two constants, our port number and root document path
3. It is helpful to display the setting for the port and document root
4. We can using Deno's built in `serve` method to handle inbound requests and then dispatch them to `serveDir`

Let's start with our import, `"@std/http/file-server`.  Notice that it starts with and "@". This indicates to the JavaScript runtime that the full URL to the module is found in a import map. When you build a Deno project you can use a file called `deno.json` to include a mapping of module names. The `deno` command provides a really easy way to manage this mapping. As of Deno 2 the standard modules are available from [jsr.io](https://jsr.io), a JavaScript registry. The module `@std/http/file-server` is part of the standard module package called `@std/http`. We can "add" that to our project using the following command

~~~shell
deno add jsr:@std/http
~~~

If the "deno.json" file does not exist this command will create it. If you look inside it after running this command you'll see something like this.

~~~json
{
  "imports": {
    "@std/http": "jsr:@std/http@^1.0.18"
  }
}
~~~

The Deno run time knows how to contact jsr.io and use it to etrieve the module requested.  By default it picks the current stable version. In our case that is currently v1.0.18. If you are reading this is in the distant the future is the version number will likely have changed. Deno updates have come pretty steadly in 2025.

Now that that Deno is setup, I need to write our first version of a static web server.

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

Let's see if the code we typed in works. Deno provide two helpful commands. 

1. check 
2. lint

Check read the JavaScript (or TypeScript) file and makes server it makes sense from the compilation point of view.  The lint command goes a step further. It checks to see if best practices have been followed. Lint is completely optional but check needs to pass before Deno will attempt to run our program.

~~~shell
deno check webserver_v1.js
deno lint webserver_v1.js
~~~

If all went well in both cases you should see a line indicating it checked the file. If there are complaints you'll see those too.

Deno can run in interactive mode. To test our program we'll initially run it. 

~~~shell
deno run webserver_v1.js
~~~

You should a message like the one below. This is because Deno wants permission to access the network.

~~~shell
Server running on http://localhost:8000/, serving htdocs
┏ ⚠️  Deno requests net access to "0.0.0.0:8000".
┠─ Requested by `Deno.listen()` API.
┠─ To see a stack trace for this prompt, set the DENO_TRACE_PERMISSIONS environmental variable.
┠─ Learn more at: https://docs.deno.com/go/--allow-net
┠─ Run again with --allow-net to bypass this prompt.
┗ Allow? [y/n/A] (y = yes, allow; n = no, deny; A = allow all net permissions) > 
~~~

For can type an "y" for now. Now you should see a lines like those below.

~~~shell
Server running on http://localhost:8000/, serving htdocs
✅ Granted net access to "0.0.0.0:8000".
Listening on http://0.0.0.0:8000/ (http://localhost:8000/)
~~~

Point your web browser to "http://localhost:8000/". Do you see anything?  In your terminal window you'll see another prompt about permissions.

~~~shell
┏ ⚠️  Deno requests read access to "htdocs".
┠─ Requested by `Deno.stat()` API.
┠─ To see a stack trace for this prompt, set the DENO_TRACE_PERMISSIONS environmental variable.
┠─ Learn more at: https://docs.deno.com/go/--allow-read
┠─ Run again with --allow-read to bypass this prompt.
┗ Allow? [y/n/A] (y = yes, allow; n = no, deny; A = allow all read permissions)
~~~

Again answer "y". You then see something like this in the terminal window.

~~~shell
[2025-06-30 16:27:31] [GET] / 200
No such file or directory (os error 2): stat '/Users/rsdoiel/Sandbox/Writing/Books/A_Simple_Web/htdocs/favicon.ico'
[2025-06-30 16:27:31] [GET] /favicon.ico 404
~~~

What do you do you see in the browser page?  Is it a list of files? Is one of them "helloworld.html"?  If so click on it. You should now see an simple web page with the words "Hello World". Congratulations, you've created your first static web server.

You might be wondering how to shutdown the web server. In the terminal window press control and the letter c, aka "Ctrl-C". This will shutdown the web server. You can confirm it is shutdown in the web browser by reloading the page.

You don't need to answer questions about permissions each time you run a program. You can specify the permissions you want to grant on the command line.  I know from our test that our program needs a "net" and "read" permissions. We can grant this using the following command.

~~~shell
deno run --allow-net --allow-read webserver_v1.js
~~~

Better yet we can compile our JavaScript program into an executable file. The is handy because we can run it without Deno being installed (such as on a different computer using the same operating system and processor). An executable becomes similar to our other tools in our tool box like our terminal application, text editor and web browser.

~~~shell
deno compile --allow-net --allow-read webserver_v1.js
~~~

This should result in a file being created called "webserver_v1" (or on Windows, "webserver_v1.exe"). This file can be run from this directory or moved to the directory you store other programs.

## Improving on v1

While webserver_v1.js is helpful it could be more friendly. What if I want to use a different port number? What if I want to have the files in my current directory or different directory be where the web content resides?  We can do that by leveraging command line parameters.

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

I can run your new webserver using the following command.

~~~shell
./webserver_v2 8001 .
~~~

Point the web browser at <http://localhost:8001>. What do you see? Can you find "helloworld.html"? Shutdown the web server and then start it again using just the executable name.

macOS and Linux

~~~shell
./webserver_v2
~~~

on Windows

~~~shell
.\webserver_v2
~~~

What do you see? Can you find "helloworld.html"? Stop the web server. Copy "helloworld.html" to "index.html". After you copy the file start up the web server again.

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

Point the web browser at <http://localhost:8000>, what do you see?

Can we improve on this?  It'd be nice to web able to just type "webserver_v2" and have us the port and htdocs directory of our choice. We can do this using a configuration file. YAML is an easy to read and easy to type notation that expresses the same types of data structures as JSON (JavaScript Object Notation). Here's an example of what a configuration file. Type it in and save it using the filename "webserver.yaml".

~~~yaml
# Set root path for web content to the current directory.
htdocs: .
# Set the port number to listen on to 8002
port: 8002
~~~

From the point of the view of our program we'll need to see if the "webserver.yaml" file exists and Deno has a module for that. We'll also need to read the YAML and parse it. Deno also has a standard model for working with YAML too. The modules we're interested in are `@std/fs/exists` and `@std/yaml`. We'll need to "add" them to our deno project first.

~~~shell
deno add jsr:@std/fs/exists
deno add jsr:@std/yaml
~~~

Now let's write our improved version of our static web server. It should be called, "webserver_v3.js".

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

Point the web browser at <http://localhost:8002>. What do you see?  Can you find our HTML files?

I think we have a useful localhost static content web server. It's time to rename our working prototype version and install it so we have it available in our toolbox.

1. Copy `webserver_v3.js` to `webserver.js` 
2. Use `deno compile` to create an executable
3. Create a "$HOME/bin" directory if necessary
4. Move the executable to a location in your with, example "$HOME/bin"
5. If needed add "$HOME/bin" to your path, you can check this to be sure

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

If the "$HOME/bin" or "$HOME\bin" are not in your PATH then you'll need to refer to your operating system instruction to add that directory to your path.

There you have it, a conveint static web server for your own localhost.

