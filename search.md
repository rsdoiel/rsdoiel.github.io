---
title : "Search"
---

<noscript>JavaScript must be enabled for search to work</noscript>

# Search Robert's blog posts and selected projects

<search id="search"></search>

<link href="/pagefind/pagefind-ui.css" rel="stylesheet">
<script src="/pagefind/pagefind-ui.js" type="text/javascript"></script>
<script>
// Fetch the query "q" form the URL
function getQueryParam(name) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(name);
}

// When the page is loaded setup PageFindUI object.
window.addEventListener('DOMContentLoaded', (event) => {
  const pagefindUI = new PagefindUI({
  element: "#search",
  showSubResults: true,
  highlightParam: "highlight",
  mergeIndex: [
    {
      bundlePath: "https://rsdoiel.github.io/pagefind",
      baseUrl: "/"
    },
      {
        bundlePath: "https://rsdoiel.github.io/shorthand/pagefind",
        baseUrl: "/shorthand/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/pttk/pagefind",
        baseUrl: "/pttk/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/skimmer/pagefind",
        baseUrl: "/skimmer/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/fountain/pagefind",
        baseUrl: "/fountain/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/fdx/pagefind",
        baseUrl: "/fdx/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/stngo/pagefind",
        baseUrl: "/stngo/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/opml/pagefind",
        baseUrl: "/opml/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/commonMarkDoc/pagefind",
        baseUrl: "/commonMarkDoc/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/BlogIt/pagefind",
        baseUrl: "/BlogIt/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/scripttool/pagefind",
        baseUrl: "/scripttool/"
      },
      {
        bundlePath: "https://rsdoiel.github.io/osf/pagefind",
        baseUrl: "/osf/"
      },
    ]
  });
  
  const queryString = getQueryParam("q");
  if (queryString) {
    pagefindUI.triggerSearch(queryString);
  }
});
</script>
