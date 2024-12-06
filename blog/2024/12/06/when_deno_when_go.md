---
title: When Deno+TypeScript, when Go?
createDate: 2024-11-06
pubDate: 2024-11-06
byline: R. S. Doiel, 2024-11-06
abstract: |
  Brief discussion of when I choose Deno+TypeScript versus Go for work projects.
keywords:
  - Go
  - TypeScript
  - Programming Languages
---

# When Deno+TypeScript, when Go?

By R. S. Doiel, 2024-11-06

Last month I gave a [presentation](https://caltechlibrary.github.io/cold/presentations/presentation1.html) on a project written in [Deno](https://deno.com)+[TypeScript](https://typescriptlang.org). The project included code that needed to be shared server and browser side.  At the conclusion of my talk the question came up, "When would I choose Go versus Deno+TypeScript for a project?"[^1]. The answer I came up with at the time was I would choose Deno+TypeScript when I needed to share code between server and browser. That was the question that had lead me to Deno in the first place. Deno+TypeScript shared many of the advantages of Go[^2]. I like writing in Go. The weak point in my Go based projects I thought was limited to porting Go code to JavaScript when I needed it run browser side. I went home and slept well that night. Since then I have been reflecting a little more on the question. 

[^1]: I have presented allot of Go based projects to the SoCal Code4Lib group

[^2]: Deno lets to cross compile TypeScript to binary executables. This, like Go, makes it trivial to develop and deploy. Deno provides tooling that seems inspired by the Go command.

Learning Go isn't difficult and the learning resources are pretty good. I find Go well suited to the library and archive software domain. I believe typed languages are good for working with structured metadata. Go compiles to a binary and is trivial to deploy. Go has really good tooling making it easier to write better quality code.

My colleagues and I all know Python. Python is our language of collaboration. I'm the only one that knows Go on our team of four. The leap from Python to Go isn't huge but it is a leap. I made that leap because I needed the features that Go provided at the time[^3]. Since that time the uptake in libraries and archives of coding in Go has been minimal[^4].

[^3]: This was over a decade ago, back when Go was very much a child of Robert Griesemer, Brian Kernighan and Rob Pike.

[^4]: After a decade I know only a half dozen or so Go programmers working in the library and archive domain.

My colleagues and I know JavaScript. Most of the people I've met through Code4Lib know JavaScript. TypeScript is a superset of JavaScript and Deno can compile it[^5]. The path from JavaScript to TypeScript is less of a leap and more of a stretch. Valid JavaScript is valid TypeScript after all.

[^5]: Deno can also compile TypeScript/JavaScript making your project as easy to deploy as a Go project. TypeScript is a typed programming language so offers similar benefits when working with structured metadata. Deno has tooling inspired by the Go command's tooling.

Learning Deno command is easy and not a big ask. It is certainly allot easier learning Deno than Git. Git knowledge has grown over the decade that I've known the Code4Lib community. I suspect Deno will be easier to adopt. When I take software sustainability into consideration I suspect those projects I write in Deno+TypeScript may out live the ones I've written in Go.

In hindsight I don't think my answer about sharing code between browser and server is the whole criteria. Libraries and archives tend to have a small team to zero software development staff. While Go is a very popular language in 2024 few writing software for libraries and archives know it. Go adoption in our community hasn't materialized.  In the meantime most of the people I've met via Code4Lib know JavaScript. The Go developers I know of in our community also know JavaScript.

TypeScript is a small stretch to pickup if you know JavaScript. TypeScript has good, free, online documentation[^6]. TypeScript is by definition a superset of JavaScript. If your project requires participation by other developers and you choose Deno+TypeScript over Go you have a wider pool of possible helping hands. Deno+TypeScript gives most of the benefits that Go offers today. I think this is compelling for software sustainability. 

[^6]: See [www.typescriptlang.org](https://www.typescriptlang.org/docs/) for TypeScript and [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript) for JavaScript.

When would I pick Deno+TypeScript over Go? I now have three criteria questions I ask myself.

- Do I need to share code between browser and server?
  - If yes, maybe this is a Deno+TypeScript project.
- Do I need to largest pool of programmers available to lend a hand?
  - If yes, maybe this is a Deno+TypeScript project.
- Do I want to require Go knowledge to participate in the project?
  - If yes then it might be a Go project.

If my answers are "yes", "yes", "no" then the project should proceed with Deno+TypeScript. If I answer the last one is "no" then it shouldn't be a Go project.
