---
title : "Search"
---

<noscript>JavaScript must be enabled for search to work</noscript>

# Search Robert's blog posts and selected projects

<link href="/pagefind/pagefind-ui.css" rel="stylesheet">

<script src="/pagefind/pagefind-ui.js" type="text/javascript"></script>

<search id="search"></search>

<script>
let pse = new PagefindUI({
    element: "#search",
    showSubResults: true,
    highlightParam: "highlight",
    mergeIndex: [{
        bundlePath: "https://rsdoiel.github.io/pagefind",
        bundlePath: "https://rsdoiel.github.io/shorthand/pagefind",
        bundlePath: "https://rsdoiel.github.io/pttk/pagefind",
        bundlePath: "https://rsdoiel.github.io/skimmer/pagefind",
        bundlePath: "https://rsdoiel.github.io/scripttools/pagefind",
        bundlePath: "https://rsdoiel.github.io/fountain/pagefind",
        bundlePath: "https://rsdoiel.github.io/osf/pagefind",
        bundlePath: "https://rsdoiel.github.io/fdx/pagefind",
        bundlePath: "https://rsdoiel.github.io/stngo/pagefind",
        bundlePath: "https://rsdoiel.github.io/opml/pagefind"
    }]
})
window.addEventListener('DOMContentLoaded', (event) => {
    let page_url = new URL(window.location.href),
        query_string = page_url.searchParams.get('q');
    if (query_string !== null) {
        console.log('Query string: ' + query_string);
        pse.triggerSearch(query_string);
    }
});
</script>

