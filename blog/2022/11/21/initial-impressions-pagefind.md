---
title: Initial Impressions of Pagefind
author: rsdoiel@sdf.org (R. S. Doiel)
byline: 'R. S. Doiel, 2022-11-21'
keywords:
  - site search
  - pagefind
  - rust
  - cargo
  - rustup
  - M1
  - macOS
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  I'm interested in site search that does not require using server side services
  (e.g. Solr/Elasticsearch/Opensearch). I've used [LunrJS](https://lunrjs.com)
  on my person blog site for several years.  The challenge with LunrJS is
  indexes become large and that limits how much your can index and still have a
  quick loading page. [Pagefind](https://pagefind.app) addresses the large index
  problem. The search page only downloads the portion of the indexes it needs.
  The index and search functionality are compiled down to WASM files. This does
  raise challenges if you're targeting older web browsers.


  Pagefind is a [rust](https://www.rust-lang.org/) application build using
  `cargo` and `rustc`. Unlike the documentation on the
  [Pagefind](https://pagefind.app) website which suggests installing via `npm`
  and `npx` I recommend installing it from sources using the latest release of
  cargo/rustic.  For me I found getting the latest cargo/rustc is easiest using
  [rustup](https://rustup.rs/). Pagefind will not compile using older versions
  of cargo/rustc (e.g. the example currently available from Mac Ports for M1
  Macs).


  Here's the steps I took to bring Pagefind up on my M1 Mac.


  ...
dateCreated: '2022-11-21'
dateModified: '2025-07-22'
datePublished: '2022-11-21'
postPath: 'blog/2022/11/21/initial-impressions-pagefind.md'
---

# Initial Impression of Pagefind

By R. S. Doiel, 2022-11-21

I'm interested in site search that does not require using server side services (e.g. Solr/Elasticsearch/Opensearch). I've used [LunrJS](https://lunrjs.com) on my person blog site for several years.  The challenge with LunrJS is indexes become large and that limits how much your can index and still have a quick loading page. [Pagefind](https://pagefind.app) addresses the large index problem. The search page only downloads the portion of the indexes it needs. The index and search functionality are compiled down to WASM files. This does raise challenges if you're targeting older web browsers.

Pagefind is a [rust](https://www.rust-lang.org/) application build using `cargo` and `rustc`. Unlike the documentation on the [Pagefind](https://pagefind.app) website which suggests installing via `npm` and `npx` I recommend installing it from sources using the latest release of cargo/rustic.  For me I found getting the latest cargo/rustc is easiest using [rustup](https://rustup.rs/). Pagefind will not compile using older versions of cargo/rustc (e.g. the example currently available from Mac Ports for M1 Macs).

Here's the steps I took to bring Pagefind up on my M1 Mac.

1. Install cargo/rust using rustup
2. Make sure `$HOME/.cargo/bin` is in my PATH
3. Clone the Pagefind Git repository
4. Change to the repository directory
5. Build and install pagefind

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH="$HOME/.cargo/bin:$PATH"
git clone git@github.com git@github.com:CloudCannon/pagefind.git src/github.com/CloudCannon/pagefind
cd src/github.com/CloudCannon/pagefind
cargo install pagefind --features extended
```

Next steps were

1. Switch to my local copy of my website
2. Build my site in the usual page
3. Update my `search.html` page to use pagefind
4. Index my site using pagefind
5. Test my a local web server

To get the HTML/JavaScript needed to embed pagefind in your search page see [Getting Started](https://pagefind.app/docs/). The HTML/JavaScript fragment is at the top of the page. After updating `search.html` I ran the pagefind command[^1].

```
pagefind --verbose --bundle-dir ./pagefind --source .
```

The indexing is wicked fast and it gives you nice details. I verified everything worked as expected using `pttk ws` static site web server. I then published my website. You can see the results at <http://rsdoiel.sdf.org/search.html> and <https://rsdoiel.github.io/search.html>

[^1]: I specified the bundle directory because GitHub pages had a problem with the default `_pagefind`.
