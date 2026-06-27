
Action items
============

Bugs
----

Next
----

- [x] Convert JSON frontmatter to YAML for Pandoc 2.2 compatibility
- [x] Convert Makefile, blog.bash to use Pandoc 2.2 for Raspberry Pi OS
- [ ] consolidate templates
- [ ] Add save to pocket links to blog post listing pages, see https://getpocket.com/publisher/button and https://getpocket.com/publisher/button_docs
- [ ] Integrate search indexes from from antenna when I get search on antenna sorted out

### Faceted search via PageFind 1.5+ web components

- [x] Rebuilt antenna (0.0.24c) with enhanced front matter processing: `GeneratePosts`
  calls `doc.Parse()`, `writeHeadElement` emits `data-pagefind-filter` meta elements.
- [x] Added `allowed_meta_fields: [keywords, series, author, dateModified, datePublished]`
  to `page.yaml`; normalized two posts from `keyword:` to `keywords:` (in .md and DB).
- [x] Regenerated all 183 blog post HTML files via `antenna generate`.
- [x] Updated `search.md` with `<pagefind-config faceted preload>` and
  `<pagefind-filter-pane>` components; rebuilt `search.html`.
- [x] Rebuilt PageFind index — 183 pages, 5 filters indexed.
- [ ] **Verify** in browser: filter pane renders groups for `keywords`, `series`,
  `author`, `dateModified`, `datePublished`; selecting a filter narrows results;
  `search.html?q=oberon` still pre-populates search.

Someday Maybe
-------------

- Update make-rss.sh to include presentations as well as blog
- Update the visual design
    - remain playful
    - [ ] primary colors and high contrast
    - [ ] apply a11y accessibility recommendations
- [ ] Write blog post about my Caltech Library work, link to demos

