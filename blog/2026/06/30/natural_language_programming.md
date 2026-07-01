---
author: R. S. Doiel
dateCreated: "2026-06-20"
dateModified: "2026-06-30"
datePublished: "2026-06-30"
keyword:
    - software development
    - language models
postPath: blog/2026/06/30/natural_language_programming.md
title: Natural Language as programming language

---


# Natural Language as programming language

By R. S. Doiel, 2026-06-30

The goal of using natural language for computer programs was old when I was an undergrad studying computer science last century. With the advent of large language models I think we're getting close to achieving this goal. Language model systems with a human in the loop can produce useful software. Human in the loop is key. With a human in the loop the language model system becomes a tool like a compiler or interpreter. I've spent much of the past six months experimenting and working using conversational English as a programming language. I have some interesting takeaways from those experiences.

- core computer science lessons from over five decades still hold
- the life cycle of software development has been renewed in importance

I have seen benefits from using language model systems to write code. I have seen increased cost in using language model systems successfully. This can be measured in both monetary cost and in communications overhead[^1].

[^1]: The lessons from Fred Brooks', "The Mythical Man-Month", hold true because communication overhead remains a critical consideration.

## Managing the noise

Code and documentation can easily be generated using language models. It doesn't mean it is either useful or meaningful. That is why it becomes critical to manage the noise level in the communication channel. The content quality, content structure and organization can make the difference between "AI slop" and something useful. In the last six months I have found techniques that help across the models or systems I've used[^2].

[^2]: The majority of my testing focused on Mistral Vibe and Claude Code but included small language models as well as free versions including those offered by Microsoft and Google.

- take a phased approach and ensure clear boundaries between phases, models can only process so much context
- acknowledge that **being a good editor** is as important as **being a good programmer** when using language model systems
- be prepared to slow down
  - carve thinking time before engaging the model
  - carve out project time for reviewing model results (this takes longer than you plan)
  - use more than one model (one can be used to critique the other)
  - model results **require human vetting** (Humans are responsible for stopping the AI slop)
- understand that you are teaching
  - successful software development often involves discovery
  - the developer learns the problem before a solution is possible
  - you are now obliged to teach that to the model system

Arriving at a development approach is important. As an example, I might have held off on a literature review until I hit a specific part of the project that required it. With language models you fare better having covered that ground early and making it available in your design, decision and planning phase of your project.

I often start with a literature review if I know I will use a language model system. That way I have a small corpus to teach the model.
Once a corpus is assembled, I split the development cycle between a documentation phase and an implementation phase. The documentation phase is characterized by three documents collaboratively developed using the model.

- Design
- Decisions
- Plan (implementation plan)

Using the conversation interface of the model I start with a general discussion of these three activities and direct the model through to writing the specific documents. The reason for the split is that even large language models like Claude or Mistral have a finite context they operate effectively with. During the design phase I keep the model from jumping to implementation, focus on the core design concepts and record the decisions made working through the design process. These are used to determine the implementation plan. The plan will be used for implementation. It is important to review and refine the design, decision and planning documents before proceeding to implementation. I found it helpful (and cheaper) to keep the design, decision and planning phase as a separate model session from the implementation phase. It's all about managing the current context.

I still start the implementation session having the model review the implementation plan. If anything needs to be clarified I can refer to specific design or decision choices I've made. The goal is to keep context free to allow the model context space to work. An important step before allowing the model to write code is to reinforce the test-driven development approach. Always write the test first, then write running code. When debugging, write the test that confirms the bug first before writing the fix.  If you allow the model to deviate it is likely the model will "correct the test" rather than implement what was requested or fix the bug. As tempting as it is to allow automatic approval of all model actions doing so radically increases your token budget[^3].

[^3]: The metaphor of "vibe coding" has misled many people into thinking you have self-driving models. That is far from my experience. You need to remain in the driver's seat.

### Workflows are noise abatement

I had good success managing the noise by using a two phase workflow.

1. Design, decisions and planning
2. Implement using test-driven development

Inevitably I found myself in the implementation phase where there is an ambiguity in my design or planning documents. To get back on track I would wrap up the current session recording all open questions in a `TODO.md` file. In a new session I'd start at the top of the loop with design, decisions and planning based on the existing design, decision and planning documents augmented by my `TODO.md` file with the questions or problems formatted as a checklist. This new cycle then became about refining the design and plans, and recording the new decisions. Then I would start a new session and reengage the implementation process where I previously left off. The modified loop was repeated until I had the results I was looking for.

## Use the tools available

One thing I've found exciting about language models is their ability to understand structured data and use existing programs to process it. As an example, in my projects I usually include a codemeta.json file. This file contains a structured JSON document that describes the project in general terms. I have a tool, [CMTools](https://github.com/caltechlibrary/CMTools), which can read that file and generate most of the common project artifacts. I don't need an AI model to do that. It's a solved problem. Commercial language models bill around token use. If the language model knows how to use a tool that saves processing tokens you're saving money.  The point I'm making is, if you have a specialty tool that can do the heavy lifting, let that tool do it. You just need the model to learn how to use that tool. That's where model skills come in. You can write up a description of how to use your specialty tool and that can save you money, time and effort in the long run.

It remains equally important to let the tools provide spaces for the humans in the loop. As an example I don't let models do the commit or push with Git repos. First they don't need to burn tokens on predictable text exchanges at the shell prompt. Second, these are good points to review the project's current state and what the model has accomplished to date. It's a natural space. Similarly if you have a tool that takes a long time to return results, use the time to review what the model system provided. It's a natural space so take advantage of it[^4].

[^4]: I notice there are times when the model system will try to short-	circuit your workflow, Mistral Vibe was aggressive in wanting to generate code. It's important to stop it. The extra token costs of wasted model effort ultimately mean more review time for you. We all have limited working hours as it is.
 
## Remember your audiences

When working with language models we have an additional audience to consider. Normally when I write documentation I consider developers and users. When working with language model systems I have a new audience, the language model. Documentation is actionable now. That's a key takeaway from using natural language as a programming language. It has caused me to shift documenting things to being a first step rather than a last one. It might feel upside down but like test-driven development it turns out to be an important way of keeping the model system on track. This is true at all stages of the project's life cycle. Documentation now drives development; it drives bug fixes and it drives enhancements. Understanding that documentation is now a necessity rather than a nice to have is a key indicator of whether or not my projects have been successful. It's why natural language as a programming language takes so much time. It's why we have an exhausting communication overhead when working with language model systems. Exploring this challenge led me to the design, decisions and planning documents I use today. When combined with managing my model's context it has proven to be effective in the projects I've been working on since the start of the year.

## Project Workspace

Projects rarely exist in total isolation. They tend to have interfaces with each other. It can be helpful to have those related projects organized such that the model can easily find them when needed. The commercial model clients will gladly read anything from anywhere on your local computer systems. That's a problem I'll leave for a future post. Putting things in a workspace directory minimizes the need to do that. In a workspace I populate it with the source repositories of my projects. I have a "reference" folder that contains any reference documentation or source files that might be needed. I have an agents folder where I keep information that can be shared between model systems. The workspace also contains the base instructions on how I want the models to behave, such as a CLAUDE.md or VIBE.md file. I have a language-model-generated knowledge base (e.g. agents/knowledge.db) implemented as a SQLite3 database.  I create a skill for accessing and updating it. I put the skill in an agents/skills directory. This allows more than one model system to collaborate indirectly through shared knowledge. I've found including session summaries in agents/sessions and "memory files" in agents/memory to be helpful too. At the end of each model session I also have the model generate a "hand off" document in agents/hand-off. This lets the next session have some context to continue work or another model system to do the same.

If you have local model systems, you can use this "agents" directory structure to share knowledge between them as well as between the commercial systems like Claude Code or Mistral Vibe. It's a win-win in that sense. Since the documents are just text files (or SQL queries for the knowledge base) it allows us humans to easily keep tabs on things too.

The goal is to surround the model system with useful things. 

- session documentation, this includes hand off and session summarizing
- common skills with tool use instructions (focus on your discipline's specialty tools)
- skills are also a way to have models follow a methodology
- model "memory"[^5] documents can be shared, bridging the gap between tools, skills and prompt instructions
- Use SQLite3 to create a shared knowledge base, then wrap that in skills so all model systems can take advantage of it

[^5]: Both Claude Code and Mistral Vibe support the concept called memories. I expect it to become a common feature in model systems much as retrieval-augmented generation (RAG) has become a common way to interface with specialized knowledge bases.

## Wrap up

Having good quality, properly organized documentation can make or break the efficiency of your development cycle. The basic practices around software development are more valuable today when using models than I think is commonly acknowledged in the press. Human in the loop is necessary as capability and responsibility must be aligned. Only the human can be responsible.

For me the role of language model systems remains as a tool. It's another tool to learn. Unlike a C compiler it has broader application but like a compiler it can assemble a useful output. Understanding that the language model output is just a step in the refinement process is key to discovering how it can be useful to us.
