#!/usr/bin/env python3
#
# indexer.py, index my website and generate a LunrJS style JSON
# index for use by LunrJS in for website search.
#
import sys
import os
import io
import json
from subprocess import run, Popen, PIPE

from lunr import lunr

def normalize_text(src):
    if src.startswith('---\n'):
        parts = src.split('---\n')
        src = parts[2].rstrip()
    for c in [ "\r", "\n", "\t", "[", "]", "(", ")"]:
        src = src.replace(c, " ")
    return src

def document_as_object(key, fname):
    obj = {}
    cmd = ['pttk', 'frontmatter', fname]
    with Popen(cmd, stdout = PIPE, encoding = 'utf-8') as proc:
        src = proc.stdout.read()
        if src.startswith('{'):
            obj = json.loads(src)
        else:
            return None, f'No front matter found {fname}'
    with io.open(fname, encoding = 'utf-8') as fp:
        src = fp.read()
        obj['_Key'] = key
        obj["_Document"] = normalize_text(src)
        return obj, None
    return None, None


class Indexer:
    def __init__(self, start_path = ".", htdocs_prefix = "", index_name = "lunr.json"):
        self.start_path = start_path
        self.htdocs_prefix = htdocs_prefix
        self.index_name = index_name
        self.files = []
        self.documents = []

    def harvest_metadata(self):
        for root, dirs, files in os.walk(self.start_path):
            for name in files:
                fname = os.path.join(root, name)
                _, ext = os.path.splitext(name)
                if ext == ".md":
                    self.files.append(fname)
                    key = os.path.join(self.htdocs_prefix, fname)
                    [obj, err] = document_as_object(key, fname)
                    if (obj != None) and (len(obj) > 0):
                        print(f'Indexing document {fname} as {key}')
                        self.documents.append(obj)

    def lunr_index(self):
        print('Collecting fields ...')
        field_names = []
        fields = []
        for i, obj in enumerate(self.documents):
            for key in obj:
                if not key in field_names:
                    field_names.append(key)
                    if type(obj[key]) == 'list':
                        for term in obj[key]:
                            fields.append(dict(field_name=key, extractor = lambda x: f'{x}'))

                    if type(obj[key]) != 'string':
                        fields.append(dict(field_name=key, extractor = lambda x: f'{x}'))
                    else:
                        fields.append(key)
        print(f'Found {len(fields)} unique fields to index')
        print(f'Fields: {", ".join(field_names)}')
        print(f'Generating LunrJS index {self.index_name}')
        idx = lunr(ref = '_Key', fields = fields, documents = self.documents, languages = 'en')
        index = idx.serialize()
        with io.open(self.index_name, 'w', encoding = 'utf-8') as fp:
            src = json.dumps(index)
            fp.write(src)

    def report(self):
        print(f'Start path: {self.start_path}')
        print(f'Htdocs prefix: {self.htdocs_prefix}')
        print(f'Index name: {self.index_name}')
        print(f"{len(self.files)} files scanned.")
        print(f"{len(self.documents)} documents indexed.")

    
if __name__ in "__main__":
    site = Indexer(start_path = 'blog')
    site.harvest_metadata()
    site.lunr_index()
    site.report()
