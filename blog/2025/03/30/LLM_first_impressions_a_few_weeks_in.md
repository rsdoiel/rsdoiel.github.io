---
title: LLM first impressions a few weeks in
abstract: |
  A first take of LLM use for coding projects.
author: R. S. Doiel
byline: 'R. S. Doiel, 2025-03-30'
dateCreated: '2025-03-30'
dateModified: '2025-07-23'
pubDate: 2025-03-30T00:00:00.000Z
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
datePublished: '2025-03-30'
keywords:
  - LLM
---

# LLM first impressions a few weeks in

By R.S. Doiel, 2025-03-30

Writing code with an LLM is a far cry from what the hype cycle promises. It requires care. An attention to detail. It imposes significant compute resources. The compute resources requires a significant amount of electricity consumption. It doesn't bring speed of usage. Even cloud hosted LLM are slow beyond the first few iterations. If you want to find a happy medium between describing what you want and how you want it done, you need to commit to a non trivial amount of effort. Depending on your level of experience it may be faster to limit code generation to specific parts of a project. It maybe faster to code simple projects yourself.

When I compare working with an LLMs like Gemma, Llama, Phi, Mistral, Chat-GPT to traditional [RAD](https://en.wikipedia.org/wiki/Rapid_application_development "Rapid Application Development") tools the shiny of the current "AI" hype is diminished. RAD tools often are easier to operate. They have been around so long we have forgotten about them. They use significantly less compute resources. RAD tools are venerable in 2025.

The computational overhead as well as the complexity of running an integrated LLM environment that supports [RAG](https://en.wikipedia.org/wiki/Retrieval-augmented_generation "Retrieval Augmented Generation"), [agency](https://en.wikipedia.org/wiki/Software_agent "software agent explained") and [tools](https://www.forbes.com/councils/forbestechcouncil/2025/03/27/your-essential-primer-on-large-language-model-agent-tools/ "A Forbes article on tool use with large language models") is much more than a simple code generator. A case in point. The best front end I've tried so for in my LLM experiments is [Msty.app](https://mysty.app). It takes a desperate set of services and presents a near turn-key solution. You don't even need to install [Ollama](https://ollama.com) as it ships with it. It checks all the boxes, RAG, agency and tools. But this simplicity only masks the complexity. Msty is a closed source solution. It is only offered on the x86 platform. The x86 computers are known for their energy consumption. So that's a downer. There are more energy efficient ARM and RISC-V solutions out there.  A Raspberry Pi 500 can run Ollama and should also be able to run Msty.app. But since Msty.app is closed source, I can't download and compile an ARM version myself. I can't compile a version for my Windows ARM machine either. That machine has much more RAM than the Pi. It even has more RAM than the x86 Windows box I run Msty on. Unfortunately I'm out of luck, the best I can do is running Msty.app under emulation. Not ideal. Scaling up with Msty.app means using a remote hosted LLM solution. How much energy am I saving when I run remote? When things go South the complexity costs in diagnosing problems with distributed systems is more than running things on a single box. I understand their business model.  Providing a Freemium version is a classic loss leader. People who like Msty will pay to upgrade to paid plans. From a big picture perspective it makes less sense to me.

- How do we get more bang for the energy consumed?
- Does the LLM enhanced coding environment push development forward?
- Are LLM yet an appropriate tool in the toolbox of our profession?
- Why am I continuing to explore using LLM for code development?

A few weeks in I am looking for reasons to continue exploring LLM for code generation. I have a much better understanding of how it could fit into my approach to software development. I see reason to be hopeful but I also continue to have serious reservations.

My hands and wrists aren't the same as when I started in my career. I am hoping that an LLM can reduce my typing and reduce the risk of [RSI](https://en.wikipedia.org/wiki/Repetitive_strain_injury "repetitive strain injury"). I am also hoping that I can reduce the need for close reading and therefore eye strain. I'm currently experimenting with taking advantage of the slowness of the LLM eval cycle. Accessibility features in the OS will read back parts of the screen for me. Are these features worth burning down forests, floods and other climate driven issues? No they are not. Am I convinced that these LLM benefits will pan out? No. I'm hoping this aspect of LLM usage gets studied. I'm generally interested in tools that are a good ergonomic benefit for developers over the long haul. We still need a livable planet regardless.

Without using an LLM my normal development approach is to write out a summary of what I want to do in a project. I clarify the modules I want and the operations I need to perform. I code tests before coding the modules.  For many people this approach appears upside down. I've found this inverted approach yields better documentation. Writing the documentation clarifies my software architecture and how I will organize the required code. Writing tests first means I don't write more code than needed. The result is software I can look at a year or more later and still understand.

The first step in my current approach is well suited to adopting an LLM for code generation.  The LLM I've tried are decent at writing minimal test code. A good front end to Ollama or other LLM runner can automate some of the development cycle. The process is not fast. Once you get beyond the trivial the process is slow. It is slow like the compilers I used in my youth. It works OK for the most part. I can speed things up a little with faster hardware. That cost is increased electricity consumption. 

An intriguing analog to developing with an LLM environment is [Literate programming](https://en.wikipedia.org/wiki/Literate_programming) advocated by [Knuth](https://en.wikipedia.org/wiki/Donald_Knuth). The LLM I've tried have used a chat interface. Even if the chat conversation is read back there is allot of duplicate text to listen to. Current chat responses are usually presented in Markdown with embedded code blocks. This is feels like a simplified version of Knuth's approach using TeX with embedded code blocks. It feels familiar to me. The Chat UI model presents many of the challenges I remember trying out literate programming. For some people a literate approach resulted in better code. I'm not sure it was true for everyone. For some an LLM might encourage more thinking as dialog can be useful that way. It might be easier to be more objectively when vetting because the ego isn't challenged in the generated code. It is hard to say with certainty.

I have found one significant advantage of the LLM generated code. It is a byproduct of large training sets. The generated code tends to look average. It tends to avoid obfuscation. It mostly is reasonably readable. If the computing resources were significantly lower I'd feel more comfortable with this approach over the long run. The current state needs radical simplification. The LLM development environment is overly complex. If it is running on my hardware why does it need to be implemented as a web service at all? I think allot of the complexity is intentional. It benefits consolidation of tooling in the cloud. The cloud where we rent the tools of our trade. LLM development environment's complexity and energy consumption weight heavily on me as I explore this approach. It is too early to tell if it should be a regular tool in my toolbox. It is too early to know if it is useful for sustainable software practices.