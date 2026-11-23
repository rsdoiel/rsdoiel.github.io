---
title : "Robert's Ramblings"
author: R. S. Doiel
---


Welcome
=======

<blockquote class="cartoon"><a href="/media/Wee-Free-Doiels-Summer-Reading.jpg" title="When I press keys with letters, numbers or punctuation symbols they appear the surface. Take me home please, R. S. Doiel"><img style="height: 12.0em; width: auto;" src="/media/Wee-Free-Doiels-Summer-Reading.svg" alt="Wee Free Doiels, Summer Reading"></a> <span>I am a human. I wrote music and prose. I write software.</span></blockquote>

### Flitting about the Internet

- <a rel="me" href="https://bsky.app/profile/rsdoiel.bsky.social">Robert's butterfly</a>, is it a Blue Morpho?
- [Robert's Antenna](/antenna/index.md "experimental feed aggregation and search"), finding signal in the noise

## Then there's this blog ...


### Recent Posts


- [The Markdown Web](/blog/2026/11/22/The_Markdown_Web.md), 2026-11-23
- [Natural Language as programming language](/blog/2026/06/30/natural_language_programming.md), 2026-06-30
- [Libraries and Archives, a Natural Home for Language Models](/blog/2026/04/25/a_natural_home_for_language_models.md), 2026-04-25
- [Fountain and recording agents](/blog/2026/04/15/fountain_and_recording_agents.md), 2026-04-15
- [LibreOffice Writer and Markdown](/blog/2026/03/27/libreoffice_writer_and_markdown.md), 2026-03-27
- [Markdown & Frontmatter: Taking Text Further](/blog/2026/03/04/markdown_and_frontmatter.md), 2026-03-04
- [Language Models, Services and the Edge](/blog/2026/03/03/LLM_service_and_edge.md), 2026-03-03
- [A Simple Web We Own](/blog/2026/02/21/a_simple_web_we_own.md), 2026-02-21
- [Embracing Markdown as Hypertext](/blog/2026/02/19/Embracing_Markdown.md), 2026-02-19
- [The JSON under the hood of RDM](/blog/2026/02/13/the_json_under_the_hood_of_rdm.md), 2026-02-13
- [Reflection on a few decades](/blog/2026/01/01/reflections_2025.md), 2026-01-01

[Series](series/index.md) start as blog posts but continue as collections that explore an idea, topic or theme.

[Library Jargon](library-terminology.md), a slowly accumulating list of terminilogy I've encountered working for a Research Library

The toolbox
-----------


### Screen Play and writing tools

- [scripttool](https://rsdoiel.github.io/scripttool/index.md) - a tool for working with screenplay formats such as Final Draft, FadeIn, Fountain and Open Screenplay Format (e.g. `.fdx`, `.osf`, `.fadein` and `.fountain`)
- [fountain](https://rsdoiel.github.io/fountain/index.md) - A Go package for working with Fountain markup. Includes three example programs **fountainfmt** which is a pretty printer for fountain documents, **fountain2json** which converts fountain files to JSON  and **fountain2html** an experimental HTML renderer for fountain documents
- [fdx](https://rsdoiel.github.io/fdx/index.md) - A Go package for working with Final Draft XML files (.fdx)
- [osf](https://rsdoiel.github.io/osf/index.md) - A Go package for working with Open Screen Play formatted files

### Web Reading and Writing tools

- [Antenna App](https://rsdoiel.github.io/antennaApp/index.md) - Build news sites, microblogs, blogs, and linkblogs with Markdown

### Language Model Systems

- [Harvey](https://rsdoiel.github.io/harvey/index.md) (proof of concept) - A scholarly agent integrating [Ollama](https://ollama.com) and Hailo-Ollama language model services
- [Knowledge](https://rsdoiel.github.io/knowledge/index.md) (proof of concept) - A personal knowledge base suitable for use with language model systems

### Additional text rendering/formatting tools

- [commonMarkDoc](https://rsdoiel.github.io/commonMarkDoc/index.md) - a TypeScript module for working with CommonMark documents
- [shorthand](https://rsdoiel.github.io/shorthand/index.md) - a text label expander with markdown support
- [stngo](https://rsdoiel.github.io/stngo/index.md) - Standard Timesheet Notation processor for my personal project time logs

North L.A. County
-----------------

- [Cal Fire Incident Map](https://www.fire.ca.gov/incidents)
  - [Cal Fire on BSky](https://bsky.app/profile/calfire.bsky.social)
- Los Angeles County
  - [LA County Emergency website](https://www.lacounty.gov/emergency/ "L.A. County Emergency Response Website")
  - [Los Angeles Board of Supervisors, BSky](https://bsky.app/profile/lacountybos.bsky.social)
- City of Santa Clarita
  - [City of Santa Clarita Emergency website](https://santaclaritaemergency.com/ "Santa Clarita City emergency website")
- [SoCal Earthquake Center](https://scedc.caltech.edu/recent/Quakes/quakes0.html "at Caltech")
- California Alert Cameras (run by U.C. San Diego)
  - [South Mountain Looking, Ventura County](https://ops.alertcalifornia.org/cam-console/15801) (looking East towards Santa Clarita Valley)
  - [LACFD Camp Nine (Loop 1)](https://cameras.alertcalifornia.org/?pos=34.3502_-118.4196_10&id=Axis-Loop1) (Bear Mountain Divide area, Looking North)
  - [LACFD Camp Nine (Loop 2)](https://cameras.alertcalifornia.org/?pos=34.3500_-118.4200_10&id=Axis-Loop2) (Bear Mountain Divide area, Looking North)
  - [Oak Mountain (North 1)](https://cameras.alertcalifornia.org/?pos=34.3502_-118.4196_10&id=Axis-OatNorth1#?pos=34.3502_-118.4196_10) (Looking North East)
  - [Oak Mountain (South 1)](https://cameras.alertcalifornia.org/?pos=34.3502_-118.4196_10&id=Axis-OatSouth1#?pos=34.3502_-118.4196_10) (Looking along the ridge line)

<script>
  if (new URLSearchParams(window.location.search).has('q')) {
    const q = new URLSearchParams(window.location.search).get('q');
    window.location.href = '/search.html?q=' + encodeURIComponent(q);
  }
</script>
