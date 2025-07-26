---
title: Build a CommonMark Processor
abstract: >
  In this post I go over the process of building a TypeScript module called
  `commonMarkDoc.ts` along with a simple command line CommonMark processor
  called `cmarkprocess`.

  CommonMark pre-processor features are

    - support `@include-code-block` for including code samples as code blocks
    - support `@include-text-block` for include plain text into a CommonMark document
    - support mapping links with file extension ".md" to ".html"
    - transform Hashtags into front matter
    - transform @Tags into front matter
keywords:
  - CommonMark
  - Markdown
  - Front Matter
dateCreated: 2025-07-26T00:00:00.000Z
dateModified: 2025-07-26T00:00:00.000Z
datePublished: 2025-07-26T00:00:00.000Z
author: R. S. Doiel
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
hashTags: []
atTags:
  - '@include'
---

# Building cmarkprocess

## Building a CommonMark Processor in Deno+TypeScript

CommonMark and Markdown are easier to proof read and edit than HTML. CommonMark is a super set of John Grubber's original Markdown. It incorporates common practices and extensions to the original Markdown. I've found over the years the "Markdown" I type is really "CommonMark". I depend on those extensions. While I enjoying using [Pandoc](https://pandoc.org) for processing my CommonMark documents I also have found there are a few transforms I'd like to make before I send the text off to Pandoc. That is what I'll be covering here.

My CommonMark Processor will be responsible for several things. The features I miss are simple. Here's the short list.

- support `@include-code-block` for including code samples as code blocks
- support `@include-text-block` for include plain text into a CommonMark document
- transform Hashtags into front matter
- transform web Mentions into front matter

I commonly need to include source code in my blog posts.  That lead me to think about an include mechanism that would pull in the source code and form a CommonMark code block. On my homepage the index CommonMark page is built from plain text files. Some of the files are generated and some are text I edit by hand. Finally I've been thinking allot about [Hashtag](https://en.wikipedia.org/wiki/Hashtag) and web [Mentions](https://en.wikipedia.org/wiki/Mention_(blogging)). I think both offer possibilities for evolving my site. I a think they might be useful for generating feeds, tag clouds, topic indexes or facets used in search results. Overtime I'll explore new features. The `commonMarkDoc.ts` module needs to be simple to extend.

The Hashtag and Mentions are standardized. A regular expression should be suitable to pick them out. The difference between extracting a Hashtag or Mentions is only in the prefix, "#" or "@". A regular expression should due nicely here too.

The include blocks, text and code, can also be detected through regular expression. The difference for those is they require reading files from disk. That needs to be handled.

Here's the syntax I'd use for code block and included texts.

  > `@include-code-block` `FILEPATH [LANGUAGE]`

  > `@include-text-block` `FILEPATH`

Since I want to easily extend the processor I'll create each of these as modules. Each will include a function that implements the transform. The `process` method will be responsible for handling the function results.

Let's take a look at the CommonMark document object. I need to take text, parse it and have the object holding the CommonMark document split it into front matter and content. Similarly I will need to reassemble the parts into back into a CommonMark text.  Those functions will be called `parse` and `stringify` as idioms established in TypeScript and JavaScript. The object type will be called `CommonMarkDoc`.

Heres the basic outline of the `CommonMarkDoc` object.

~~~TypeScript
/**
 * commonMarkDoc is a Deno TypeScript module for working with CommonMark documents.
 * Copyright (C) 2025 R. S. Doiel
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 * 
 * @contact: rsdoiel@gmail.com
 * @issues: https://github.com/rsdoiel/commonMarkDoc/issues
 * 
 */
import * as yaml from "@std/yaml";

import { extractTags, mergeTags } from "./extractTags.ts";
import { includeCodeBlock } from "./includeCodeBlock.ts";
import { includeTextBlock } from "./includeTextBlock.ts";

export class CommonMarkDoc {
  frontMatter: Record<string, unknown> = {};
  content: string = "";

  // Parse a CommonMark or Markdown document into content and front matter
  parse(text: string) {
    const frontMatterRegex: RegExp = /^---([\s\S]+?)---/;
    const match: Array<string> | null = text.match(frontMatterRegex) as Array<
      string
    >;

    if (match) {
      this.frontMatter = yaml.parse(match[1]) as Record<string, unknown>;
      this.content = text.slice(match[0].length).trim();
    } else {
      this.frontMatter = {};
      this.content = text;
    }
  }

  // Return this object as a CommonMark document with front matter and content.
  stringify(): string {
    if (Object.keys(this.frontMatter).length > 0) {
      return `---
${yaml.stringify(this.frontMatter)}---

${this.content}`;
    }
    return this.content;
  }
}


~~~

This establishes an object that makes it easy to work with front matter and the content part of a CommonMark document. The `parse` and `stringify` methods bookend the processing and transformation. The middle method will be called `process`. 

The `process` method is where I need to minimize complexity. It will evolve overtime. To keep `process` simple I will implement each transform as it's own module. The `process` module only needs to manage the sequence of transforms.

One transform in the `process` method will be extracting the Hashtags and Mentions. Both Hashtags and Mentions are similar. They have a prefix, "#" or "@" followed by a sequence of alphanumeric characters, period and underscores. Trailing periods are stripped. They should be kept separate in the front matter. Each plays different content roles. 

Collecting  tags in the text is easy using a regular expression. I have to make a choice about the resulting list. One approach would just be list a  tag each time it is encountered. This will mean repeated tags would be duplicated in the resulting list. That seems problematic. Instead I would like the list of tags returned to be a unique list of strings. The extraction function will need a parameter for the source text, the prefix and it should return a list of unique tags found. I'm going to call this function, `extractTags`.

As I collect tags I will need an ability to merge tag lists. That suggestions a merge function. That function will take one or more lists of tags an return a single list of unique tags.  I'm going to call these function `mergeTags`. Both relate to tags and exist because of extraction.  I'll put them in a module called `extractTags.ts`.  Let's see how that could be implemented.

~~~TypeScript
// Extract tags. By default it extracts HashTags. You may provide
// another prefix like '@' to extract @Tags.
export function extractTags(text: string, prefix: string = "#"): string[] {
  // Regular expression to match tags based on the prefix, including alphanumeric,
  // periods, and underscores.
  const regex = new RegExp(`${prefix}[\\w.]+`, "g");
  //const regex = new RegExp(`${prefix}[\\w.]+?(?=\\s|$|[^\\w.])`, 'g');
  const tags = text.match(regex);
  if (tags === null) {
    return [];
  }
  // Further process the tags to remove any trailing periods
  return tags.map((tag) => tag.replace(/\.$/, ""));
}

// mergeTags takes a list of tag lists and merges them
// into a single list of unique tags.
export function mergeTags(...tagLists: string[][]): string[] {
  // Use a Set to automatically handle uniqueness
  const uniqueTags = new Set<string>();

  // Iterate over each list of tags
  tagLists.forEach((tagList) => {
    // Add each tag to the Set
    tagList.forEach((tag) => uniqueTags.add(tag));
  });

  // Convert the Set back to an array and return it
  return Array.from(uniqueTags);
}

~~~

The next thing to implement will be the include text block transformation. The one includes a text file without wrapping the text in other markup. 

> `@include-text-block` `FILENAME`

> `@include-code-block` `FILENAME LANGUAGE`

Each of these will be implemented in their own module. Let's look at the one for `@include-text-block`. In like our tags module I'm keep them separate. They may evolve independently and I might want to include them in other projects. Here's what the include text module looks like.

~~~TypeScript
/**
 * includeTextBlock takes a text string and replaces the code blocks
 * based on the file path included in the line and the langauge name
 * The generate code block uses the `~~~` sequence to delimit the block
 * with the language name provided in the opening delimiter.
 *
 * @param text:string to be transformed
 * @returns the transformed text as a string
 */
export function includeTextBlock(text: string): string {
  // Find the include-text-block directive in the page.
  const insertBlockRegExp:RegExp = /@include-text-block\s+([^\s]+)(?:\s+(\w+))?/g;

  // Insert the code blocks
  return text.replace(insertBlockRegExp, replaceTextBlock);
}

// replaceTextBlock does that actual replacement work with the result
// of the matched RegExp.
function replaceTextBlock(_fullMatch: string, filePath:string):string {
  let fileContent:string = '';
  try {
    fileContent = Deno.readTextFileSync(filePath);
  } catch (error) {
    console.error(`Error inserting block from ${filePath}, ${error}`);
  }
  if (fileContent) {
    return fileContent;
  } else {
    return `@include-text-block ${filePath}`;
  }
}

~~~

The public function handles finding the file referenced, reading it into a string before including it the transformed content block.  Let's look at the one for `@include-code-block`.

~~~TypeScript
/**
 * commonMarkDoc is a Deno TypeScript module for working with CommonMark documents.
 * Copyright (C) 2025 R. S. Doiel
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 * 
 * @contact: rsdoiel@gmail.com
 * @issues: https://github.com/rsdoiel/commonMarkDoc/issues
 * 
 * includeCodeBlock.js is a package implementing the `@include-code-block` extension to
 * CommonMark markup.
 */

/**
 * includeCodeBlock takes a text string and replaces the code blocks
 * based on the file path included in the line and the langauge name
 * The generate code block uses the `~~~` sequence to delimit the block
 * with the language name provided in the opening delimiter.
 *
 * @param text (string) to be transformed
 * @returns the transformed text as a string
 */
export function includeCodeBlock(text: string):string {
  // Find the include-code-block directive in the page. 
  const insertBlockRegExp: RegExp = /@include-code-block\s+([^\s]+)(?:\s+(\w+))?/g;

  // Insert the code blocks
  return text.replace(insertBlockRegExp, replaceCodeBlock);
}

// replaceCodeBlock does that actual replacement work with the result
// of the matched RegExp.
function replaceCodeBlock(_fullMatch:string, filePath: string, language:string = ""): string {
  const fileContent:string = Deno.readTextFileSync(filePath);
  if (fileContent) {
    return "~~~" + language + "\n" + fileContent + "\n~~~";
  } else {
    console.error(`Error inserting block from ${filePath}`);
    return `@include-code-block ${filePath} ${language}`;
  }
}

~~~

Again these are very similar. I could have written them usising a parameter to pick behavior. That fealt like it entangled the two functions unnecessarily. As an example, in the future I may wish to embed the text inside an HTML element with an associated class. Keeping thing simple in separate modules aligns with that.

Now we have the set  of transforms I want to support in the initial version of the CommonMark "process" method. Look at the internals of `process` as asequence of transforms. 

~~~TypeScript

// Process uses the existing CommonMark object to create a new one transforming the front matter
// and content accordingly. E.g. handling HashTags, @Tags, `@include-code-block`.
//
// NOTE: This function uses a synchonous read to include content for code blocks. If have a slow disk
// access or lots of included code blocks this will raise the execution time of this method.
//
// If a code block can't be read it will leave the `@include-code-block` text in place.
process() {
  // Clone a copy of this object.
  const cmark: CommonMarkDoc = new Object(this) as CommonMarkDoc;

  // Handle included text blocks
  cmark.content = includeTextBlock(cmark.content);

  // Extract any HashTags from content
  const hashTags: string[] = extractTags(cmark.content, "#");
  const atTags: string[] = extractTags(cmark.content, "@");

  // Process our HashTags adding them to our keywords list
  if (
    cmark.frontMatter.hashTags === undefined ||
    cmark.frontMatter.hashTags === null
  ) {
    cmark.frontMatter.hashTags = [];
  }
  cmark.frontMatter.hashTags = mergeTags(cmark.frontMatter.hashTags as string[], hashTags);

  // Process our @Tags and add them to an AtTag list.
  if (
    cmark.frontMatter.atTags === undefined ||
    cmark.frontMatter.atTags === null
  ) {
    cmark.frontMatter.atTags = [];
  }
  cmark.frontMatter.atTags = mergeTags(cmark.frontMatter.atTags as string[], atTags);

  // Handle include code blocks
  cmark.content = includeCodeBlock(cmark.content);

  // We can now return the revised object.
  return cmark;
}

~~~

To use the the transform functions in the `process` method I need to import them.

~~~TypeScript

import { extractTags, mergeTags } from "./extractTags.ts";
import { includeCodeBlock } from "./includeCodeBlock.ts";
import { includeTextBlock } from "./includeTextBlock.ts";


~~~

Now I'm ready to implement a complete `commonMarkDoc.ts` module.

~~~TypeScript
import * as yaml from "@std/yaml";

import { extractTags, mergeTags } from "./extractTags.ts";
import { includeCodeBlock } from "./includeCodeBlock.ts";
import { includeTextBlock } from "./includeTextBlock.ts";

export class CommonMarkDoc {
  frontMatter: Record<string, unknown> = {};
  content: string = "";

  // Parse a CommonMark or Markdown document into content and front matter
  parse(text: string) {
    const frontMatterRegex: RegExp = /^---([\s\S]+?)---/;
    const match: Array<string> | null = text.match(frontMatterRegex) as Array<
      string
    >;

    if (match) {
      this.frontMatter = yaml.parse(match[1]) as Record<string, unknown>;
      this.content = text.slice(match[0].length).trim();
    } else {
      this.frontMatter = {};
      this.content = text;
    }
  }

  // Return this object as a CommonMark document with front matter and content.
  stringify(): string {
    if (Object.keys(this.frontMatter).length > 0) {
      return `---
${yaml.stringify(this.frontMatter)}---

${this.content}`;
    }
    return this.content;
  }

  // Process uses the existing CommonMark object to create a new one transforming the front matter
  // and content accordingly. E.g. handling HashTags, @Tags, `@include-code-block`.
  //
  // NOTE: This function uses a synchonous read to include content for code blocks. If have a slow disk
  // access or lots of included code blocks this will raise the execution time of this method.
  //
  // If a code block can't be read it will leave the `@include-code-block` text in place.
  process() {
    // Clone a copy of this object.
    const cmark: CommonMarkDoc = new Object(this) as CommonMarkDoc;

    // Handle included text blocks
    cmark.content = includeTextBlock(cmark.content);

    // Extract any HashTags from content
    const hashTags: string[] = extractTags(cmark.content, "#");
    const atTags: string[] = extractTags(cmark.content, "@");

    // Process our HashTags adding them to our keywords list
    if (
      cmark.frontMatter.hashTags === undefined ||
      cmark.frontMatter.hashTags === null
    ) {
      cmark.frontMatter.hashTags = [];
    }
    cmark.frontMatter.hashTags = mergeTags(cmark.frontMatter.hashTags as string[], hashTags);

    // Process our @Tags and add them to an AtTag list.
    if (
      cmark.frontMatter.atTags === undefined ||
      cmark.frontMatter.atTags === null
    ) {
      cmark.frontMatter.atTags = [];
    }
    cmark.frontMatter.atTags = mergeTags(cmark.frontMatter.atTags as string[], atTags);

    // Handle include code blocks
    cmark.content = includeCodeBlock(cmark.content);

    // We can now return the revised object.
    return cmark;
  }
}

~~~

To use this module I need to wrap it so I can execute it from the common line. My processor is going to be called `cmarkprocess` so I'll name the module that becomes the command line program is `cmarkprocess.ts`. This module will include a "main" function, that function will handle command line options and parameters as well as read data from either standard input or a file.  It'll use the `CommonMarkDoc` `process` method and write the results to the standard out.

~~~TypeScript
import * as yaml from "@std/yaml";
import { parse as parseArgs } from "@std/flags";

import { CommonMarkDoc } from "./commonMarkDoc.ts";

// main implements a light weight CommonMark processor
// called `cmarkprocess`. It demonstrates the features of the
// CommonMarkDoc module.
async function main() {
  const appName = "cmarkprocess";
  const args = parseArgs(Deno.args, {
    boolean: ["help", "version", "license"],
    alias: {
      h: "help",
      v: "version",
      l: "license",
    },
  });
  const version:string = '1';
  const licenseText: string = `${appName} is a program to process CommonMark documents with front matter.
    Copyright (C) 2025 R. S. Doiel

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.`;

  if (args.help) {
    console.log(`%${appName} | user manual

# NAME

${appName}

# SYNOPSIS

${appName} [COMMONMARK_FILENAME]

# DESCRIPTION

This is a CommonMark processor that can read a CommonMark text
transforming it into an update CommonMark text base on the following
features.

- support for HashTags and Mentions, merging them into the document's
  front matter
- \`@include-text-block\` allows for text includes
  - Example: \`@include-text-black\` \`FILENAME\`
- \`@include-code-block\` allows for including code blocks
  - Example: \`@include-code-black\` \`FILENAME [LANGUAGE]\`

# OPTION

-h, --help
: display help

-v,--version
: display version

-l, --license
: display license

`);
    Deno.exit(0);
  }

  if (args.version) {
    console.log(`${appName} ${version}`);
    Deno.exit(0);
  }

  if (args.license) {
    console.log(licenseText);
    Deno.exit(0);
  }

  const cmark = new CommonMarkDoc();
  const filePath = args._[0] as string;
  let text: string = "";
  if (args._.length === 0) {
    const decoder = new TextDecoder();
    for await (const chunk of Deno.stdin.readable) {
      text += decoder.decode(chunk);
    }
  } else {
    text = await Deno.readTextFile(filePath);
  }
  cmark.parse(text);
  try {
    await cmark.process();
  } catch (error) {
    console.error(`ERROR (${filePath}): ${error}`);
    Deno.exit(1);
  }
  const output = cmark.stringify();
  console.log(output);
}

if (import.meta.main) {
  await main();
}

~~~

Now that we have our wrapping modules, how do I get a nice executable using Deno?

~~~shell
deno compile --allow-read -o bin/cmarkprocess cmarkprocess.ts
~~~

The result is an executable, `bin/cmarkprocess`. This executable can read from standard input or from a file path. It will write to standard output.
