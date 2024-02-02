---
title: vis for vi and fun
byline: R. S. Doiel, 2024-01-31
keywords: [ "editors", "vi" ]
pubDate: 2024-01-31
created: 2024-01-31
updated: 2024-02-01
---

# vis for vi and fun

By R. S. Doiel, 2024-01-31 (updated: 2024-02-01)


I've been looking for a `vi` editor that my fingers would be happy with. I learned `vi` when I first encountered Unix in University (1980s). I was a transfer student so didn't get the "introduction to Unix and Emacs" lecture. Everyone used Emacs to edit programs but Emacs to me was not intuitive. I recall having a heck of a time figuring out how to exit the editor! I knew I needed to learn an editor and Unix fast to do my school work. I head to my college bookstore and found two spiral bound books [Unix in a Nutshell](https://openlibrary.org/works/OL8724416W?edition=key%3A/books/OL24392296M) and "Vi/Ed in a Nutshell". They helped remedy my ignorance. I spent the afternoon getting comfortable with Unix and learning the basics in Vi. It became my go to text editor. Somewhere along the line `nvi` came along I used that. Eventually `vim` replaced `nvi` as the default "vi" for most Linux system and adapted again.  I like one featured about `vim` over `nvi`. `vim` does syntax highlighting. I routinely get frustrate with `vim` (my old muscle memory throws me into the help systems, very annoying) so I tend to bounce between `nvi` and `vim` depending on how my eyes feel and frustration level. 

## vis, the vi I wished for

Recently I stumbled on `vis`. I find it a  very interesting `vi` implementation. Like `vim` it mostly conforms to the classic mappings of a modal editor built on top of `ed`. But `vis` has some nice twists. First it doesn't try to be a monolithic systems like Emacs or `vim`. Rather then used an application specific scripting language (e.g. Emacs-lisp, vim-script) it uses Lua 5.2 as its configuration language. For me starting up `vis` feels like starting up `nvi`. It is quick and responsive where my typical `vim` setup feels allot like Visual Studio Code in that it's loading a whole bunch of things I don't use. 

Had `vis` just had syntax highlighting I don't know if I was would switched from `vim`. `neovim` is a better vim but I don't use it regularly and don't go out of my way to install it.  `vis` has one compelling feature that pushed me over the edge. One I didn't expect. `vis` supports [structured regular expressions](http://doc.cat-v.org/bell_labs/structural_regexps/se.pdf "PDF paper explain structured regular expression by Rob Pike"). This is the command language found in Plan 9 editors like [sam](http://sam.cat-v.org/) and [Acme](http://acme.cat-v.org/). The approach to regexp is oriented around streams of characters rather than lines of characters. It does this by supporting the concept of multiple cursors and operating on selections (note the plural) in parallel. This allows a higher degree of transformation, feels like a stream oriented AWK but with simpler syntax for the things you do all the time. It was easiest enough to learn that my finger quickly adapted to it. It does mean that in command mode my search and replace is different than what I used to type. E.g. changing CRLF to LF

```
:1,$x/\r/ c//
```

versus

```
:1,$s/\r//g
```

Just enough different to catch someone who is used to `vim` and `nvi` unaware.

## Be careful what you wish for on Ubuntu

When I decided I want to use `vis` as my preferred "vi" in went and installed it on all my work Ubuntu boxes. What surprised me was that when you install `vis` on an Ubuntu system it winds up becoming the default "vi". That posed a problem because I hadn't consulted with the other people who use those machines. I thought I would type `vis` instead of `vi` to use it. Fortunately Ubuntu also provides a means of fixing which alternative programs can be used for things like "vi".  I reverted the default "vi" to `vim` for my colleagues using the Ubuntu command `update-alternatives` (e.g. `sudo update-alternatives --config vi`). No surprises for them and I still get to use `vis`, I just type the extra "s". 

## Getting to know structured regular expressions and case swapping

A challenge in making the switch to `vis` is learning a new approach to search and replace. Fortunately Marc Tanner gives you the phrases in his documentation.  Searching for "structured regular expressions" leads to Rob Pike's paper of the same name. The other thing Marc points out is his choices in implementing `vis`. `vis` is like `vi` meets the Sam editor of Plan 9 fame.  You can try Plan 9 Sam editor by installing [Plan 9 User Space](https://9fans.github.io/plan9port/). Understanding Sam made the transition to `vis` smoother. I recommend reading Rob Pike's paper on "Structured Regular Expressions"[^1], his "Sam Tutorial"[^2] then keeping the "Sam Cheatsheet"[^3] handy during the transition. The final challenge I ran into in making the switch is the old `vi` stand by for flipping case for letters in visual mode.  In the old `vi` you use the tilde key, `shift+~`. In `vis` you press `g` then `~` to change the case on a letter.  

[^1]: Rob Pike's ["structured regular expressions"](http://doc.cat-v.org/bell_labs/structural_regexps/se.pdf "PDF document")
[^2]: [Sam Tutorial](http://doc.cat-v.org/bell_labs/sam_lang_tutorial/sam_tut.pdf "PDF document")
[^3]: [Sam Cheat Sheet](http://sam.cat-v.org/cheatsheet/ "html document containing an image")


## A few "thank you" or "how did I stumble on vis?"

I'd like to say thank you to [Marc André Tanner](https://github.com/martanne) for writing `vis`, [Glendix](https://www.glendix.org/) for highlighting it and to OS News contributor [pablo_marx](https://www.osnews.com/submissions/?user=pablo_marx) for the story [Glendix: Bringing the Beauty of Plan 9 to Linux](https://www.osnews.com/story/20588/glendix-bringing-the-beauty-of-plan-9-to-linux/). With this I find my fingers are happier.

## Additional resources

- [GitHub Topic](https://github.com/topics/vis-editor)
- [Plugin collection](https://erf.github.io/vis-plugins/)
- [Vis Wiki](https://github.com/martanne/vis/wiki)


