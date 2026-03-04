---
abstract: |
    I have been experimenting with two large language models recently. I've used them via their Web user interface as well as offline via Ollama. The two models are Mistral 3 and [Apertus](https://publicai.co/). Mistral is the more mature of the two. It is from the French company [Mistral AI](https://mistral.ai/). While the training material used for Mistral 3 is not disclosed, the model can be downloaded to use with Ollama. Mistral AI's models are in the same league as more well-known Anthropic's Claude models. Claude models have been developed over the last three years. Mistral AI's have been developing for about two years. Apertus is been public about six months.

    Post continues exploring trade offs and costs.
author: R. S. Doiel
dateCreated: "2026-03-03"
dateModified: "2026-03-03"
datePublished: "2026-03-03"
keywords:
    - LLM
    - Offline
    - Edge
    - services
postPath: blog/2026/03/03/LLM_service_and_edge.md
title: Language Models, Services and the Edge

---


# Large Language Models, Services and the Edge

By R. S. Doiel, 2026-03-03

I have been experimenting with two large language models recently. I've used them via their Web user interface as well as offline via Ollama. The two models are Mistral 3 and [Apertus](https://publicai.co/). Mistral is the more mature of the two. It is from the French company [Mistral AI](https://mistral.ai/). While the training material used for Mistral 3 is not disclosed, the model can be downloaded to use at the edge with Ollama. Mistral AI's models are in the same league as the well-known Anthropic's Claude models. Claude models have been developed over the last three years. Mistral AI's have been developing for about two years. Apertus is been public about six months.

Last Fall the Web UI subscriptions for Claude and Mistral were notably different. Claude was pricey. Anthropic has recently dropped their prices to be more competitive (see <https://www.infoworld.com/article/4095894/anthropics-claude-opus-4-5-pricing-cut-signals-a-shift-in-the-enterprise-ai-market.html>). Mistral AI's Web UI offering presently runs a few dollars cheaper at $14.99 per month for the base plan and $5.99 per month for students. Switching models does mean re-learning the nuances of prompting for a given model.

Apertus is different. It is an effort by the Swiss and Singapore university communities to approach providing large language models as a public service. The models are trained on publicly available material with respect to licensing. It is a multi-lingual model from the get-go. I expect this from the Swiss, European, and Singaporean contexts. Apertus is developed fully in the open. It is aligned with the practices of academic research that spawned it. It is audit-able and the effort can be replicated.

Both Mistral 3 and Apertus models can be run on your own hardware using the Ollama command line program. The Mistral 3 model can be found on <https://ollama.com>. You can run it locally using `ollama run mistral`. Public AI doesn't directly supply a GUFF model image required by Ollama. Fortunately [Michel Rosselli](https://registry.ollama.com/MichelRosselli) has converted the Apertus model into GUFF. You can test Apertus using `ollama run MichelRosselli/apertus`. It runs reasonably well on my M1 Mac Mini with 16 GB of RAM. It can also run, albeit slower, on a Raspberry Pi 5 with 16 GB RAM.

Offline or edge models are where things get interesting. You don't have to give up autonomy. Offline models let you exchange the surveillance and speed of the corporate data center for hardware under your control. I believe that the offline capabilities and performance of LLM will become increasingly crucial over time. Right now, the Web UIs provide faster responses for the three models I've mentioned. Among them, Apertus stands out as the fastest, though its output quality is less mature compared to Mistral 3 or Claude Opus 4.6.

Anthropic's price adjustments suggest to me that we have entered LLM services as commodities. If so, the commercial space may become cartel-like. When price stability occurs, expect to see rents rise. Remember that rents should be measured both in monetary terms and in terms of privacy costs. Like social media, the interaction between the LLM and human will result in a massive body of material ripe for exploitation by companies, governments, and nefarious actors.

As a response to risk and energy impact I expect offline capability to become increasingly important. This is why I consider using models at the edge as important as the convenience provided by a speedy Web user interface. Open models will be a critical relief valve to pricing pressures and the better models will include provenance for the training data. Apertus is the first where I've seen this happen, given time, the output quality will improve. I think it will follow a similar curve as the closed trained models deployed by corporate providers improved over time.

Here's why I think provenance will become key. The flood of generative AI content trained on publicly accessible Internet resources presents a significant problem. The adage 'garbage in, garbage out' is particularly important when it comes to training material for large language models. Provenance is a means of combating this issue. When provenance becomes a key feature Apertus will hold a key advantage.

Academia possesses a valuable corpus of open-access materials. It features rich metadata describing the corpus, including licensing terms. Apertus has been innovative in leveraging this resource. While the for-profit companies currently hold an edge, I think that will diminish. I look forward to the Apertus approach being adopted in the Americas as well as across the Pacific nations. Verify the model before you trust it.
