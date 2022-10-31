#!/bin/bash

#
# twtwt.bash is a bone dead simple twtxt publisher script based
# on the simple example at https://twtxt.readthedocs.io/en/latest/user/intro.html.
#


function usage () {
    APP_NAME=$(basename "$0")
    cat <<EOT
% ${APP_NAME}(1) user manual
% R. S. Doiel
% 2022-10-31

# NAME

${APP_NAME}

# SYNOPSIS

${APP_NAME} [OPTIONS] TWTXT_POST [TWTXT_POST ...]

# DESCRIPTION

Update the twtxt.txt file in the current directory. This is the format that
yarn.social is based on. See https://twtxt.readthedocs.io/en/latest/user/intro.html
for details.

# OPTIONS

-h, -help, --help
: display help

# EXAMPLE

A helloworld type post.

~~~
${APP_NAME} "Hello World of twtxt!"
~~~

EOT

}
function pubTwtxt() {
    TEXT="$1"
    # Generte an RFC3339, e.g. '+"%Y-%m-%dT%H:%M:%SZ%z"'
    TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%SZ%z")
if [ ! -f twtxt.txt ]; then
    touch twtxt.txt
    chmod 664 twtxt.txt
fi
printf "%s\t%s\n" "${TIMESTAMP}" "${TEXT}"
printf "%s\t%s\n" "${TIMESTAMP}" "${TEXT}" >>twtxt.txt
}

#
# Main processing
#
for ARG in "$@"; do
    case "$ARG" in
        -h|-help|--help)
        usage
        exit 0
        ;;  
    esac
done

if [[ "$#" = "0" ]]; then
    usage
    exit 1
fi
for POST in "$@"; do
    pubTwtxt "$POST"
done
