
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
        bundlePath: "https://rsdoiel.github.io/antennaApp/pagefind",
        baseUrl: "/antennaApp/"
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
