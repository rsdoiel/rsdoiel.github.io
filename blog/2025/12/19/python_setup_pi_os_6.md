---
title: Python Setup on Raspberry Pi OS 6
author: R. S. Doiel
description: |
  A set of quick notes for wrangling Python to work nicely on Raspberry Pi OS 6
keyword:
  - python
  - raspberry pi OS
dateCreated: "2025-12-19"
dateModified: "2025-12-19"
datePublished: "2025-12-19"
postPath: blog/2025/12/19/python_setup_pi_os_6.md
---

# Python Setup on Raspberry Pi OS 6

By R. S. Doiel, 2025-12-19

I like the python programming language but I don't like to program in it as much as I used to. The trouble is the challenge of versions and packages. At work we're shifting to using [uv](https://docs.astral.sh/uv/getting-started/installation/) to manage the "python environment" (a symptom of how python has become less than fun). It works well on the machines and operating systems I use for work. My personal computing platform of choice these days is a Raspberry Pi 500 though. Raspberry Pi OS is based on Debian but when it comes to Python things can get persnickety pretty quick. The best way to install uv I've found isn't via methods suggested at the beginning of the linked install pages. For me I have found installing via Rust's cargo command the most reliable.

```shell
cargo install --locked uv
```

Once installed you can update it with the following

```shell
uv self update
```

Since I don't setup a new Pi frequently I tend to forget the simplicity of this approach and waste an hour trying the other suggested ways. This post is just a note to myself so I remember that!



