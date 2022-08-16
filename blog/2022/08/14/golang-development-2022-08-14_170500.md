---
title: "5:00 PM, Golang: pdtk,  stngo"
author: "R. S. Doiel"
pubDate: 2022-08-14
series: "Golang"
no: 2
keywords:
  - "pdtk"
  - "stngo"
---

# 5:00 PM, Golang: pdtk,  stngo

By R. S. Doiel, Sunday, August 14, 2022 17:05 PDT

Today I started an experiment. I cleaned up stngo a little today, still need to implement a general `Parse()` method that works on a `io.Reader`. After a few initial false starts I realized the "right" place for rendering simple timesheet notation as blog posts is in the the "blogit" action of [pdtk](https://rsdoiel.github.io/pdtk). I think this form might be useful for both release notes in projects as well as a series aggregated from single paragraphs. The limitation of the single paragraph used in simple timesheet notation is intriguing. Proof of concept is working in v0.0.3 of pdtk. Still sorting out if I need a title and if so what it should be.

