---
title: LLM first impressions a few weeks in
abstract: |
  A first take of LLM use for coding projects.
author: R. S. Doiel
byline: R. S. Doiel, 2025-03-30
dateCreated: 2025-03-30
dateModified: 2025-03-30
pubDate: 2025-03-30
---

# LLM first impressions a few weeks in

By R.S. Doiel, 2025-03-30

Writing code with an LLM is far cry from what the hype cycle promises. It requires care. An attention to detail. It imposes significant compute resources. The compute resources required bring a significant amount of electricity consumption. It doesn't bring speed of usage. Even cloud hosted LLM are slow beyond the first few iterations. If you want to find a happy medium between describing what you want and how you want it done, you need to commit to a non trivial amount of effort. Depending on your level of experience it may be faster to limit code generation to specific parts of a project. In early 2025 it maybe faster to code simple projects yourself.

When I compare working with an LLMs like Gemma, Llama, Phi, Mistral, Chat-GPT to traditional [RAD](https://en.wikipedia.org/wiki/Rapid_application_development "Rapid Application Development") the shiny of the current "AI" hype is diminished. RAD tools often are easier to operate. They have been around so long we forget about them. They use significantly less compute resources[^1]. RAD tools are venerable in 2025.

The computational overhead as well as the complexity of running an integrated LLM environment that supports [RAG](https://en.wikipedia.org/wiki/Retrieval-augmented_generation "Retrieval Augmented Generation"), [agency](https://en.wikipedia.org/wiki/Software_agent "software agent explained") and [tools](https://www.forbes.com/councils/forbestechcouncil/2025/03/27/your-essential-primer-on-large-language-model-agent-tools/ "A Forbes article on tool use with large language models") is much more than  a simple code generator[^2]. A case in point. [Msty.app](https://mysty.app) is a nice front end environment for working with LLM on your own hardware. It unfortunately is restricted to the x86 platform. So no go running the front end on energy efficient hardware like a Pi 500. You can point to cloud services but they are not particularly low energy consumers either. I am left with questions. 

- How do we get more bang for the energy consumed?
- Does the LLM enhanced coding environment push development forward?
- Are LLM yet an appropriate tool in the toolbox of our profession?

[^1]: Delphi's RAD tooling and Lazarus' RAD tooling can run on desktop computers from a decade or more ago. The hardware vendors want to sell us "AI computers" and "CPU" because of the increase compute demands of running large LLM software. You can rent GPU as a service because the costs in terms of hardware and energy consumption from Big Tech's LLM obsession.

[^2]: Code generation goes back to the at least to 1950 or 1960. Code generation was well established practice before the Go community picked it up over a decade ago to deal with the routine boiler plate. I routinely create code templates and run it through Pandoc. These I can even use on a Raspberry Pi without it breaking a sweat.

Why am I continuing to explore using LLM for code development?

My hands and wrists aren't the same as when I started in my career. I am hoping that an LLM can reduce my typing and reduce the risk of [RSI](https://en.wikipedia.org/wiki/Repetitive_strain_injury "repetitive strain injury"). I am also hoping that I only need to do detailed reading after waiting for code to be generated (i.e. I'm taking advantage of the slowness of the LLM eval cycle). My hope is for lowered eye strain. Is that worth burning down rain forests? No it is not. Am I convinced that these LLM benefits are true? No. I'm hoping this aspect of LLM usage gets studied. I'm interested in tools that are a good ergonomic benefit for developers over the long haul.

Without using an LLM my normal development approach is to write out a summary of what I want to do in a project. I clarify the modules I want and the operations I need to perform. Then I code tests before coding the modules.  For many people I think this approach appears upside down. When I started as a programmer I wrote code first to some general notion of what I thought the client wanted. I've found this inverted approach yields better documentation. Writing documentation first clarifies my software architecture and how I will organize the code needed. Writing tests first means I don't write more code than needed. The result is software I can look at a year or more later and still understand.

The first step in my current approach is well suited to adopting an LLM for code generation.  The LLM I've tried are decent at writing minimal test code. Tooling can automate some of the development loop generating code that can actually run and pass tests. The process is not fast. It reminds me of the slow compilers of my youth. It works OK for the most part. You can speed things up with faster hardware. Then you are also using more electricity. 

- Are we reinventing Workstations with "AI computers"?
- You can rent LLM services and hardware in the cloud, is that really cost and energy effective?

An intriguing analog to developing with an LLM environment is [Literate programming](https://en.wikipedia.org/wiki/Literate_programming) advocated by [Knuth](https://en.wikipedia.org/wiki/Donald_Knuth). The LLM I've tried have used a chat interface. A document and editor metaphor interface may be better suited then the traditional chat UI. A change in summation would be required. Current chat responses are usually presented in Markdown with embedded code blocks. This is analogous to a simplified version of what Knuth created using TeX with embedded code blocks. With the LLM your prompts trigger a narrative of code and function. That feels familiar to me. The challenges of working with an LLM is much like the challenges of literate programming. An LLM might encourage us to think more about what we're trying to do and perhaps more objectively vet the resulting code without engaging our egos.

A significant advantage of the LLM generated code is a byproduct of large training sets. The generated code tends to look average. It tends to avoid obfuscation. It mostly is reasonably readable. If the computing resources were significantly lower I'd feel more comfortable with this approach over the long run. The current state needs radical simplification. The LLM development environment is overly complex. That complexity only benefits consolidation in the cloud where we are renting the tools of our trade. LLM development environment's complexity and energy consumption weight heavily on me as I explore this approach. It is too early to tell if it should be a regular tool in the developers' toolbox of sustainable software practices.




