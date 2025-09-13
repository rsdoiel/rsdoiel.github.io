---
title: Signed Binaries and Business Models
author: R. S. Doiel
abstract: >
  This post explains why I don't provide signed binaries in the open source
  software I create and release.
keywords:
  - open source
  - philosophy
  - signed binaries
  - app stores
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateCreated: '2025-07-24'
dateModified: '2025-07-28'
datePublished: '2025-07-24'
postPath: 'blog/2025/07/24/WHY_NO_SIGNED_BINARIES.md'
---

# Thoughts on signed binaries and business models

By R. S. Doiel, 2025-07-24

## Why no Apple signed binaries?

To sign the binaries I would need to be an "Apple Developer". To be an "Apple Developer", I or someone on my behalf would need to pay an annual fee. I thinks this is ridiculous. Why do you need to pay someone to write software for hardware that was already paid for? It feels like being extorted for your lunch money. I am stubborn and refuse to be an Apple Developer. I write Open Source software so anyone can compile and run it. Should they choose this includes Apple employees. I do not extort lunch money.

Apple's insistence on requiring payment is a little rich. Apple's operating systems, macOS and iOS, are derived from Open Source software. Apple's current operating systems are derived from the Mach kernel and BSD. The developer tools are derived from Clang. Another open source software project. The software I write is also open source. There's a trend here.

## Why no signed binaries for other companies?

When I considered Apple's policies, I rejected the fee to write software. When Microsoft, Google, et el. followed a similar path my eye brows raised in extreme skepticism. I am concerned for my eye brows.

I believe this requirement is less about actual security and more about business models. After all signing could be done in an open, secure and distributed manner. It's as easy as using a standard form of public signing (e.g. PGP, SSH keys), having the OS supported the signed binaries and hosting the public keys of the signed document a location controlled by the individual or organization signing the executable. A distributed approach does not require corporate sponsorship, implementation or blessings. You could even implement a signing mechanism similar to Let's Encrypt used for HTTPS certificates.

Security is being used as an excuse to enable vendor lock in or drive people to rent software from the "cloud". This seems incredibly silly to me. I am a stubborn person. I am **NOT** going along with this practice. I apologize for the inconvenience but insist I avoid feeling a part of a lunch money extortion plot. I feel I should be free to practice my vocation of writing open source software without being required to participate in business models that neither benefit my employer, my community or myself.

## What are your options to use the software?

There are ways to allow the operating system to run the software. You can follow the instructions complete with the scary warnings to do so. You can also download the source code and build the software yourself. It is open source software after all.

- [installing unsigned software macOS](INSTALL_NOTES_macOS.txt)
- [installing unsigned software Windows](INSTALL_NOTES_Windows.txt)

# ABOUT THIS DOCUMENT

These are my opinions. My opinions do not reflect my employer's policies, procedures or practices.
