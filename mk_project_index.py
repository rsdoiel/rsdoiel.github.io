#!/usr/bin/env python

import sys
import os
import requests
import time
import logging as log

log.basicConfig(encoding='utf-8', level=log.INFO)

request_delay = 15

version = 'v0.0.0'

def usage(app_name):
    page = f'''% {app_name}(1) user manual
% R. S. Doiel
% 2022-11-16

# NAME

{app_name}

# SYNOPSIS

{app_name} [OPTIONS] GITHUB_ORGANIZATION OUTPUT_FILENAME

# DESCRIPTION

{app_name} queries the GitHub API for listing public repositories then uses their
pages API to list project repositories that have implemented pages for documentation.
{app_name} then outputs a Markdown document holding the resulting index. I can also
generate an sitemap.xml

The GITHUB_ORGANIZATION is the name of the user or organization that
you're trying to build the index for.

# OPTIONS

-h, -help, --help
: display this help

-version
: display version info

# EXAMPLE

Generate a markdown index page for "caltechlibrary" organization.

~~~
    {app_name} caltechlibrary
~~~

# REFERENCE LINKS

- [GitHub Public Repositories](https://docs.github.com/en/rest/repos/repos#list-public-repositories)
- [GitHub Pages API](https://docs.github.com/en/rest/pages)

'''  
    return page


def mk_project_index(username, url_prefix, out_name):
    app_name = os.path.basename(sys.argv[0])
    if username == '':
        return 'organization name was an empty string'
    if url_prefix == '':
        return  'missing url prefix'
    if out_name == '':
        return 'missing output filename'
    log.info(f'Checking {username} using url prefix {url_prefix}, output to {out_name}')
    page_no = 1
    projects = []
    continue_requests = True
    u = f'https://api.github.com/users/{username}/repos'
    headers = { 'Content-Type': 'application/json', 'User-Agent': 'requests' }
    while continue_requests:
        params = { 'type': 'public', 'sort': 'full_name', 'page': page_no }
        log.info(f'Request {u} {params}')
        resp = requests.get(u, params = params, headers = headers)
        if resp.status_code == requests.codes.ok:
            try:
                data = resp.json()
            except err:
                log.error(f'Request {u} {params} -> {err}')
                return err
            # NOTE: if we have a zero length array return then we done paging through results.
            if len(data) > 0:
                for repo in data:
                    repo_name = repo['name']
                    if not url_prefix.startswith(f'https://{repo_name}') and ("has_pages" in repo) and repo["has_pages"]:
                        log.info(f'Including {repo_name}')
                        projects.append(repo_name)
                    else:
                        log.debug(f'Skipping {repo_name}')
                page_no += 1
                log.info(f'Waiting {request_delay} seconds before requesting next page {page_no} of results')
                # Wait `request_delay` seconds before next request, rate limit is one a second
                time.sleep(request_delay)
                log.debug('Continuing to next page request now')
            else:
                continue_requests = False 

        else:
            log.warning(f'{resp.status_code} -> reason {resp.reason}')

    if len(projects) > 0:
        projects.sort()
        page = ['''
Project Documentation Index
===========================

Below is a list of experiments and project documentation.

''']
        for repo_name in projects:
            page.append(f'- [{repo_name}](./{repo_name}/)')
        with open(out_name, 'w') as f:
            f.write('\n'.join(page))
        return None
    else:
        return 'No repositories found'

if __name__ == '__main__':
    app_name = os.path.basename(sys.argv[0])
    show_help, show_version = False, False
    options = []
    for i, arg in enumerate(sys.argv):
        if arg.startswith('-'):
            if arg in [ '-h', '-help', '--help' ]:
                show_help = True
            elif arg in [ '-version' ]:
                show_version = True
            else:
                print(f'ERROR unsuppoted option ({i}) {arg}', file=sys.stderr)
                sys.exit(1)
        elif i > 0:
            options.append(arg)
    if show_help:
        print(usage(app_name))
        sys.exit(0)
    if show_version:
        print(f'{app_name} {version}')
        sys.exit(0)
    
    if len(options) != 2:
        print(f'Missing GitHub organization name or output filename, see {app_name} -help')
        sys.exit(1)
    username, out_name = options[0], options[1]
    err = mk_project_index(username, f'https://{username}.github.io/', out_name)
    if err != None:
        print(f'ERROR: {err}')
        sys.exit(1)
    
