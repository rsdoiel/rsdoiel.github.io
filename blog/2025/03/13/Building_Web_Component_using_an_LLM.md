---
title: Building Web Components using Large Language Models
byline: R. S. Doiel
author: 'Doiel, R. S.'
abstract: >
  Quick discussion of my recent experience bootstrapping the CL-web-components
  project
dateCreated: '2025-03-13'
pubDate: 2025-03-13T00:00:00.000Z
series: Code Generation
number: 2
keywords:
  - LLM
  - Web Components
  - JavaScript
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
datePublished: '2025-03-13'
seriesNo: 2
dateModified: '2025-07-23'
---

# Building Web Components using Large Language Models

By R. S. Doiel, 2025-03-13

In March I started playing around with large language models to create a couple web components. I settled on a paid subscription for Mistral's Le Chat. You can see the results of my work project at <https://github.com/caltechlibrary/CL-web-compoments>. The release at or before "v0.0.4" were generated using Mistral's Le Chat.

The current state of LLM offered online do not replace a human programmer. I'm sure that is surprising to those who thing of this as a solved problem. I found that is was my experience as a developer that I could detect the problems in the generated code. It was also required in coming up with the right prompts to get the code I wanted. 

The key to success of using an LLM for code generation is domain knowledge. You need domain knowledge of the problem you're solving by creating new software and domain knowledge of the machine or run time that the software will target.

The ticket to working with an LLM using a chat interface is your domain knowledge. That's how you know what to ask. That starting point is useful when using the LLM explore **widely documented** topics and approaches. The LLM is not good at inferring novel solutions but rather at using what it has been trained on.  That has been the key with the current crop of LLM I tried.

I think using an LLM to generate code alongside a human client has potential. The human client brings subject knowledge. The human software developer brings more domain knowledge. Between the two they can guide the LLM in generating useful code. Its a little like training a literalist four year old that has the ability to type. I think this three way collaboration has possibilities. The LLM may prove helpful in bridging the human client and software developer divide.

## my experiment proceeded

Working with a chat interface and LLM is a non-trivial iterative process. It can be frustratingly slow and pedantic. I often felt I took two steps forward then a step backward. I am unsure if I arrived at the desire code faster using the LLM. I am unsure the result was better quality software.

I spent two weeks of working with a Mistral's Le Chat LLM on two web components. I am happy with the results at this stage of development. I am not certain the web components will continue to be developed with an LLM. My experience left me with questions about how LLM generated code will help or hurt sustainable software.

## Generating web components

My experiment focused on two web components I needed for a work project. The first successfully completed component was called `AToZUL` in "[a_to_z_ul.js](https://raw.githubusercontent.com/caltechlibrary/CL-web-components/refs/heads/main/a_to_z_ul.js)”. This web component is intended to wrap a simple UL list of links. It turns the wrapped UL into an A to Z list. Taking the wrapping approach of a native HTML element was my idea not the LLM's. I asked the LLM to implement a fallback but each LLM I tried this with inevitably relied on JavaScript. This fails when JavaScript is unavailable in the browser[^1]. How can the LLM do better than rehashing of the training data?

[^1]: By providing a non JavaScript implementation I can interact with the web page using terminal based browser or using simple web scraping libraries.

The second web component successfully generated is called `CSVTextarea` in the "[csvtextarea.js](https://raw.githubusercontent.com/caltechlibrary/CL-web-components/refs/heads/main/csvtextarea.js)". This web component wraps a TEXTAREA that has CSV data in it's inner text. The web component presents a simple table for data entry. It features auto complete for columns using DATALIST elements. The `CSVTextarea` emits "focused" and "changed" events when cells receive focus or change. Additional methods are implemented to push data into the component or retrieving data from the component. Both web components include optional attributes "css-href" to include CSS that overrides the default that ships with the component.

At the start of March a spent a couple days working with the free versions of several LLM. I found Chat-GPT to be useless. I found Claude and Mistral to be promising. In all cases I found the "free" versions to be crippled for generating web components. I settled on a paid subscription to Mistral's Le Chat. The code generation was nearly as good as Claude but less expensive per month.

Out side of work hours I tested code generation for several personal projects as well as code porting.  I was unhappy with the results for porting code from Go to Deno 2.x and TypeScript. The LLM are not trained on recent data. They seem to be about two years out. This includes the paid ones. As the result the best I could do was generate code for Deno 1.x. 

TypeScript and Go have some strong parallels. I'd previously hand ported code. I compared my code with the LLM results and was surprised at the deficits in the generated code. I think this boils down to the training sets used. 

Of all the programming tasks I tried the best results for code generation were targeting JavaScript running in a web browser. This isn't surprising as the LLM likely trained on web data.

## My development setup for the experiments

I initially tried VSCode and CoPilot. For me it us annoying and highly unproductive[^2]. My reaction certainly is a reflection on my background. I prefer minimal IDE. I am happy with an editor that is limited to syntax highlighting, auto indent and line numbering. When I use VSCode I turn most features off. Your mileage may very with your preferences.

[^2]: It was annoying enough that I initially dismissed using an LLM. My colleague, Tommy, however encouraged me to give it a more serious try. If you lived through the "editor wars" of the early ARPAnet get ready for them to reignite. We're going to see allot of organizations claiming superior dev setups for integrating LLM into IDE.

I ran my tests using a terminal app, a text editor, a localhost web server and Firefox. The log output of the web server was available in one terminal window and another for my text editor. One browser tab was open to Mistral's Le Chat. The other tabs open to the HTML pages I used for testing the results of the generated code. It required a fair amount of cut and paste which is tedious. This is far from an ideal setup.

I looked at [Ollama](https://ollama.com) to see about running the LLM from the command line.  Long run this seems like a better approach for me. Unfortunately to use Mistral.ai's trained models I would need to purchase a more expensive subscription. The price point is roughly the same as Anthropic's Claude, a closed sourced option. For now I am sticking with cut and paste.

Using Ollama there is the possibility of using Mistral's open source models and training them further on data I curate. At some point I'll give it a try. I remain concerned about the electric bill. If collectively we're going to run these systems they will need clean alternative sources of electricity. Otherwise we are in for an environmental impact like we saw with BitCoin and Block-Chains. I think this is a major problem in the LLM space. I don't think we can ignore it even when the "AI" hype cycle is hand waving it away.

I liked using Ollama to test free models to understand their differences. I recommend this as an option if you are working from macOS or Windows. The quality of generated code varies considerably between models. It is also true that the speed and processing requirements varies considerably between models. I am sure this is why hardware vendors think they will be able to sell hardware with "AI Chips" built in. I'm skeptical.

I think small language models targeting specific domains could really improve the use case for language models generating code. They could shine for specific tasks or programming languages. They might be reasonable to run on embedded platforms too. I think small language models are an overlooked area in the current "AI" hype cycle.

## What I took away from this experiment

I think a good front end developer[^3] could find an LLM useful as an "assistant". I think a novice developer will easily be lead astray. As a community of practitioners we should guard against the bias, "computer must be correct". This is not new. It happened when "expert systems" were the rage before the first AI winter. It'll be an easy trap to fall into for the public.

[^3]: I am not a front end developer. I have spent most of my career writing back end systems and middleware.

I have a great deal of concern about compromised training data. There is so much mischief possible. It has already been established that "poisoning" the LLM via training data and prompts will result in generating dubious code[^4]. I don't see much attention paid to the security and provenance of training data, let alone good tools to vet the generated code. This is a security bomb waiting to explode.

[^4]: See [Medical large language models are vulnerable to data-poisoning attacks](https://www.nature.com/articles/s41591-024-03445-1). Think of the decades waste on SQL injections then multiply that by magnitudes as people come to trust the results of LLM to build really complex things. 

Today's software systems are really complex. Reproducibility has become a requirement in mitigating the problem. This is why you've seen a rise in virtual environments. The LLM itself doesn't improve this situation. I've used the same text prompts with the same LLM but different chat session and gotten significantly different results. The LLM as presently implemented exacerbate the problems of reproducibility. 

To an certain extent we can strengthen our efforts around quality assurance. The trouble I've found is this too is a domain where LLMs are being applied. If the quality assurance LLM is tainted we don't get the assurance we need. There also is the very human problem of typos in our prompts. That's a very deep rabbit hole by itself.

## Lessons learned

I got the best results by composing a long specification as an initial state prompt to kick off code generation. I still needed to fix bugs using short prompts interactively. With the CSVTextarea I threw away five versions before I got to something useful. Each chat session lasted a couple hours. They were spread out over many days.

There was a clear point when additional prompts don't improve the results of generated code. I found three cases where I lead the LLM down a rabbit hole.

1. the terms I used weren't what the LLM was trained on so it couldn't respond the way I wanted
2. the visible results, e.g. the web component failing to render, doesn't indicate the underlying problem, this leads to prompt churn
3. their was a subtle assumption in the generated code I didn't pick up and correct early on

A beneficial result of using an LLM to generate code is that it encourages reading the source. Reading code is generally not taught enough. You're going to be reading allot of code using the current crop of commercially available LLM. That is a good thing in my book.

To solve the rabbit hole problem I adopted the following practices. Keep all my prompts in a Markdown document, along with notes to myself. When I felt the LLM had gone down a rabbit whole have the LLM generate a "comprehensive detailed specification" of the code generated. Compare the LLM specification against my own prompts helped simplify things when starting over.

Be willing to throw away the LLM results and start over. This is important in exploratory programming but also when you're using LLM generated code to solve a known problem. If you can tolerate the process of writing and refining the prompts in your native language the LLM will happily attempt to generate code for them. I'd love to get some English and Philosophy graduates using LLM for code generation. It'd be interesting to see how their skills may out perform those of traditionally educated software engineering graduates. I think the humanities fields that could benefit from a quantitative approach may find LLM to generate code to do analysis really compelling.

While I like the results I got for this specific tests I remain on the fence about **general usefulness** of LLM in the area of code generation. I suspect it'll take time before the shared knowledge and practice in using them emerges. There is also the problem of energy consumption.  This feels like the whole "proof of work" problem consuming massive amounts of electricity in the block chain tech. That alone was enough to turn me off of block chain for most of its proposed applications. Hopefully alternatives will be developed to avoid that outcome with large language models.