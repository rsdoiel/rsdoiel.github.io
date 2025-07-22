---
title: Simplifying BlogIt
author: R. S. Doiel
abstract: |
  BlogIt is a command I've written many times over the years. At it's core
  is did a two simple things. 

  1. Copy CommonMark files into a blog directory three
  2. Use Front Matter as a source for aggregated blog metadata

  In it the new incarnation it is primarily focus on curating the front matter
  followed by copying the document into the blog directory structure. 

  1. Curate CommonMark file front matter
  2. Copy CommonMark files into the blog directory tree

  Other tools can aggregate blog metadata like [FlatLake](https://flatlake.app).
series: Deno and TypeScript
seriesNo: 9
dateCreated: 2025-07-12T00:00:00.000Z
dateModified: '2025-07-21'
keywords:
  - font matter
  - CommonMark
  - blog
datePublished: '2025-07-21'
---

# Simplifying BlogIt

__BlogIt__ is a command I've written many times over the years. Previous it was intended to perform two tasks.

1. Copy CommonMark documents into a blog directory tree
2. Aggregate metadata from the document (front matter) for my blog

I am updating the way my website and blog are is built. I am adopting [FlatLake](https://flatlake.app) for fulfill the role of aggregator. This changes the role __BlogIt__ plays.  Since I am relying on an off the shelf tool to perform front matter aggregation it becomes more important to make the front matter consist. The new priorities for __BlogIt__ are.

1. Curating the front matter of CommonMark documents
2. Publishing (staging) CommonMark documents in the blog directory tree

With curating front matter the priority some additional features will be helpful.

- check a file for well formed front matter with the minimum field requirements
- check directories for CommonMark documents and their front matter

## BlogIt command line

Here's what that might look like on the command line.

~~~shell
blogit [OPTIONS] ACTION COMMONMARK_FILE [DATE_OF_POST]
~~~

## OPTIONS

- help
- version
- license
- prefix BLOG_BASE_PATH (to set an explicit path to the "blog" directory)
- process (run the processor over the CommonMark document)

## ACTION

The following actions need to be supported in the new implementation.

- check COMMONMARK_FILE | DIRECTORY 
  - validate the front matter in a file or directory of CommonMark documents
- draft
  -  set the front matter draft attribute to true, clear the published date
- edit COMMONMARK_FILE [FRONT_MATTER_FIELD ...]
  - edit all or a subset of standard front matter fields
- process COMMONMARK_FILE
  - resolve the links to markdown files with HTML links
  - include embedded code blocks
- publish COMMONMARK_FILE
  - read front matter
  - set draft to false
  - set publish date and update modified date
  - validate front matter
  - on success, save the updates then copy into blog directory tree

## Editing front matter

__BlogIt__ is a terminal application. The programs scans the source CommonMark file for existing front matter. For each expected element the current (or default) value of the element is displayed with a prompt to edit it. If editing is chosen then the value is presented in the default editor for update. The saved value is then used to update the front matter element. A temporary file is used to communicate between __BlogIt__ and the system provided text editor.

Complex fields like keywords are provided to the text edit as YAML. The default should show the desired structure as YAML with placeholder values to be edited.

## Front Matter

The basic front matter I want to use is straight forward as my blog started almost a decade ago. Essentially it is title, author, abstract, dateCreated, dateModified, datePublished and keywords. Some blog items have a series name and number so I will support those fields as well.

__BlogIt__ will be written in TypeScript this time so I can cover my bases with the following interfaces.

~~~TypeScript
/* This describes the front matter metadata object */
interface Metadata {
    title: string; /* Optional because they are optional in RSS 2 */
    author: string;
    abstract: string; /* Maps to description in RSS 2 */
    dateCreated: string; /* ISO 8601 date */
    dateModified: string; /* ISO 8601 date */
    datePublished?: string; /* ISO 8601 date */
    draft?: boolean /* if true then BlogIt processes document as a draft */
    keywords?: string[];
    series?: string;
    seriesNo?: number;
    copyrightYear?: string; /* Four digit year */
    copyrightHolder?: string;
    license?: string; /* Text of license or a URL pointing at the license */
}
~~~

BlogIt expectations

- working directory contains a directory called "blog" (this is customary but not always the place the blog resides)
  - An explicit blog directory can be set using the `prefix` option
- The directory structure is formed as `<prefix>/<YEAR>/<MONTH>/<DAY>` where year is four digits, month and day are two digits (zero padded).
- the default date is today, may explicitly be provided by the front matter as `.datePublished`
- the date fields automatically supported are `dateCreated`, `dateModified` and `datePublished`. The `dateModified` should be updated automatically each time __BlogIt__ changes the document. `dateCreated` is set the first time the front matter is created or edited.  `datePublished` is set the first time the CommonMark document  is "published" into the blog directory tree. This also results in the draft field being removed.

Recursive blog maintenance could be supported by allowing the tool to walk a directory tree and when it encounters CommonMark document it checks and validates the front matter. This feature would ensure that the CommonMark documents are ready for FlatLake processing as I migrate my site build process.

## Checking for Front Matter

Front Matter traditionally is found at the start of the CommonMark file. It starts with the a line matching `---` and terminates with same `---` line. Anything between the two is treated as YAML.  Checking the front matter means identifying the YAML source, parsing it and the walking the object produced to compare it with the interface expected. If an expected field is missing then prompt for it and if the response is "y" create a temp file of the content (or example content) and invoke a default editor for the system. When the editor is exited the source is read back in and the front matter is updated.

## Processing the Front Matter

Aside from extracting the YAML front matter from the text, the standard Deno library (`@std/yaml`) can be used to populate the interface for validation and editing.

The task for __BlogIt__ is primarily orchestrating the use of existing Deno TypeScript modules implementing the functionality I want from __BlogIt__.

## Rewriting the CommonMark document

If the front matter changes then the CommonMark document should be written to a backup file (e.g. ".bak"). If changes are made the interface should prompt before saving the backup and writing out the updates to the source CommonMark document.

## Draft versus datePublished

If the front matter includes the value `draft: true` __BlogIt__ will exit after updating the front matter.  If `draft: true` is not in the front matter (e.g. `draft: false` or doesn't exist), the value  of `datePublished` needs to be set to the current date if not already populated. The `datePublished` is used to calculate the target path for coping the CommonMark document.

The action "draft" will set the `draft` value to `true` and clear `datePublished`.

The action "publish" will remove the `draft` attribute setting the publication and modification dates. If the front matter is valid then it will save the updated metadata and proceed to copy the revised CommonMark document into the blog tree.

## The Program

### editor module

Calling out to the system's text editor and running the editor as a sub process should be implemented as it's own module. This will allow me to improve the process independently and potentially use it in other applications.

@insert-code-block src/editor.ts TypeScript

### Front Matter

The front matter handling is implemented as it's own TypeScript module, `frontMatter.ts`. This module defines all the front matter schema and the operations that maybe performed on it including the interactive prompts. 

~~~TypeScript
/**
 * frontMatterEditor.ts module curates front matter for Common Mark or Markdown documents. It is part of the BlogIt project. 
 * 
 *  Copyright (C) 2025  R. S. Doiel
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import { parse, stringify } from "@std/yaml";
import { CommonMarkDoc } from "./commonMarkDoc.ts";
import { editTempData } from "./editor.ts";

export const metadataFields: Array<keyof Metadata> = [
  "title",
  "author",
  "contributor",
  "abstract",
  "draft",
  "dateCreated",
  "dateModified",
  "datePublished",
  "keywords",
  "series",
  "seriesNo",
  "copyrightYear",
  "copyrightHolder",
  "license"
];


export interface Metadata {
  title?: string;
  author: string;
  contributor?: string;
  abstract: string;
  dateCreated: string;
  dateModified: string;
  datePublished?: string;
  draft?: boolean;
  keywords?: string[];
  series?: string;
  seriesNo?: number;
  pubType?: string;
  copyrightYear?: number;
  copyrightHolder?: string;
  license?: string | URL;
}


function yyyymmdd(s: string): boolean {
  const dateFormatRegex = /^\d{4}-\d{2}-\d{2}$/;
  return dateFormatRegex.test(s);
}

function assignValue<T extends keyof Metadata>(
  frontMatter: Record<string, unknown>,
  field: T,
  newValue: string,
) {
  let seriesNo = 0;
  if (newValue.trim() === '') {
    delete frontMatter[field];
    return;
  }
  switch (field) {
    case "abstract":
      frontMatter[field] = newValue;
      break;
    case "draft":
      if (newValue.toLowerCase() === "true") {
        frontMatter[field] = true;
      }
      break;
    case "keywords":
      frontMatter[field] = parse(newValue);
      //FIXME: if there are no keywords then we could remove the field
      break;
    case "series":
      frontMatter[field] = newValue;
      break;
    case "seriesNo":
      seriesNo = Number(newValue) || 0;
      if (seriesNo > 0) {
        frontMatter.seriesNo = seriesNo;
      } else {
        delete frontMatter.seriesNo;
      }
      break;
    case "copyrightYear":
      if (newValue.trim() === '') {
        delete frontMatter.copyrightYear;
      } else {
        frontMatter[field] = Number(newValue);
      }
      break;
    case "dateCreated":
    case "dateModified":
    case "datePublished":
      if (newValue.trim() !== '' && yyyymmdd(newValue.trim())) {
        frontMatter[field] = newValue.trim();
      } else {
        delete frontMatter[field];
      }
      //frontMatter[field] = (new Date(newValue)).toISOString().split("T")[0];
      break;
    default:
      frontMatter[field] = newValue.trim();
  }
}

function getDefaultValueAsString(field: string): string {
  switch (field) {
    case "draft":
      //NOTE: The default value is draft === true
      return "true";
    case "dateCreated":
    case "dateModified":
      return (new Date()).toISOString().split("T")[0];
    default:
      return "";
  }
}

function getAttributeAsString(
  frontMatter: Record<string, unknown>,
  field: string,
): string {
  if (frontMatter[field] === undefined) {
    return '';
  }
  switch (field) {
    case "keywords":
      return stringify(frontMatter[field]);
    case "seriesNo":
    case "copyrightYear":
    case "draft":
      return `${frontMatter[field]}`;
  }
  return frontMatter[field] as string;
}

async function promptToEditFields(
  cmarkDoc: CommonMarkDoc,
  fields: Array<keyof Metadata>,
) {
  let keys = metadataFields;
  if (fields.length > 0) {
    keys = fields;
  }

  let changed = false;
  for (const key of keys) {
    if (cmarkDoc.frontMatter[key] === undefined) {
      assignValue(cmarkDoc.frontMatter, key, getDefaultValueAsString(key));
    }
    // NOTE: draft and pub date are connected. A draft can't have a datePublished
    if (key === 'draft' && cmarkDoc.frontMatter.draft)  {
      delete cmarkDoc.frontMatter.datePublished;
    }
    // NOTE: Need to handle the case where draft has been set to false and a pub date is not yet set.
    // It should default to today like dateCreated and dateModified do.
    if (key === 'datePublished' && cmarkDoc.frontMatter.datePublished === '') {
      if (cmarkDoc.frontMatter.draft === undefined || cmarkDoc.frontMatter.draft === false) {
        cmarkDoc.frontMatter.datePublished = (new Date()).toISOString().split("T")[0];
      }
    }
    // NOTE: we need to display the value in string form to prompt for editing.
    let val: string = getAttributeAsString(cmarkDoc.frontMatter, key);
    if (confirm(`${key}:\n${val}\nedit ${key}?`)) {
      const oldVal = val;
      //FIXME: call the editor to edit the value then convert it back usign assignValue
      val = await editTempData(val);
      if (oldVal !== val) {
        changed = true;
        assignValue(cmarkDoc.frontMatter, key, val);
      }
    }
  }
  cmarkDoc.changed = changed;
  // Make sure that date modified is updated on change
  if (cmarkDoc.changed && cmarkDoc.frontMatter !== undefined && cmarkDoc.frontMatter.dateModified !== "") {
    cmarkDoc.frontMatter.dateModified = (new Date()).toISOString().split("T")[0];
  }
}

export async function editFrontMatter(
  cmarkDoc: CommonMarkDoc,
  fields: Array<keyof Metadata>,
) {
  await promptToEditFields(cmarkDoc, fields);
}

~~~

### CommonMark module

My website is implemented using CommonMark documents that include front matter. It is helpful to be able to handle the documents 
in a uniform way. This is accomplished through a TypeScript module called `commonMarkDoc.ts`.  It defines an interface, `CommonMarkDoc` that contains three attributes, `frontMatter`, `markdown` and `changed`. The latter is a boolean flag that is set when something changes in the either `frontMatter` or `markdown`.

The module also supports an Object called CMarkDoc that include a pre-processor function called `process` providing two useful features.

- mapping of ".md" file links to ".html" file links
- including code blocks from external files

~~~TypeScript
/**
 * commonMarkDoc.ts is a module for handling CommomMark and Markdown documents with front matter.
 * It is part of the BlogIt project.
 * 
 *  Copyright (C) 2025  R. S. Doiel
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import { parse, stringify } from "@std/yaml";

export interface CommonMarkDoc {
  frontMatter: Record<string, unknown>;
  markdown: string;
  changed: boolean;
}

/**
 * stringToCommonMarkDoc takes a string and splits it into a record with frontmatter and markdown
 * @param content string, the text string to transform into a CommonMarkDoc type.
 * @return `{frontMatter: Record<string, unknown>; markdown: string }`
 */
export function stringToCommonMarkDoc(
  content: string,
): CommonMarkDoc {
  const frontMatterRegex = /^---([\s\S]+?)---/;
  const match = content.match(frontMatterRegex);
  let frontMatter: Record<string, unknown> = {};
  let markdown: string = content;
  if (match) {
    frontMatter = parse(match[1]) as Record<string, unknown>;
    markdown = content.slice(match[0].length).trim();
  }
  return { frontMatter: frontMatter, markdown: markdown, changed: false };
}

/**
 * commonMarkDocToString takes a CommonMarkDoc object and renders it into string prefixed by the front matter block.
 * @param cmarkDoc CommonMarkDoc
 * @return string
 */
export function commonMarkDocToString(
  cmarkDoc: CommonMarkDoc,
): string {
  if (Object.keys(cmarkDoc.frontMatter).length > 0) {
    return `---
${stringify(cmarkDoc.frontMatter)}---

${cmarkDoc.markdown}`;
  }
  return cmarkDoc.markdown;
}

/**
 * commonMarkDocPreprocessor takes a CommonMarkDoc object and maps the ".md" links to ".html" links
 * and includes code blocks using the `@include-code-block` directive.
 *
 * @param cmarkDoc: CommmonMarkDoc
 * @return string
 */
export function commonMarkDocPreprocessor(
  cmarkDoc: CommonMarkDoc,
): string {
      // Convert markdown links to HTML links
    const markdownLinkRegex = /\[([^\]]+)\]\(([^)]+\.md)\)/g;
    let processedMarkdown = cmarkDoc.markdown.replace(markdownLinkRegex, (_fullMatch, linkText, filePath) => {
      const htmlFilePath = filePath.replace(/\.md$/, '.html');
      return `[${linkText}](${htmlFilePath})`;
    });

    // Insert code blocks from external files
    const insertBlockRegex = /@include-code-block\s+([^\s]+)(?:\s+(\w+))?/g;
    processedMarkdown = processedMarkdown.replace(insertBlockRegex, (_fullMatch, filePath, language = '') => {
      const fileContent = Deno.readTextFileSync(filePath);
      if (fileContent) {
        return `~~~${language}\n${fileContent}\n~~~`;
      } else {
        return `Error inserting block from ${filePath}`;
      }
    });
    if (processedMarkdown !== cmarkDoc.markdown) {
      return commonMarkDocToString({
          frontMatter: cmarkDoc.frontMatter,
          markdown: processedMarkdown,
          changed: true
      });
    }
    return commonMarkDocToString(cmarkDoc);
}

/**
 * CMarkDoc implements the interface CommonMarkDoc
 * It supports working with CommonMark documents that contain front matter
 */
export class CMarkDoc implements CommonMarkDoc {
  frontMatter: Record<string, unknown> = {};
  markdown: string = '';
  changed: boolean = false;

  /**
   * parse takes a string hold CommonMark text and parses it into the CMarkDoc object structure.
   */
  parse(src: string): boolean {
    const cmarkDoc: CommonMarkDoc = stringToCommonMarkDoc(src);
    this.frontMatter = cmarkDoc.frontMatter;
    this.markdown = cmarkDoc.markdown;
    return (this.markdown.length > 0);
  }
  
  /**
   * stringify takes this object and returns a CommonMark representation including front matter.
   */
  stringify(): string {
    return commonMarkDocToString(this);
  }

  /**
   * processSync is a CommonMark pre-processor implementing two features. It performs two
   * fucntions.
   *   1. converts links to markdown files (ext. ".md") to their HTML file counter parts
   *   2. Any `@insert-code-block` will include a source code file block in the resulting
   *      source document.
   */
  processSync(): string {
    return commonMarkDocPreprocessor(this);
  }
}


~~~

### Main

The main module, `mod.ts`, will allow for processing the command line option and performing the requested actions.

~~~TypeScript
/**
 * mod.ts - The main entry point for BlogIt, a Common Mark front matter validator and curation tool. It is part of the BlogIt project.
 *
 *  Copyright (C) 2025  R. S. Doiel
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
// mod.ts
import { parse as parseArgs } from "@std/flags";
import { exists } from "@std/fs/exists";
import { checkDirectory, checkFile, createBackup, publishFile } from "./src/blogit.ts";
import { Metadata, editFrontMatter } from "./src/frontMatter.ts";
import {
  CommonMarkDoc,
  commonMarkDocPreprocessor,
  commonMarkDocToString,
  stringToCommonMarkDoc,
} from "./src/commonMarkDoc.ts";
import { licenseText, releaseDate, releaseHash, version } from "./version.ts";
import { helpText, fmtHelp } from "./helptext.ts";

async function main() {
  const appName = 'BlogIt';
  const args = parseArgs(Deno.args, {
    boolean: ["help", "version", "license", "draft", "check", "edit", "publish", "process" ],
    string: ["prefix"],
    alias: {
      h: "help",
      v: "version",
      l: "license",
      p: "prefix",
      c: "check",
      d: "draft",
      e: "edit",
      pp: "process",
    },
    default: {
      prefix: "blog",
    },
  });

  if (args.help) {
    console.log(
      fmtHelp(helpText, appName, version, releaseDate, releaseHash)
    );
    Deno.exit(0);
  }

  if (args.version) {
    console.log(`${appName} ${version} ${releaseDate} ${releaseHash}`);
    Deno.exit(0);
  }

  if (args.license) {
    console.log(licenseText);
    Deno.exit(0);
  }

  // Handle verb commands without dash prefix.
  switch (args._[0] as string) {
    case "check":
      args.check = true;
      args._.shift();
      break;
    case "edit":
      args.edit = true;
      args._.shift();
      break;
    case "draft":
      args.draft = true;
      args._.shift();
      break;
    case "process":
      args.process = true;
      args._.shift();
      break;
    case "publish":
      args.publish = true
      args._.shift();
      break;
  }

  const filePath = args._[0] as string; // Explicitly assert filePath as string
  const dateOfPost = args._[1] as string | undefined; // Explicitly assert dateOfPost as string or undefined

  if (args.check) {
    if (await exists(filePath, {isDirectory: true})) {
      console.log(`Checking the directory ${filePath}`);
      await checkDirectory(filePath);
    }
    if (await exists(filePath, { isFile: true})) {
      console.log(`Checking the file ${filePath}`);
      await checkFile(filePath)
    }
    Deno.exit(0);
  }


  if (!filePath) {
    console.error("No file specified.");
    Deno.exit(1);
  }

  // Make sure file exists and is readable before proceeding.
  if (!await exists(filePath, { isFile: true, isReadable: true })) {
    console.error(`Cannot find ${filePath}`);
    Deno.exit(1);
  }

  const content = await Deno.readTextFile(filePath);
  const cmarkDoc: CommonMarkDoc = stringToCommonMarkDoc(content);

  if (args.draft || args.edit) {
    // Set to draft is args.draft is true
    if (args.draft) {
      if (cmarkDoc.frontMatter.draft === false) {
        cmarkDoc.frontMatter.draft = true;
        delete cmarkDoc.frontMatter.datePublished;
        cmarkDoc.changed = true;
      }
    }

    // if args.edit then edit the front matter
    if (args.edit) {
      const fields = args._.slice(1) as Array<keyof Metadata>; // Explicitly assert fields as string array
      await editFrontMatter(cmarkDoc, fields);
    }

    // NOTE: either edit or draft setting caused a change, backup, write it out and exit
    if (cmarkDoc.changed) {
      if (confirm(`save ${filePath}?`)) {
        // Backup original file
        await createBackup(filePath);
        // Write output updated version
        await Deno.writeTextFile(filePath, commonMarkDocToString(cmarkDoc));
        console.log(`Wrote ${filePath}`);
      }
    }
    Deno.exit(0);
  }

  if (args.publish) {
    // OK, we must intend to engage the publication process.
    await publishFile(filePath, args.prefix, args.process, dateOfPost);
    Deno.exit(0);
  }

  // If args.process then run the preprocessor and write the output to standard out
  if (args.process) {
    let src: string = '';
    try {
      src = commonMarkDocPreprocessor(cmarkDoc);
    } catch (err) {
      console.error(err);
      Deno.exit(1);
    }
    if (src === '') {
      console.error(`no content after preprocessor ran for ${filePath}`)
      Deno.exit(1);
    }
    console.log(src);
  }
}

if (import.meta.main) {
  main().catch(console.error);
}

~~~

## Reference

- <https://github.com/rsdoiel/BlogIt>
- [Website](https://rsdoiel/github.com/BlogIt)