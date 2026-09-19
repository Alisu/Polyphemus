#!/usr/bin/env python3
"""Print LONG COMMENT for every method whose leading comment is over three lines.

The working agreement keeps method comments to one to three lines: what the method does,
plus any trap a caller must know. History and measurements go to issues, commits or docs.
"""
import os, sys

root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), '..')
for dirpath, _, files in os.walk(root):
    if '.git' in dirpath:
        continue
    for name in sorted(files):
        if not name.endswith('.st'):
            continue
        path = os.path.join(dirpath, name)
        body = '\n'.join(open(path, encoding='utf-8', errors='replace').read().split('\n')[2:]).lstrip()
        if not body.startswith('"'):
            continue
        end = 1
        while True:
            end = body.find('"', end)
            if end == -1 or end + 1 >= len(body) or body[end + 1] != '"':
                break
            end += 2
        lines = body[:end + 1].count('\n') + 1
        if lines > 3:
            print(f'LONG COMMENT {os.path.relpath(path, root)} ({lines} lines)')
