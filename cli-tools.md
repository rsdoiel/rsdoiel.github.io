
### Useful for Bash scripting

[datatools](https://caltechlibrary.github.io/datatools/) - a small set of tools to facilitate working with CSV, JSON and Excel Workbook data in Bash scripts

+ Data oriented
    + [csv2json](https://caltechlibrary.github.io/datatools/docs/csv2json.html) - converts rows CSV into JSON structures
    + [csv2mdtable](https://caltechlibrary.github.io/datatools/docs/csv2mdtable.html) - render a CSV table as a Github Flavored Markdown table
    + [csv2xlsx](https://caltechlibrary.github.io/datatools/docs/csv2xlsx.html) - a tool to take a CSV file and add it as a sheet to a Excel Workbook file.
    + [csvcols](https://caltechlibrary.github.io/datatools/docs/csvcols.html) - filter or render CSV data rows 
    + [csvfind](https://caltechlibrary.github.io/datatools/docs/csvfind.html) - search CSV rows
    + [csvjoin](https://caltechlibrary.github.io/datatools/docs/csvjoin.html) - join two CSV tables on a designated column value
    + [jsoncols](https://caltechlibrary.github.io/datatools/docs/jsoncols.html) - using dot path notation extract JSON object elements into columns
    + [jsonjoin](https://caltechlibrary.github.io/datatools/docs/jsonjoin.html) - combine JSON objects by branching as well as attribute copying
    + [jsonmunge](https://caltechlibrary.github.io/datatools/docs/jsonmunge.html) - process JSON objects through filters and templates
    + [jsonrange](https://caltechlibrary.github.io/datatools/docs/jsonrange.html) - iterate of a JSON object or array
    + [xlsx2json](https://caltechlibrary.github.io/datatools/docs/xlsx2json.html) - convert an Excel Workbook sheet into a JSON document
    + [xlsx2csv](https://caltechlibrary.github.io/datatools/docs/xlsx2csv.html) - convert an Excel Workbook sheet into into a JSON document
+ Shell scripting oriented
    + [findfile](https://caltechlibrary.github.io/shelltools/findfile.html) - find files based on prefix, suffix on name contents
    + [finddir](https://caltechlibrary.github.io/shelltools/finddir.html) - find directories based on prefix, suffix or name content
    + [mergepath](https://caltechlibrary.github.io/shelltools/mergepath.html) - merge a path, without duplicates into a PATH list
    + [range](https://caltechlibrary.github.io/shelltools/range.html) - emit a range of integers
    + [reldate](https://caltechlibrary.github.io/shelltools/reldate.html) - calculate a relative date in YYYY-MM-DD format
    + [timefmt](https://caltechlibrary.github.io/shelltools/timefmt.html) - format time output per Go's time package time notation
    + [urlparse](https://caltechlibrary.github.io/shelltools/urlparse.html) - extract URL parts (e.g. protocol, hostname, path)

### Useful for managing JSON documents

+ [dataset](https://caltechlibrary.github.io/dataset/) - four tools for manage JSON documents, their attachments and publishing on the web
    + dataset - the primary JSON management tool
    + dsindexer - create Bleve based indexes used by _dsfind_ and _dsws_
    + dsfind - a command line search interface into your content managed with _dataset_
    + dsws - a web UI for your _dataset_ collections

### Content formatting tools

+ [mkpage](https://caltechlibrary.github.io/mkpage/) - a deconstructed content system for static content publishing
    + [mkpage](https://caltechlibrary.github.io/mkpage/docs/mkpage.html) - a light weight markdown and template processor for multiple data sources and types
    + [mkslides](https://caltechlibrary.github.io/mkpage/docs/mkslides.html) - a markdown to HTML page presentation renderer
    + [mkrss](https://caltechlibrary.github.io/mkpage/docs/mkrss.html) - a RSS generator for Markdown content
    + [sitemapper](https://caltechlibrary.github.io/mkpage/docs/sitemapper.html) - a sitemap.xml generator
    + [reldocpath](https://caltechlibrary.github.io/mkpage/docs/reldocpath.html) - calculate relative file paths
    + [titleline](https://caltechlibrary.github.io/mkpage/docs/titleline.html) - extract the first title from a Markdown file
    + [byline](https://caltechlibrary.github.io/mkpage/docs/byline.html) - extract a byline from an article written in Markdown
    + [urlencode](https://caltechlibrary.github.io/mkpage/docs/urlencode.html) and [urldecode](https://caltechlibrary.github.io/mkpage/docs/urldecode.html) - url encode/decode from the command line
    + [ws](https://caltechlibrary.github.io/mkpage/docs/ws) - A nimble static content webserver
        + doesn't serve dot files (e.g. .htaccess) or dot directories (e.g. .git)
        + fast startup
        + logs to console so you can watch requests and responses
+ [opml](/opml/) - A naive OPML parse package that features a OPML sort utility
+ [shorthand](/shorthand/) - a text label expander with markdown processor support
+ [stngo](/stngo/) - Standard Timesheet Notation processor for my personal project time logs

