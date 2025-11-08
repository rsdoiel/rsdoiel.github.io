---
title: Half life of Frameworks
author: R. S. Doiel
postPath: blog/2025/11/07/half-life-of-frameworks.md
dateCreated: "2025-11-07"
dateModified: "2025-11-07"
datePublished: "2025-11-07"
description: |
  A discussion of the problems of adopting third part frameworks in programming projects.
keywords:
  - frameworks
  - libraries
  - programming
  - front-end development
---

# Half-life of Frameworks

By R. S. Doiel, 2025-11-07

[A Kind of farewell to the web](https://webdirections.org/blog/a-kind-of-farewell-to-the-web/) is an interesting read on front-end development. It's thoughtful and like other similar blog posts I think important.

Posts like this ask an important question, "What happens when a framework designed to solve a problem is now the problem?"

Software libraries and frameworks often emerge by taking something challenging or tedious and provide a solution that is convenient. If successful, they acquire a specific success problem. The become both a technical solution and a form of cultural identity. This often starts of innocently enough, perhaps a job posting with the framework as a desired skill set. Once the framework is tied to the job though institutionalization sets in. The frameworks is fused into the organizational structure and as a technical solution.  Initially this might seem like a good thing.  Unix I think is a good example of a collection of operating system approaches and libraries that vastly simplified it's original requirement as a multi user text processing platform. Fast forward to today, and the operating system on your phone, tablet or personal computer to your home thermostat or automobile is running a multi user system. That multi user solution also is, by its nature, vulnerable to attack. Who is controlling your device(s) today is an open question. Is it you, the vendor, a service, an organization like a government or something more nefarious? The success of Unix also created a new set of problems. How do we keep multi user systems safe?  This success issue isn't unique to operating systems. It holds true for choices of programming languages and the libraries, frameworks and packages associated with them. In my forty years of practice I've found it helpful to avoid the cultural linkages when providing software solutions. It's easy to learn a new library, it's difficult to change people's identity, culture and habits. 

The way I avoid it is to first considering the problem I'm trying to solve. Looking at the computing devices, operating system and software languages I have at hand. Account for who I want to collaborate with and their preferences for devices, operating systems and programming languages. Once I know the platform and language take a good look at the standard set of libraries, packages or modules.  If the problem can be **simplified enough** using the standard solutions then they're usually the right libraries, packages or models to work with.  This has proven true in my experience even when a new shiny package pops on the scene. The new shiny often proves to be but a siren's song.  That raises the question of why is the standard often the right choice?  

Programming languages, like human languages generally, evolve overtime. Standard libraries tend to evolve with the needs of the language. This results in a relationship of idioms. Idioms make it easier to quickly understand the proposed solution represented in the source code of your program. Idioms turns out to be extremely helpful in communicating with other developers. It is even helpful communicating with your future self.

An often over looked aspect of programming language usage is that it has two audiences. The first audience is people. I think it is the most important. The second is the device and operating system where the program is executed. While the second audience is essential to solving the problem, the first audience is essential to evaluating the solution, implementing the solution and sustaining the correctness of the solution over time. It's also what us humans interact with. Idioms are important in all human languages included those invented to represent how a computer or computation should proceed. I am not suggesting you never use a non-standard framework. I am suggesting **you must know the cost when choosing a third party framework**.

Another important thing to remember is that choosing a framework doesn't happen once.  It happens each time you revisit the code. Written programs are like written prose. Almost always the text can be improved. As languages evolve they will pickup features that the communities have already widely adopted in third party frameworks. That is because successful framework address deficits in the language implementation.

jQuery is a good example of a framework addressing browser JavaScript twenty years ago. The jQuery library adopted the CSS selector as a means of identifying elements in the DOM. That single feature made working with the DOM much easier. It also unified and encouraged a closer look at the role of CSS in relationship to the browser experience. JavaScript and CSS came into symbiosis. That feature even became compelling compared to other competing frameworks. The CSS selector syntax eventually became a part of the JavaScript standard DOM implementation, example `let h1Elements = document.querySelectAll("h1");`.  You don't need jQuery or other framework to work with selectors and the DOM. Today most of the problems jQuery addressed are better solved using plain old JavaScript or CSS.

Recent popular frameworks are also not aging well. Look at the current state of React. jQuery's success arc is predictive of React's success arc. Is data binding really an issue today? Web Components are widely supported an address the UI binding issues. Even if you chose React with its limitations it will block your progress towards a better UI. That's the focus of the article sighted at the start of the post. React has reached problem state. Like jQuery, it'll still be listed on job requirements or in promotion justifications. It is often recommended when you use a large language model to generate JavaScript and CSS source code. React is beyond it's half-life.

Today lots of people know React. But does anyone remember [MooTools](https://en.wikipedia.org/wiki/MooTools), [Prototype](https://en.wikipedia.org/wiki/Prototype_JavaScript_Framework) or [YUI](https://en.wikipedia.org/wiki/YUI_Library)?  Anyone remember [Jaxer](https://en.wikipedia.org/wiki/Aptana#Aptana_Jaxer) from Aptana? They were the React of their era. The rise and fall of successful third party frameworks is a cautionary tale.  

By sticking with or returning to the language's standard modules you accrue an under valued advantage. Languages and the standard libraries tend to remain compatible over long periods of time. Languages grow dormant less frequently than frameworks. The features themselves often see performance improvements or enhancements. A framework beyond its half-life will always struggle to keep up. React, like so many before it, is that that point now.

To be clear, I'm not dogmatically say don't use a third party frameworks. I am saying non-standard frameworks have a half-life. You need to evaluate the costs with each 3rd Party framework your project requires. Once you use one you have immediately accrued technical debt. The bill will come due. That the bill comes due far sooner than you'd expect. Always ask can your project afford pay it? Ask yourself how much will it cost to move your source code towards the standard libraries?
