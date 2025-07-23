---
title: 'Deno 2.1.7, Project Idioms'
byline: R. S. Doiel
author: R. S. Doiel
abstract: >-
  Notes on some of the file and code idioms I'm using with Deno+TypeScript
  projects.
createDate: 2025-01-29T00:00:00.000Z
keywords:
  - Deno
  - TypeScript
  - Projects
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2025-01-29'
dateModified: '2025-07-23'
datePublished: '2025-01-29'
---

# Deno 2.1.7, Project Idioms

I've noticed a collection of file and code idioms I've been used in my recent Deno+TypeScript projects at work. I've captured them here as a future reference.

## Project files

My project generally have the following files, these are derived from the [CodeMeta](https://codemeta.github.io) file using [CMTools](https://caltechlibrary.github.io/CMTools).

codemeta.json
: Primary source of project metadata, used to generate various files

CITATION.cff
: used by GitHub for citations. version, dateModified, datePublished and releaseNotes


about.md
: A project about page. This is generated based on the codemeta.json file.

README.md, README
: A general read me describing the project and pointing to INSTALL.md, user_manual.md as appropriate

INSTALL.md
: These are boiler plate description of how to install and compile the software

user_manual.md
: This is an index document, a table of contents. It points to other document including Markdown versions of the man page(s).

For TypeScript projects I also include a following

version.ts
: This hold project version information used in the TypeScript co-debase. It is generated from the codemeta.json via CMTools.

helptext.ts
: This is where I place a function, `fmtHelp()`, for rendering response to the "help" command line option.

I'm currently ambivalent about "main.ts" file which is created by `deno init`. My ambivalent is that most of my projects wind up producing more than one program from a shared code base. a single "main.ts" doesn't really fit that situation.

The command line tool will have a TypeScript with it's name. Inside this file I'll have a main function and use the Deno idiom `if (import.meta.main) main();` to invoke it. I don't generally put the command line  TypeScript in my "mod.ts" file since it's not going to work in a browser or be useful outside my specific project.

mod.ts
: I usually re-export modules here that maybe useful outside my project (or in the web browser).

deps.ts
: I use this if there are allot of files consistently being imported across the project, otherwise I skip it.

## What I put in Main

I use the main function to define command line options, handle parameters such as data input, output and errors. It usually invokes a primary function modeled in the rest of the project code.

Here is an example Main for a simple "cat" like program.

~~~TypeScript
import { parseArgs } from "jsr:@std/cli";
import { licenseText, releaseDate, releaseHash, version } from "./version.ts";
import { fmtHelp, helpText } from "./helptext.ts";

const appName = "mycat";

async function main() {
  const app = parseArgs(Deno.args, {
    alias: {
      help: "h",
      license: "l",
      version: "v",
    },
    default: {
      help: false,
      version: false,
      license: false,
    },
  });
  const args = app._;

  if (app.help) {
    console.log(fmtHelp(helpText, appName, version, releaseDate, releaseHash));
    Deno.exit(0);
  }
  if (app.license) {
    console.log(licenseText);
    Deno.exit(0);
  }
  if (app.version) {
    console.log(`${appName} ${version} ${releaseHash}`);
    Deno.exit(0);
  }

  let input: Deno.FsFile | any = Deno.stdin;

  // handle case of many file names
  if (args.length > 1) {
    for (const arg of args) {
      input = await Deno.open(`${arg}`);
      for await (const chunk of input.readable) {
        const decoder = new TextDecoder();
        console.log(decoder.decode(chunk));
      }
    }
    Deno.exit(0);
  }
  if (args.length > 0) {
    input = await Deno.open(Deno.args[0]);
  }
  for await (const chunk of input.readable) {
    const decoder = new TextDecoder();
    console.log(decoder.decode(chunk));
  }
}

if (import.meta.main) main();
~~~

## helptext.ts

The following is an example of the [helptext.ts](helptext.ts) file for the demo [mycat.ts](mycat.ts).

```TypeScript
export function fmtHelp(
  txt: string,
  appName: string,
  version: string,
  releaseDate: string,
  releaseHash: string,
): string {
  return txt.replaceAll("{app_name}", appName).replaceAll("{version}", version)
    .replaceAll("{release_date}", releaseDate).replaceAll(
      "{release_hash}",
      releaseHash,
    );
}

export const helpText =
  `%{app_name}(1) user manual | version {version} {release_hash}
% R. S. Doiel
% {release_date}

# NAME

{app_name}

# SYNOPSIS

{app_name} FILE [FILE ...] [OPTIONS]

# DESCRIPTION

{app_name} implements a "cat" like program.

# OPTIONS

Options come as the last parameter(s) on the command line.

-h, --help
: display help

-v, --version
: display version

-l, --license
: display license


# EXAMPLES
~~~shell
{app_name} README.md
{app_name} README.md INSTALL.md
~~~
`;
```

## Generating version.ts

The [version.ts](version.ts) is generated form two files, [codemeta.json] and [LICENSE] using the CMTools, `cmt` command.

~~~
cmt codemeta.json veresion.ts
~~~