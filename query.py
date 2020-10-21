#!/usr/bin/env python3
#
# query.py provides an interactive query of a LunrJS index from
# this command line (e.g. test your index with search terms).
#
import sys
import os
import json
from lunr.index import Index

class Query:
    def __init__(self, index_name = "lunr.json"):
        self.index_name = index_name
        self.idx = None

    def load_lunr_index(self):
        print(f'Reading index {self.index_name}')
        with open(self.index_name) as fp:
            src = fp.read()
            index_serialized = json.loads(src)
            print('Loading index')
            self.idx = Index.load(index_serialized)

    def search(self, terms):
        results = self.idx.search(' '.join(terms))
        for i, item in enumerate(results):
            print(i, item['ref'])

    
if __name__ in "__main__":
    app_name = os.path.basename(sys.argv[0])
    if len(sys.argv) == 1:
        print(f'USAGE: {app_name} SEARCH_STRINGS')
        sys.exit(1)
    query = Query()
    query.load_lunr_index()
    query.search(sys.argv)
