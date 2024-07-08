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
