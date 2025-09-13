---
title: A quick note on types in Deno+TypeScript
author: R. S. Doiel
byline: 'R. S. Doiel, 2025-05-25'
series: Deno+TypeScript
keywords:
  - TypeScript
  - Deno
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  Understanding the plumbing of a program that is built with Deno in TypeScript
  can be challenging if you can't identify the type of variables or constants. 
  TypeScript inherits the JavaScript function, `typeof`. This works nicely for
  simple types like `string`, `boolean`, `number` but is  less useful when
  compared to a class or interface name of a data structure.


  There are three approaches I've found helpful in my exploration of type
  metadata when working with Deno+TypeScript. (NOTE: in the following

  the value `VARIABLE_OR_CONSTANT` would be replaced with the object you are
  querying for type metadata)


  ...
dateCreated: '2025-05-25'
dateModified: '2025-07-23'
datePublished: '2025-05-25'
postPath: 'blog/2025/05/25/a_quick_notes_on_types.md'
seriesNo: 3
---

# A quick note on types in Deno+TypeScript

Understanding the plumbing of a program that is built with Deno in TypeScript can be challenging if you can't identify the type of variables or constants.  TypeScript inherits the JavaScript function, `typeof`. This works nicely for simple types like `string`, `boolean`, `number` but is  less useful when compared to a class or interface name of a data structure.

There are three approaches I've found helpful in my exploration of type metadata when working with Deno+TypeScript. (NOTE: in the following
the value `VARIABLE_OR_CONSTANT` would be replaced with the object you are querying for type metadata)

`typeof`
: This is good for simple types but when a type is an object you get `[object object]` response.

`Object.protototype.toString.call(VARIABLE_OR_CONSTANT)`
: This is what is behind the `typeof` function but can be nice to know. It returns the string representation of the `VARIABLE_OR_CONSTANT` you pass to it.

`VARIABLE_OR_CONSTANT.constructor.name`
: This will give you the name derived from the object's constructor, effectively the class name. It doesn't tell you if the the `VARIABLE_OR_CONSTANT` is an interface. If you construct an object as an object literal then the name returned will be `Object`.

Here's the three types in action.

~~~TypeScript
  let fp = await Deno.open('README.md');
  console.log(typeof(fp));
  console.log(Object.prototype.toString.call(fp);
  console.log(fp.constructor.name);
  await fp.close()
  
  let t = { "one": 1 };
  console.log(typeof(t));
  console.log(Object.prototype.toString.call(t);
  console.log(t.constructor.name);
~~~
