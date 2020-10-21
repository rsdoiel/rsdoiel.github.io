#!/usr/bin/env python3
#
# query.py provides an interactive query of a LunrJS index from
# this command line (e.g. test your index with search terms).
#
import sys
import os
import json
from lunr.Index import Index

class Query:
    def __init__(self, index_name = "index.json"):
        self.index_name = index_name
        self.idx = None

    def load_lunr_index(self):
        print('Reading index {self.index_name}')
        with open(self.index_name) as fp:
            src = fp.read()
            index_serialized = json.loads(src)
            print('Loading index')
            self.idx = Index.load(index_serialized)

    def search(self, terms):
        results = self.idx.search(' '.join(terms))
        print(results)

    
if __name__ in "__main__":
    query = Query()
    query.load_lunr_index()
    query.search(sys.argv)
