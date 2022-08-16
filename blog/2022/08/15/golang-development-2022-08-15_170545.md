---
title: "5:45 PM, Golang: ptdk,  stngo"
author: "R. S. Doiel"
pubDate: 2022-08-15
series: "Golang"
no: 3
keywords:
  - "ptdk"
  - "stngo"
---

# 5:45 PM, Golang: ptdk,  stngo

By R. S. Doiel, Monday, August 15, 2022 17:05 PDT

Thinking through what a "post" from an simple timesheet notation file should look like. One thing occurred to me is that the entry's "end" time is the publication date, not the start time. That way the post is based on when it was completed not when it was started. There is an edge case of where two entries end at the same time on the same date. The calculated filename will collide. In the `BlogSTN()` function I could check for potential file collision and either issue a warning or append. Not sure of the right action. Since I write sequentially this might not be a big problem, not sure yet. Still playing with formatting before I add this type of post to my blog. Still not settled on the title question but I need something to link to from my blog's homepage and that "title" is what I use for other posts. Maybe I should just use a command line option to provide a title?

