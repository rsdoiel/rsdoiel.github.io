{
    "title": "Harvesting my Gists from GitHub",
    "author": "R. S. Doiel",
    "date": "2017-12-10",
    "keywords": [ "GitHub", "Gists", "JSON" ],
    "copyright": "copyright (c) 2017, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}


# Harvesting my Gists from GitHub

By R. S. Doiel 2017-12-10

This is a just quick set of notes on harvesting my Gists on GitHub so I
have an independent copy for my own website. 

## Assumptions

In this gist I assume you are using Bash on a POSIX system (e.g. Raspbian 
on a Raspberry Pi) with the standard compliment of Unix utilities (e.g. cut, 
sed, curl). I also use Stephen Dolan's [jq](https://github.com/stedolan/jq)
as well as Caltech Library's [datatools](https://github.com/caltechlibrary/datatools).
See the respective GitHub repositories for installation instructions.
The gist harvest process was developed against GitHub's v3 API
(see developer.github.com). 

In the following examples "USER" is assumed to hold your GitHub user id 
(e.g. rsdoiel for https://github.com/rsdoiel).

## Getting my basic profile

This retrieves the public view of your profile.

```shell
    curl -o USER "https://api.github.com/users/USER"
```

## Find the urL for your gists

Get the gists url from `USER.json.

```shell
    GISTS_URL=$(jq ".gists_url" "USER.json" | sed -E 's/"//g' | cut -d '{' -f 1)
    curl -o gists.json "${GISTS_URL}"
```

Now `gists.json` should hold a JSON array of objects representing your Gists.

## Harvesting the individual Gists.

When you look at _gists.json_ you'll see a multi-level JSON structure.  It has been
formatted by the API so be easy to scrape.  But since this data is JSON and Caltech Library
has some nice utilities for working with JSON I'll use *jsonrange* and *jq* to pull out a list
of individual Gists URLS.

```shell
    jsonrange -i gists.json | while read I; do 
        jq ".[$I].files" gists.json | sed -E 's/"//g'
    done
```

Expanding this we can now curl each individual gist metadata to find URL to the raw file.


```shell
    jsonrange -i gists.json | while read I; do 
        jq ".[$I].files" gists.json | jsonrange -i - | while read FNAME; do
            jq ".[$I].files[\"$FNAME\"].raw_url" gists.json | sed -E 's/"//g'; 
        done;
    done
```

Now that we have URLs to the raw gist files we can use curl again to fetch each.

What do we want to store with our harvested gists?  The raw files, metadata
about the Gist (e.g. when it was created), the Gist ID. Putting it all together
we have the following script.

```shell
    #!/bin/bash
    if [[ "$1" = "" ]]; then
        echo "USAGE: $(basename "$0") GITHUB_USERNAME"
        exit 1
    fi

    USER="$1"
    curl -o "$USER.json" "https://api.github.com/users/$USER"
    if [[ ! -s "$USER.json" ]]; then
        echo "Someting went wrong getting https://api.github.cm/users/${USER}"
        exit 1
    fi

    GISTS_URL=$(jq ".gists_url" "$USER.json" | sed -E 's/"//g' | cut -d '{' -f 1)
    curl -o gists.json "${GISTS_URL}"
    if [[ ! -s gists.json ]]; then
        echo "Someting went wrong getting ${GISTS_URL}"
        exit 1
    fi

    # For each gist harvest our file
    jsonrange -i gists.json | while read I; do
        GIST_ID=$(jq ".[$I].id" gists.json | sed -E 's/"//g')
        mkdir -p "gists/$GIST_ID"
        echo "Saving gists/$GIST_ID/metadata.json"
        jq ".[$I]" gists.json > "gists/$GIST_ID/metadata.json"
        jq ".[$I].files" gists.json | jsonrange -i - | while read FNAME; do
            URL=$(jq ".[$I].files[\"$FNAME\"].raw_url" gists.json | sed -E 's/"//g')
            echo "Saving gist/$GIST_ID/$FNAME"
            curl -o "gists/$GIST_ID/$FNAME" "$URL"
        done;
    done
```







