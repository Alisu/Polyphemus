#!/usr/bin/env python3
"""Print LONG COMMENT for every method holding a comment over three lines, and fail if any.

The working agreement keeps method comments to one to three lines: what the method does,
plus any trap a caller must know. History and measurements go to issues, commits or docs.
"""
import os, sys

# Methods copied from elsewhere keep their authors' comments as they were.
NOT_OURS = {
    'Polyphemus-Memory.package/Spur32BitMemoryManager.extension/instance/defaultEdenBytes.st',
    'Polyphemus-Memory.package/Spur64BitMemoryManager.extension/instance/defaultEdenBytes.st',
    'Polyphemus-Memory.package/StackInterpreter.extension/instance/interpreterAllocationReserveBytes.st',
    'Polyphemus-Memory.package/DebugSession.extension/instance/isContextPostMortem..st',
    # Code its first author left commented out, and a note of theirs, as they wrote them.
    'Polyphemus-Object.package/OOPAbstractEntity.class/instance/oopByteSize.st',
    'Polyphemus-Object.package/OOPCompiledCodeObject.class/instance/containedInspectionItems.st',
    'Polyphemus-Tests.package/AbstractInspectorsTest.class/instance/setUpUsingImage..st',
}


def comments(source):
    """The comments of a method's source: what is between double quotes, outside its strings
    and character literals ($" is one), a doubled quote staying inside."""
    found, i = [], 0
    while i < len(source):
        ch = source[i]
        if ch == '$':
            i += 2
        elif ch == "'":
            i += 1
            while i < len(source):
                if source[i] == "'":
                    if i + 1 < len(source) and source[i + 1] == "'":
                        i += 2
                        continue
                    break
                i += 1
            i += 1
        elif ch == '"':
            start = i
            i += 1
            while i < len(source):
                if source[i] == '"':
                    if i + 1 < len(source) and source[i + 1] == '"':
                        i += 2
                        continue
                    break
                i += 1
            found.append(source[start:i + 1])
            i += 1
        else:
            i += 1
    return found


root = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), '..')
reported = 0
for dirpath, _, files in os.walk(root):
    if '.git' in dirpath:
        continue
    for name in sorted(files):
        if not name.endswith('.st') or '.package' not in dirpath:
            continue  # bin's scripts are not methods
        path = os.path.join(dirpath, name)
        if os.path.relpath(path, root) in NOT_OURS:
            continue
        # The first line is the method's category, the second its pattern.
        source = '\n'.join(open(path, encoding='utf-8', errors='replace').read().split('\n')[2:])
        longest = max((c.count('\n') + 1 for c in comments(source)), default=0)
        if longest > 3:
            print(f'LONG COMMENT {os.path.relpath(path, root)} ({longest} lines)')
            reported += 1
sys.exit(1 if reported else 0)
