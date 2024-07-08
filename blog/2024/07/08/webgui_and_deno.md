---
title: Web GUI and Deno
pubDate: 2024-07-08
created: 2024-07-07
abstract: |
  My notes on two Web GUI modules available for Deno.
keywords:
  - Deno
  - TypeScript
  - webui
  - webview
---

# Web GUI and Deno

By R. S. Doiel, 2024-07-08

I've been looking at various approaches to implement graphical interfaces for both Deno and other languages.  I had been looking primarily at webview bindings but then stumbled on [webui](https://webui.me). Both could be a viable way to implement a local first human user interface.

Here's an example of the webview implementation of hello world.

~~~typescript
import { Webview } from "@webview/webview";

const html = `
<html>
  <head></head>
  <body>
    <h1>Hello from deno v${Deno.version.deno}</h1>
    <script>console.log("Hi There!");</script>
  </body>
</html>
`;

const webview = new Webview();

webview.navigate(`data:text/html,${encodeURIComponent(html)}`);
webview.run();
~~~

Now here is a functionally equivalent version implemented using webui.

~~~typescript
import { WebUI } from "https://deno.land/x/webui/mod.ts";

const myWindow = new WebUI();

myWindow.show(`
<html>
  <head><script src="webui.js"></script></head>
  <body>
    <h1>Hello from deno v${Deno.version.deno}</h1>
    <script>console.log("Hi There!");</script>
    </body>
</html>`);

await WebUI.wait();
~~~

Let's call these [thing1.ts](thing1.ts) and [thing2.ts](thing2.ts).  To run thing1 I need a little prep since I've used an `@` import. The command I need to map the `webview/webview` module is the `deno add` command.

~~~shell
deno add @webview/webview
~~~

Here's how I check and run thing1.

~~~shell
deno check thing1.ts
deno run -Ar --unstable-ffi thing1.ts
~~~

Since I didn't use an `@` import in the webui version I don't need to "add" it to Deno. I check and run thing2 similar to thing1.

~~~shell
deno check thing2.ts
deno run -Ar --unstable-ffi thing2.ts
~~~

Both will launch a window with our hello world message. Conceptually the code is similar but the details differ.  In the case of webview you are binding the interaction from the webview browser implementation. You populate your "page" using a data URL call (see `webview.navigate()`. Webview is a minimal web browser. It is similar to but not the same as evergreen web browsers like Firefox, Chrome, or Edge. Depending how var you want to push your CSS, JavaScript and HTML this may or may not be a problem.

Webui uses a lighter weight approach. It focuses on a web socket connection between your running code and the user interface. It leaves the browser implementation to your installed browser (e.g. Chrome, Edge or Firefox). There is a difference in how I need to markup the HTML compared to the webview version. In the webui version I have a script element in the head. It loads "webui.js". This script is supplied by webui C level code. It "dials home" to connect your program code with the web browser handling the display. Webui at the C library level is functioning as a web socket server.

Conceptually I like the webui approach. My program code is a "service", webui manages the web socket layer and the web browser runs the UI. Web browsers are complex. In the web UI approach my application's binary isn't implementing one. In the webview approach I'm embedding one. Feels heavy. At a practical level of writing TypeScript it may not make much differences. When I compiled both thing1 and thing2 to binaries thing2 was approximately 1M smaller. Is that difference important? Not really sure.

What about using webview or webui from other languages? Webview has been around a while. There are many bindings for the C++ code of webview and other languages.  Webui currently supports Rust, Go, Python, TypeScript/JavaScript (via Deno), Pascal as well as a few exotic ones. TypeScript was easy to use either. I haven't tried either out with Python or Go. I'll leave that for another day.
