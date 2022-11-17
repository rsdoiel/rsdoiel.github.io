#!/usr/bin/env python3

import sys
import os
import requests
from datetime import datetime

headers = { 'Content-Type': 'application/json', 'User-Agent': 'requests'}
u = 'https://api.github.com/orgs/caltechlibrary'

resp = requests.get(u, headers = headers)
if resp.status_code != requests.codes.ok:
    print(f'Response status: {resp.status_code}')
    print(f'Reason: {resp.reason}')
    print(resp.text)
try:
    data = resp.json()
except Exception as err:
    print(f'ERROR: {err}', file=sys.stderr)
    print(f'MESSAGE: {data}')
for header in resp.headers:
    if header == 'X-RateLimit-Reset':
        t = int(resp.headers.get('X-RateLimit-Reset'))
        print('Reset at', end = ' ')
        print(datetime.fromtimestamp(t))
        print('Rate limit', end = ' ')
        print(resp.headers.get('x-ratelimit-limit'))
        print('Rate limit remaining', end = ' ')
        print(resp.headers.get('x-ratelimit-remaining'))
