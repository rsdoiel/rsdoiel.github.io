#!/bin/bash

#
# This script makes HTML page redirect pages.
#

function mk_redirect_page() {
    BASE="$1"
    PAGE="$2"
    DEST="$3"
    cat <<EOT >"${BASE}/${PAGE}"
<!DOCTYPE html>
<html lang="en-US">
<head>
  <meta charset="utf-8">
  <!-- Redirect page after 3 seconds -->
  <meta http-equiv="refresh" content="3;url=${DEST}">

  <link rel="stylesheet" type="text/css"  href="/printfonts/print.css" media="print" />
  <link rel="stylesheet" type="text/css"  href="/webfonts/fonts.css" media="screen" />
  <link rel="stylesheet" type="text/css"  href="/css/site.css" media="screen" />
</head>
<body>
<section>
<h1>Redirecting</h1>
<p>
The page &quot;${PAGE}&quot; has moved to &quot;<a href="${DEST}">${DEST}</a>&quot;.
</p>
</section>
</body>
</html>
EOT

}


mk_redirect_page blog/2020/08/15 Portable-Oberon-7.html Portable-Oberon-07.html
mk_redirect_page blog/2020/05/09 Oberon-7-and-the-filesystem.html Oberon-07-and-the-filesystem.html
mk_redirect_page blog/2021/06/14 Combining-Oberon-7-with-C-using-Obc-3.html Combining-Oberon-07-with-C-using-Obc-3.html

