---
title: Installing Deno via Cargo and other options
byline: 'R. S. Doiel, 2024-12-13'
createDate: 2024-12-13T00:00:00.000Z
abstract: >
  Notes on setting up a Debian flavored Linux boxes, macOS and Windows to
  install Deno via `cargo install deno`,

  `curl -fsSL https://deno.land/install.sh | sh` or

  `iwr https://deno.land/install.ps1 -useb | iex`
keywords:
  - rust
  - deno
  - cargo
  - Debian
  - Linux
  - windows
  - macOS
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2024-12-13'
dateModified: '2025-07-22'
datePublished: '2024-12-13'
postPath: 'blog/2024/12/13/installing-via-cargo-etc.md'
---

# Installing Deno via Cargo and other options

By R. S. Doiel, 2024-12-13

I've recently needed to install Deno on several Debian flavored Linux boxes.  I wanted to install Deno using the `cargo install --locked deno` command. Notice the `--locked` option, you need that for Deno. This worked for the recent Ubuntu 22.04 LTS release. I needed alternatives for Ubuntu 20.04 LTS and Raspberry Pi OS.

## Using Cargo

Prerequisites:

- Rust (install with [Rustup](https://rustup.rs))
- CMake
- Clang, LLVM dev, Clang DEV and the lld (clang) linker
- SQLite3 and LibSQLite3 dev
- pkg config
- libssh dev, libssl dev

The Debian flavors I work with are recent (Dec. 2024) Ubuntu 22.04 LTS release[^1].

Recently when I was installing Deno 2.1.4 I got errors about building the `flate2` module. I had forgotten to include the `--locked` option in my cargo command. I found this solution in Deno GitHub issue [9524](https://github.com/denoland/deno/issues/9524).

```shell
sudo apt install -y build-essential cmake clang libclang-dev llvm-dev lld \
                    sqlite3 libsqlite3-dev pkg-config libssh-dev libssl-dev
rustup update
cargo install deno --locked
```

## Other options

For Ubuntu 20.04 LTS and Raspberry Pi OS, use `curl -fsSL https://deno.land/install.sh | sh` to install.

For Windows on ARM64 use `iwr https://deno.land/install.ps1 -useb | iex`.

 `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
On Raspberry Pi OS I added a `nice` before calling `cargo`. Without the "nice" it failed after the "spin" module.

[^1]: I failed to install Deno this way on Ubuntu 20.04 LTS, just use the cURL + sh script.
