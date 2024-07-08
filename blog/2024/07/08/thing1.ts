import { Webview } from "@webview/webview";

const html = `
<html>
  <body>
    <h1>Hello from deno v${Deno.version.deno}</h1>
    <script>console.log("Hi There!");</script>
  </body>
</html>
`;

const webview = new Webview();

webview.navigate(`data:text/html,${encodeURIComponent(html)}`);
webview.run();
