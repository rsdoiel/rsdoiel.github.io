---
author: R. S. Doiel
dateCreated: "2026-04-15"
dateModified: "2026-04-15"
datePublished: "2026-04-15"
description: |
    Exploring using fountain markup for logging interactions for user agents and large language models.
keywords:
    - Agents
    - Fountain
    - Screenplays
    - LLM
    - Large Language Models
postPath: blog/2026/04/15/fountain_and_recording_agents.md
title: Fountain and recording agents

---


# Fountain and recording agents

By R. S. Doiel, 2026-04-15

I was working on a personal project inspired by a class I am taking. I wanted to create a agent named Harvey in Go that would work with both local language models run by Ollama and with [publicai.co](https://publicai.co) if that was available. The LLM chat bot was the easy bit. It was while debugging the agent mode that I realized it would be helpful to have a recording of the conversation between the parties, Harvey, the Model and myself. First pass was to have the recorder write out a Markdown document structured like a report. That wasn't really ideal at all. Similarly a steam of conversation wasn't quite right either. It was very hard to know who was typing or doing. Then it occurred to me that an agent interaction is really structured like a screenplay. A screenplay **shows** you whats happening by building around the structure of scenes, actors, dialog and action. Throw in some timestamps and you have a pretty good idea of who did what, when and how.

Epiphany! [Fountain](https://fountain.io) markup is for screenplays. It is easy to read as plain text and can be evaluated later to find problems. It describes how the agents, humans and LLM interact. It has all the right bits. I guess those humanities classes payed off nicely today.

Now when I test my agent named Harvey, I record the interaction and can go back and read the screenplay version of the interactions. It's really helpful even if it will not likely result in an actual movie.


