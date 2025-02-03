---
title: Moving beyond git template repositories with CodeMeta
createDate: 2025-01-30
updateDate: 2025-02-03
pubDate: 2025-01-31
byline: R. S. Doiel
author: R. S. Doiel
abstract: |
  An exploration of using CodeMeta objects to generate of software artifacts as an alternative to Git template repositories.
keywords:
  - software development
  - programming
  - CodeMeta
---

# Moving beyond git template repositories with CodeMeta

By R. S. Doiel, 2025-01-31 (updated: 2025-02-03)

A nice feature of GitHub is the ease in starting a new repository with a complete set of documents[^1]. This feature creates a problem. The "template" documents require editing. Then they require more editing to keep them from being stale. If you're serious about keeping documentation up to date then the copy edit work must be continuous. Copy edit work is tedious. Is there a path beyond the git repository templates that avoid stale [software artifacts](https://en.wikipedia.org/wiki/Artifact_(software_development))?

[^1]: The feature is built around using another Git repository as a template. GitHub has a nice UI for this, essentially it is forking the "template repository" when you create your new repository.

Existing development tools suggestion a solution. For decades software developers have had tools to extract documentation from the comments in source code.  [Knuth](https://en.wikipedia.org/wiki/Donald_Knuth) pioneered this with his [literate programming](https://en.wikipedia.org/wiki/Literate_programming) approach. A simplified take on this is [Javadoc](https://en.wikipedia.org/wiki/Javadoc) used in the Java programming community. Today most open source programming languages have similar tools available. In 2025 it is trivial to generate source code documentation directly from the comments in your source code. Can an approach like this be used for more of our software artifacts?

I believe leveraging [CodeMeta](https://codemeta.github.io "See the section titled, Motivation"), developed by the research programming community, gives us a path forward for general software development.

## How is CodeMeta relevant? 

The CodeMeta data is meant to be machine readable and human manageable. That's a developer sweet spot. The CodeMeta object let's you track metadata like name, description, version, authorship and contributors. It includes where the project source repository is hosted and the license used. Over time the list of metadata attributes in the CodeMeta object has grown. Today we have a long list of a project's metadata that can be tracked and acted upon.

When I started including CodeMeta files in my projects at Caltech Library I did so at software release. It was a task to do at the end of the process like the task of reviewing and updating the cloned documentation files. Treating the CodeMeta as an after thought created a burden. It was a disincentive to adopting CodeMeta. 

I think we make the CodeMeta object relevant to developers by treating it as primary source code. Editing it should be the first rather than last thing updated before a release. **An accurate CodeMeta file is actionable.** Ignored this and you ignore CodeMeta's super power.

Can CodeMeta be used to help lower the documentation burden? Yes.

In 2025 there is enough information in a complete CodeMeta object to create structured documents. This includes documents like a README and INSTALL. Keeping track of the content as metadata can lower the effort in managing stale documentation. It may be enough to eliminate the need for git template repositories. At a minimum it can shrink what is needed from template repositories.

Here's the steps I used to take setting up a project.

1. Write the README
2. Document how the software will work
3. Write tests to confirm the software works
4. Write the software
5. Create/update my software artifacts to reflect the current state such as the codemeta.json file.

Repeat as needed. The last step was always tedious. The longer a project is around the more artifacts need to be managed. It was easy to want to short cut that last step.

Here's what I have been experimenting with.

1. Create or update the CodeMeta file
2. Document or update how the software should work
3. Create or update tests to confirm the software works as documented
4. Write or update the software to pass the tests
5. **Generate** additional software artifacts from the CodeMeta document.
  - README.md, INSTALL.md, installer.ps1, installer.sh, about.md, CITATION.cff, version.(py|js|ts|go)

Step five is automated. In practice step five can be integrated with your standard build processes. Us humans focus on steps one through four. Life just got a little easier for the busy developer.

Several questions are suggested by this proposal.

1. How do I make it easy to create and update the CodeMeta file?
2. How do I generate the software artifacts?
3. What artifacts can be generated in a reliable way?

The CodeMeta object is stored as a JSON document in your repository. That means you can readily build tooling around it.

Today you can use the CodeMeta [generator](https://codemeta.github.io/codemeta-generator/) to bootstrap the creation of a CodeMeta file.  If you're willing to do some cut and paste work the generator can even be used to maintain your CodeMeta file.  

What about generating our artifacts?

For the last few years I've relied on Pandoc templates, see [codemeta-pandoc-examples](https://github.com/caltechlibrary/codemeta-pandoc-examples). I use Pandoc and these templates to generate files like CITATION.cff, about.md, installer scripts and version files for the Python, Go and TypeScript programming languages. The trouble with this approach is Pandoc tends to be well knowing in the data science community but not in the general developer community. The Pandoc template language is obscure. This has lead me to believe new tools are needed beyond Pandoc and templates.

***

## CMTools

I recently started prototyping two programs for working with [CodeMeta](https://codemeta.github.io) objects. The prototype code is available at [github.com/caltechlibrary/CMTools](https://github.com/caltechlibrary/CMTools). The two programs are for editing (`cme`) and for transforming (`cmt`) the CodeMeta object. I am currently testing the prototypes in selected Caltech Library projects.

### What challenges have the prototypes raise?

The CodeMeta object is sprawling. `cme` was started as command line alternative to the generator.  It was initially designed with an interactive, prompt and response, user interface. It would iterate over all the top level attributes prompting for changes. This can be tedious. I quickly added support to shorten the process by including a list of specific attributes to edit. 

~~~shell
cme codmeta.json                       # <-- iterate over all
cme codemeta.json version dateModified # <-- just listed attributes
~~~

The prompt and response approach works well for simple attribute types like name, description and version. The more complex attributes like author or contributor were challenging. To avoid the need to increase the types of prompts or be forced into a menu system I'm experimenting with using YAML to display the current value and accept YAML as the user response. YAML is much easier to type and copy edit than JSON. It is easy to transform into JSON. The downside is you need to know the structure and attribute names ahead of time. That gives `cme` a training cost.

Multi line values are tricky to work with if you rely on standard input. To address this I added a feature to allow the use the editor of your choice.  If you are on macOS or Linux the default editor is nano. On Windows it is notepad.exe.  You can pick a different editor by setting the EDITOR environment variable.  In the example below I've chosen the [Micro Editor](https://micro-editor.github.io) for setting values. It didn't solve the problem of knowing the YAML attributes in advance but does make it easier to copy edit the YAML. Micro Editor is Open Source and available for macOS, Linux and Windows. Support for other editors could be added. Further prototyping and development work is needed to support alternatives to editing YAML.

On macOS and Linux

~~~shell
export EDITOR=micro
cme codemeta.json author -e
~~~

or on Windows

~~~ps1
Set-Variable EDITOR micro
cme codemeta.json author -e
~~~

In the 0.0.9 release of the `cme` prototype I added the ability to set the attribute values from the command line. This has helped in automated environments. CodeMeta attribute name is used as the key. An equal sign, "=", is the delimiter. What follows the equal sign is treated as the value. This works well for simple fields, e.g. version, dateModified.

~~~shell
cme codemeta.json version="0.0.2" dateModified="2025-01-30"
~~~

Complex attribute editing using this approach is very challenging.

### What can CMTools generate?

The `cmt` prototype has limited abilities. It can render about.md and CITATION.cff files. It can generate "version" source code files for Python (version.py), Go (version.go), TypeScript (version.ts) and JavaScript (version.js). I am actively working on porting the remaining Pandoc templates from codemeta-pandoc-examples to `cmt`. README and INSTALL will be added after the template port is complete.

~~~shell
cmt codemeta.json about.md CITATION.cff version.py \\
  README.md INSTALL.md installer.sh installer.ps1
~~~

## What's next?

CMTools is at an early stage of development (January 2025). The project is focused finding the balance of editing and generating. Improvements will flow base on our usage.

The [v0.0.14 release](https://github.com/caltechlibrary/CMTools/releases/tag/v0.0.14) includes the basic features discussed in this post for both `cme` and `cmt`. RSD 2025-02-03