---
title: Transpiling with Deno
pubDate: 2024-07-03T00:00:00.000Z
created: 2024-07-03T00:00:00.000Z
keywords:
  - TypeScript
  - JavaScript
  - Deno
software:
  - Deno >= v1.44
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  [Deno](https://deno.land) is a fun environment to work in for learning
  TypeScript.  As I have become comfortable writing server side TypeScript code
  I know I want to also be able to use some modules in JavaScript form browser
  side. The question is then how to you go from TypeScript to JavaScript easily
  with getting involved with a bunch-o-npm packages?  Turns the solution in deno
  is to use the
  [deno_emit](https://github.com/denoland/deno_emit/blob/main/js/README.md)
  module.  Let's say I have a TypeScript module called `hithere.ts`. I want to
  make it available as JavaScript so I can run it in a web browser. How do I use
  the `deno_emit` module to accomplish that?


  - Write a short TypeScript program
    - include the transpiler module provided with emit
    - use the transpiler to generate the JavaScript code
    - output the JavaScript code

  Here's what `transpile.ts` might look like ...
dateCreated: '2024-07-03'
dateModified: '2025-07-23'
datePublished: '2024-07-03'
---

# Transpiling with Deno

[Deno](https://deno.land) is a fun environment to work in for learning TypeScript.  As I have become comfortable writing server side TypeScript code I know I want to also be able to use some modules in JavaScript form browser side. The question is then how to you go from TypeScript to JavaScript easily with getting involved with a bunch-o-npm packages?  Turns the solution in deno is to use the [deno_emit](https://github.com/denoland/deno_emit/blob/main/js/README.md) module.  Let's say I have a TypeScript module called `hithere.ts`. I want to make it available as JavaScript so I can run it in a web browser. How do I use the `deno_emit` module to accomplish that?

- Write a short TypeScript program
  - include the transpiler module provided with emit
  - use the transpiler to generate the JavaScript code
  - output the JavaScript code

Here's what `transpile.ts` might look like:

~~~typescript
/* Get the transpiler module from deno's emit */
import { transpile } from "https://deno.land/x/emit/mod.ts";

/* Get the python to my CL.ts as a URL */
const url = new URL("./hithere.ts", import.meta.url);
/* Transpile the code returning a result */
const result = await transpile(url);

/* Get the resulting code and write it to standard out */
const code = result.get(url.href);
console.log(code);
~~~

Here's the `hithere.ts` module:

~~~typescript
/**
 * hithere takes a name and returns a string of "hi there ", a name and "!". If the name is null
 * it returns "Hello World!".
 *
 * @param {string | null} name
 * @returns {string}
 */
function hithere(name: string | null): string {
	if (name === null) {
		return "Hello World!";
	}
	return `hi there ${name}!`;
}
~~~

To compile the module I need to give transpile.ts some permissions.

- --allow-read (so I can read my local module
- --allow-env (the transpiler needs the environment)
- --allow-net (the deno emit module is not hosted locally)

The command line could look like this.

~~~shell
deno run --allow-read --allow-env --allow-net \
  transpile.ts
~~~

The result is JavaScript. It still has my comments in the code but doesn't have the TypeScript specific
annotations.

~~~javascript
/**
 * hithere takes a name and returns a string of "hi there ", a name and "!". If the name is null
 * it returns "Hello World!".
 *
 * @param {string | null} name
 * @returns {string}
 */ function hithere(name) {
  if (name === null) {
    return "Hello World!";
  }
  return `hi there ${name}!`;
}
~~~