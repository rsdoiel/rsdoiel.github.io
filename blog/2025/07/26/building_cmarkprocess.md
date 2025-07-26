---
title: Building cmarkprocess
abstract: >
  This is an article about building a CommonMark processor. It performs two
  primary functions.

  CommonMark pre-processor features

    - support `@include-code-block` for including code samples as code blocks
    - support `@include-text-block` for include plain text into a CommonMark document
    - support mapping links with file extension ".md" to ".html"
    - transform Hashtags into front matter
    - transform @Tags into front matter
keywords:
  - CommonMark
  - Markdown
  - Front Matter
hashTags: []
atTags:
  - '@include'
  - '@Tags'
  - '@tag'
dateCreated: '2025-07-26'
dateModified: defaults.yaml
datePublished: defaults.yaml
author: R. S. Doiel
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
---

# Building a cmarkprocess

## Building a CommonMark Processor in Deno+TypeScript

CommonMark and Markdown are easier to proof read and edit than HTML due to a simple syntax. Importantly also are design to easily translate HTML. CommonMark is a super set of John Grubber's original Markdown concept incorporating common practices and usage the extended Grubber's original Markdown. I have chosen to use the term CommonMark in this text because it reflects how I use the syntax. I common expect markup beyond what John Grubber defined as Markdown.

Our CommonMark Processor will responsible for several things. While the CommonMark specification provides a rich level of document support there are additional features I need as I segue from simple hand built HTML websites through to a static site approach to the social web. 

In the spirit of eating the food I produce I need some features to build this web book. The first feature I'll focus on it the ability to include code blocks based on source code I reference. This has the advantage be building able to test the code independently form this text while insuring that code is what is used in the text.

To facilitate this I've decided to use the following syntax.

  > `@include-code-block` `FILEPATH LANGUAGE`

Another facility I would like in the processor is the ability to rewrite links pointing at Markdown or CommonMark documents (ext. ".md") to the HTML equivalent document. This features means I can test my documents in the GitHub repository and still get HTML links when I render the website for this text.

Since I've made a provision for including code blocks it make sense that I also provide for including plain text. This let's me break up larger CommonMark files into plain text parts.

  > `@include-text` `FILEPATH`

A third and four feature I'd like to have in my processor is the ability to extract Hashtags and mentions (`@Tags`) in return them as part of the front matter of the processed CommonMark document. The goal to have a CommonMark processor that can be used along side [Pandoc](https://pandoc.org).

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

This establishes an object that makes it easy to work with front matter and the content part of a CommonMark document.

The core of the module though isn't splitting of front matter and content. The core will be a method called `process`. This method implements a series of transforms on both the content and front matter. To keep `process` method simple I will implement each transform as it's own module then when I write the `process` method I can use them to perform the sequence of transform I want.

One of the features I am interested in exploring is pulling Hashtags and Mentions (e.g. `@tag`) out form the content and integrate them into the front matter. The requires two things, an extraction function and a means of merge the resulting tags.

Both Hashtags and Mentions are similar though they play different roles on practice. They have a prefix, "#" or "@" followed by a sequence of alphanumeric characters, period and underscores. Trailing periods are stripped.  The objective is to produce a list of unique tags found in the content.  Let's call this function `extractTags` and pass it two parameters. First is the text we want to process and the second is the prefix that indicates the start of a tag. Well need a second function for consolidating tags into a unique list. That will  be called `mergeTags` and it just takes a series of tag lists and returns the unique list result. Here's how that code will look.

~~~TypeScript
// Extract tags. By default it extracts Hashtags. You may provide
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

The next thing to implement will be our include transformation. They are very similar. One includes a text file and the other includes a file wrapping it in a code blog.  The syntax for each are as follows

> `@include-text-block` `FILENAME`
> `@include-code-block` `FILENAME [LANGUAGE]`

Each of these will be implemented in their own module. Let's look at the one for `@include-text-block` first.

~~~TypeScript
/**
 * includeTextBlock takes a text string and replaces the code blocks
 * based on the file path included in the line and the language name
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
 * includeCodeBlock takes a text string and replaces the code blocks
 * based on the file path included in the line and the language name
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

Both are similar but the advantage of keeping in separate modules is that the can evolve independently and it illustrates how future transforms could be created should I need them.

To transform the CommonMark content I can add our `process` to our initial implementation of the `CommonMarkDoc` object. Here's the process method.

~~~TypeScript
// Process uses the existing CommonMark object to create a new one transforming the front matter
// and content accordingly. E.g. handling Hashtags, @Tags, `@include-code-block`.
//
// NOTE: This function uses a synchronous read to include content for code blocks. If have a slow disk
// access or lots of included code blocks this will raise the execution time of this method.
//
// If a code block can't be read it will leave the `@include-code-block` text in place.
process() {
  // Clone a copy of this object.
  const cmark: CommonMarkDoc = new Object(this) as CommonMarkDoc;

  // Handle included text blocks
  cmark.content = includeTextBlock(cmark.content);

  // Extract any Hashtags from content
  const hashTags: string[] = extractTags(cmark.content, "#");
  const atTags: string[] = extractTags(cmark.content, "@");

  // Process our Hashtags adding them to our keywords list
  if (
    cmark.frontMatter.hashTags === undefined ||
    cmark.frontMatter.hashTags === null
  ) {
    cmark.frontMatter.hashTags = [];
  }
  cmark.frontMatter.hashTags = mergeTags(cmark.frontMatter.hashTags as string[], hashTags);

  // Process our @Tags and add them to an Mentions list.
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

To use this method we'll need to add the modules required in an import block.

~~~TypeScript
import { extractTags, mergeTags } from "./extractTags.ts";
import { includeCodeBlock } from "./includeCodeBlock.ts";
import { includeTextBlock } from "./includeTextBlock.ts";
~~~

Putting it all together we have the following.

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
  // and content accordingly. E.g. handling Hashtags, @Tags, `@include-code-block`.
  //
  // NOTE: This function uses a synchronous read to include content for code blocks. If have a slow disk
  // access or lots of included code blocks this will raise the execution time of this method.
  //
  // If a code block can't be read it will leave the `@include-code-block` text in place.
  process() {
    // Clone a copy of this object.
    const cmark: CommonMarkDoc = new Object(this) as CommonMarkDoc;

    // Handle included text blocks
    cmark.content = includeTextBlock(cmark.content);

    // Extract any Hashtags from content
    const hashTags: string[] = extractTags(cmark.content, "#");
    const atTags: string[] = extractTags(cmark.content, "@");

    // Process our Hashtags adding them to our keywords list
    if (
      cmark.frontMatter.hashTags === undefined ||
      cmark.frontMatter.hashTags === null
    ) {
      cmark.frontMatter.hashTags = [];
    }
    cmark.frontMatter.hashTags = mergeTags(cmark.frontMatter.hashTags as string[], hashTags);

    // Process our @Tags and add them to an Mentions list.
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

Now this can be pulled together in a module I'm calling `cmarkprocess.ts`. It includes a "main" function to let us use this from the command line.

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

- support for Hashtags and Mentions, merging them into the document's
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

This module can be compiled into an executable by Deno using the following command.

~~~shell
deno compile --allow-read -o bin/cmarkprocess cmarkprocess.ts
~~~

The result is an executable, `bin/cmarkprocess`. This executable can read from standard input or from a file path. It will write to standard output.