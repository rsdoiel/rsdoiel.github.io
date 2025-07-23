---
title: Transpiling & Bundling with Emit
byline: 'R. S. Doiel, 2024-11-21'
abstract: |
  A brief discussion of using the Deno emit module to transpile and bundle
  TypeScript.
keywords:
  - Deno
  - TypeScript
  - transpile
  - bundle
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2024-11-21'
dateModified: '2025-07-23'
datePublished: '2024-11-21'
---

# Transpiling & Bundling with Emit

One of the nice features of Deno is native TypeScript support.  One of the selling strength though is that the same source can run both server side and browser side.  The challenge is that TypeScript does not have native TypeScript support. This is easy to remedy using Deno's [emit](https://jsr.io/@deno/emit) module.

The emit module supports to important functions, `transpile` and `bundle`. Both will render your TypeScript as JavaScript in a browser friendly manner. The `transpile` function turns a single TypeScript file into an equivalent JavaScript file. Bundle can do that with a TypeScript and all the files it imports so you have a self contained JavaScript file with everything you need.

<!-- The emit module website shows how to write a short TypeScript program to transpile and bundle.  When you combine that with a Deno task it is trivial to automatically make that happen. -->


Here's what my `transpile.ts` looks like.

~~~typescript
import { transpile } from "jsr:@deno/emit";
import * as path from "jsr:@std/path";

/* Transpile directory_client.ts to JavaScript and render it to 
   htdocs/js/directory_client.js */
const js_path = path.join("htdocs", "js");
const js_name = path.join(js_path, "directory_client.js");
const url = new URL("./directory_client.ts", import.meta.url);
const result = await transpile(url);
const code = await result.get(url.href);

await Deno.mkdir(js_path, { mode: 0o775, recursive: true });
Deno.writeTextFile(js_name, code);
~~~

You can run that with the following long command line.

~~~shell
deno run --allow-import --allow-env --allow-read --allow-write --allow-net transpile.ts
~~~

Of course you can easily turn this into a [Deno task](https://docs.deno.com/runtime/reference/cli/task_runner/).

If our `directory_client.ts` file contained other modules you can instead use the `bundle` function.  Here's an example of bundling our `directory_client.ts` saving the result as `htdocs/modules/directory_client.js`.

~~~typescript
/**
 * bundle.ts is an example of "bundling" the type script file directory_client.ts
 * into a module and writing it to htdocs/modules.
 */
import { bundle } from "jsr:@deno/emit";

const js_path = path.join("htdocs", "modules");
const js_name = path.join(js_path, "directory_client.js");
const result = await bundle("./directory_client.ts");
const { code } = result;
await Deno.mkdir(js_path, { mode: 0o775, recursive: true });
await Deno.writeTextFile(js_name, code);
~~~

You can run that with the following long command line.

~~~shell
deno run --allow-import --allow-env --allow-read --allow-write --allow-net bundle.ts
~~~

The bundle will contain the transpiled TypeScript from `directory_client.ts` but also any modules that `directory_client.ts` relied on. If you don't want to include the imported modules then you can set the value of `recursive` to false.