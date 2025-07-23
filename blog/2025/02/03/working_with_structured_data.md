---
title: Working with Structured Data in Deno and TypeScript
createDate: 2025-02-03T00:00:00.000Z
abstract: |
  A short discourse on working with structured data in TypeScript and easily
  converting from JSON, YAML and XML representations.
keywords:
  - Deno
  - TypeScript
  - Structured Data
author: R. S. Doiel
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2025-02-03'
datePublished: '2025-02-03'
dateModified: '2025-07-23'
---

# Working with Structured Data in Deno and TypeScript

One of the features in Go that I miss in TypeScript is Go's [DSL](https://en.wikipedia.org/wiki/Domain-specific_language "Domain Specific Language") for expressing data representations.  Adding JSON, YAML and XML support in Go is simple. Annotating a struct with a string expression. There is no equivalent feature in TypeScript. How do easily support multiple representations in TypeScript?

Let's start with JSON. TypeScript has `JSON.stringify()` and `JSON.parse()`. So getting to JSON representation is trivial, just call the stringify method. Going from text to populated object is done with `JSON.parse`. But there is a catch.

Let's take a simple object I'm defining called "ObjectN". The object has a single attribute "n". "n" holds a number. The initial values is set to zero. What happens when I instantiate my ObjectN then assign it the result from `JSON.parse()`.

~~~TypeScript
class ObjectN {
    n: number = 0;
    addThree(): number {
        return this.n + 3;
    }
}
let src = `{"n": 1}`;
let o: ObjectN = new ObjectN();
o = JSON.parse(src);
// NOTE: This will fail, addThree method isn't available.
console.log(o.addThree());
~~~

Huston, we have a problem. No "addThree" method. That is because JSON doesn't include method representation. What we really want to do is inspect the object returned by `JSON.parse()` and set the values in our ObjectN accordingly. Let's add a method called `fromObject()`.
(type the following into the Deno REPL).

~~~TypeScript
class ObjectN {
    n: number = 0;
    addThree(): number {
        return this.n + 3;
    }
    fromObject(o: {[key: string]: any}): boolean {
        if (o.n === undefined) {
            return false;
        }
        // Validate that o.n is a number before assigning it.
        const n = (new Number(o.n)).valueOf();
        if (isNaN(n)) {
            return false;
        }
        this.n = n;
        return true;
    }
}
let src = `{"n": 1}`;
let o: ObjectN = new ObjectN();
console.log(o.addThree());
o.fromObject(JSON.parse(src));
console.log(o.addThree());
~~~

Now when we run this code we should see a "3" and then a "4" output. Wait, `o.fromObject(JSON.parse(src));` looks weird. Why not put `JSON.parse()` inside "fromObject"? Why not renamed it "parse"?

I want to support many types of data conversion like YAML or XML. I can use my "fromObject" method with the result of produced from `JSON.parse()`, `yaml.parse()` and `xml.parse()`. One function works with the result of all three. Try adding this.

~~~TypeScript
import * as yaml from 'jsr:@std/yaml';
import * as xml from "jsr:@libs/xml";
src = `n: 2`;
o.fromObject(yaml.parse(src));
console.log(o.addThree());
src = `<n>3</n>`;
o.fromObject(xml.parse(src));
console.log(o.addThree());
~~~

That works!

Still it would be nice to have a "parse" method too. How do I do that without winding up with a "parseJSON()", "parseYAML()" and "parseXML()"? What I really want is a "parseWith" method which accepts the text and a parse function. TypeScript expects type information about the function being passed. I solve that problem by including a "ObjectParseType" definition that works across the three parsing objects -- JSON, yaml and xml.

~~~TypeScript
import * as yaml from 'jsr:@std/yaml';
import * as xml from "jsr:@libs/xml";

// This defines my expectations of the parse function provide by JSON, yaml and xml.
type ObjectParseType = (arg1: string, arg2?: any) => {[key: string]: any} | unknown;

class ObjectN {
    n: number = 0;
    addThree(): number {
        return this.n + 3;
    }
    fromObject(o: {[key: string]: any}) : boolean {
        if (o.n === undefined) {
            return false;
        }
        // Validate that o.n is a number before assigning it.
        const n = (new Number(o.n)).valueOf();
        if (isNaN(n)) {
            return false;
        }
        this.n = n;
        return true;
    }
    parseWith(s: string, fn: ObjectParseType): boolean {
        return this.fromObject(fn(s) as unknown as {[key: string]: any});
    }
}

let o: ObjectN = new ObjectN();
console.log(`Initial o.addThree() -> ${o.addThree()}`);
console.log(`o.toString() -> ${o.toString()}`);

let src = `{"n": 1}`;
o.parseWith(src, JSON.parse);
console.log(`parse with JSON, o.addThree() -> ${o.addThree()}`);
console.log(`JSON.stringify(o) -> ${JSON.stringify(o)}`);

src = `n: 2`;
o.parseWith(src, yaml.parse);
console.log(`parse with yaml, o.addThree() -> ${o.addThree()}`);
console.log(`yaml.stringify(o) -> ${yaml.stringify(o)}`);

src = `<?xml version="1.0"?>
<n>3</n>`;
o.parseWith(src, xml.parse);
console.log(`parse with xml, o.addThree() -> ${o.addThree()}`);
console.log(`xml.stringify(o) -> ${xml.stringify(o)}`);
~~~

As long as the parse method returns an object I can now update my ObjectN instance
from the attributes of the object expressed as JSON, YAML, or XML strings. I like this approach because I can add validation and normalization in my "fromObject" method and use for any parse method that confirms to how JSON, YAML or XML parse works. The coding cost is the "ObjectParseType" type definition and the "parseWith" method boiler plate and defining a class specific "fromObject". Supporting new representations does require changes to my class definition at all.