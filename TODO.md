
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

Blocked on antenna improvements described in
`~/Laboratory/antennaApp/enhanced_front_matter_processing_feature_request.md`.
Once those antenna changes are built and installed, complete the following steps
in order:

1. **Rebuild antenna** with the enhanced front matter processing feature:
   - `GeneratePosts` must call `doc.Parse()` so YAML front matter is stripped
     from body text and made available as structured metadata.
   - `writeHeadElement` must emit standard `<meta>` elements (`description`,
     `author`, `keywords`, `datePublished`) and PageFind filter meta elements
     (`data-pagefind-filter`) for `keywords`, `series`, `author`, and
     `datePublished` — one `<meta>` per value for multi-valued fields.

2. **Regenerate the site** so all blog post HTML files contain the new `<head>`
   metadata. Run `make` (or the relevant `antenna generate` / `antenna post`
   targets) to rebuild affected pages.

3. **Rebuild the PageFind index** so the new filter attributes are captured:
   ```
   make pagefind
   ```

4. **Update `search.md`** to enable faceted browsing with the PageFind 1.5
   component API. Replace the current inline search block with:
   ```html
   <pagefind-config faceted preload></pagefind-config>
   <pagefind-input placeholder="Search…"></pagefind-input>
   <pagefind-filter-pane></pagefind-filter-pane>
   <pagefind-summary></pagefind-summary>
   <pagefind-results></pagefind-results>
   ```
   The existing URL-sync `<script type="module">` block (reads `?q=` on load,
   writes `?q=` on each search event via `history.replaceState`) should be kept
   unchanged — it continues to support OpenSearch / `osd.xml` bookmarking.

5. **Rebuild `search.html`** from the updated `search.md`:
   ```
   make search.html
   ```

6. **Verify** by navigating to `search.html` and confirming that:
   - The filter pane renders groups for `keywords`, `series`, `author`, and
     `datePublished`.
   - Selecting a filter narrows results correctly.
   - Navigating to `search.html?q=oberon` still pre-populates the search and
     triggers results (OpenSearch flow remains intact).

Someday Maybe
-------------

- Update make-rss.sh to include presentations as well as blog
- Update the visual design
    - remain playful
    - [ ] primary colors and high contrast
    - [ ] apply a11y accessibility recommendations
- [ ] Write blog post about my Caltech Library work, link to demos

