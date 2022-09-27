---
title: "Rust development Notes"
pubDate: 2022-09-27
author: 'rsdoiel@gmail.com (R. S. Doiel)'
keywords: [ 'rust', 'cargo', 'M1', 'macOS', 'ports' ]
---

Rust development notes
======================

by R. S. Doiel, 2022-09-27

I recently wanted to try [ncgopher](https://github.com/jansc/ncgopher) which is a [rust](https://rust-lang.org) based application. I was working on a an M1 Mac mini. I use [Mac Ports](https://www.macports.org) for my userland applications and installed [cargo](https://doc.rust-lang.org/cargo/) to pickup the rust compiler and build tool

```shell
sudo port install cargo
```

All went well until I tried to build ncgopher and got an error as follows

```
cargo build --release
    Updating crates.io index
error: Unable to update registry `crates-io`

Caused by:
  failed to fetch `https://github.com/rust-lang/crates.io-index`

Caused by:
  failed to authenticate when downloading repository: git@github.com:rust-lang/crates.io-index

  * attempted ssh-agent authentication, but no usernames succeeded: `git`

  if the git CLI succeeds then `net.git-fetch-with-cli` may help here
  https://doc.rust-lang.org/cargo/reference/config.html#netgit-fetch-with-cli

Caused by:
  no authentication available
make: *** [build] Error 101
```

This seemed odd as I could run `git clone git@github.com:rust-lang/crates.io-index` successfully. Re-reading the error message a dim light went on. I checked the cargo docs and the value `net.git-fetch-with-cli` defaults to false. That meant that cargo was using its own embedded git. OK, that makes sense but how do I fix it. I had no problem using cargo installed via ports on an Intel iMac so what gives? When cargo got installed on the M1 there was now `.cargo/config.toml` file. If you create this and set the value of `git-fetch-with-cli` to true then the problem resolves itself.

It was good that the error message provided a lead. It's also good that cargo has nice documentation. My experience though still left the taste of [COIK](https://www.urbandictionary.com/define.php?term=coik). Not sure how to improve the situation. It's not really a cargo bug (unless config.taml should be always created), it's not a rust bug and I don't even think it is a ports packaging bug.  If I was a new developer just getting familiar with git I don't think I would have known how to solve my problem even with the documentation provided. Git is something that has always struggled with COIK. While I like it it does make things challenging.

If I wind up playing with rust more then I'll add somemore notes here in the future.




