#!/usr/bin/env python3
"""Count what drifts in the working copy: the same thing written twice, handlers and nil checks.

    bin/drift.py [root]          one line per count, for the code and for the tests
    bin/drift.py [root] --list   also the methods behind the copies and the wait loops

For the drift pass before a tag (#212): run it at the tag before and at this one, and read the
difference. It counts text, so it finds repeated code, not one idea written two different ways.
"""
import collections, os, re, sys


def methods(root):
    """Each method file of the packages under root: its class, selector, source and body lines."""
    for package in sorted(os.listdir(root)):
        if not package.endswith('.package'):
            continue
        for holder in sorted(os.listdir(os.path.join(root, package))):
            if not holder.endswith(('.class', '.extension', '.trait')):
                continue
            name = holder.rsplit('.', 1)[0]
            for side in ('instance', 'class'):
                folder = os.path.join(root, package, holder, side)
                if not os.path.isdir(folder):
                    continue
                for file in sorted(os.listdir(folder)):
                    if not file.endswith('.st'):
                        continue
                    with open(os.path.join(folder, file), encoding='utf-8', errors='replace') as stream:
                        lines = stream.read().split('\n')
                    yield {
                        'name': name + ('>>' if side == 'instance' else ' class>>') + file[:-3].replace('.', ':'),
                        'class': name,
                        'own': holder.endswith('.class'),
                        'test': 'Tests' in package or name.endswith(('Test', 'TestCase')),
                        'source': without_comments('\n'.join(lines[1:])),
                        'raw': '\n'.join(lines[1:]),
                        'body': body_lines(lines[2:]),
                    }


def without_comments(text):
    return re.sub(r'"[^"]*"', '', text)


def body_lines(lines):
    """The lines of a body that say something, spaces made one."""
    kept = []
    for line in without_comments('\n'.join(lines)).split('\n'):
        line = re.sub(r'\s+', ' ', line).strip()
        if line and line not in ('|', ']', '].', '^ self'):
            kept.append(line)
    return kept


WAITS = re.compile(r'whileFalse|whileTrue|timesRepeat|anySatisfy|detect:')
PATTERNS = (
    ('handlers of every Error', r'on:\s*Error\b(?!\s*,)\s*do:'),
    ('handlers of any kind', r'\bon:\s*[A-Z][A-Za-z, ]*\s*do:'),
    ('handlers that answer nil, false or empty', r"do:\s*\[\s*(:\w+\s*\|)?\s*(nil|false|#\(\s*\)|'')\s*\]"),
    ('nil checks (ifNil:, ifNotNil:)', r'\bif(Not)?Nil:'),
    ('respondsTo:', r'\brespondsTo:'),
    ('isKindOf:', r'\bisKindOf:'),
)


def count(part):
    """The counts of one part, the code or the tests, and the methods behind some of them."""
    bodies = [method['body'] for method in part]
    lines = sum(len(body) for body in bodies)
    text = '\n'.join(method['source'] for method in part)
    counts = collections.OrderedDict()
    counts['classes'] = len({method['class'] for method in part if method['own']})
    counts['methods'] = len(part)
    counts['lines'] = lines
    for label, pattern in PATTERNS:
        found = len(re.findall(pattern, text))
        counts[label] = '%d (%.1f per 1000 lines)' % (found, 1000.0 * found / max(lines, 1))
    waits = [m['name'] for m in part if 'Delay for' in m['source'] and WAITS.search(m['source'])]
    counts['hand-written wait loops'] = len(waits)
    cited = sum(1 for method in part if re.search(r'#\d{1,3}\b', method['raw']))
    counts['methods citing an issue'] = '%d (%.1f%%)' % (cited, 100.0 * cited / max(len(part), 1))
    same = collections.defaultdict(list)
    for method, body in zip(part, bodies):
        if len(body) >= 3:
            same['\n'.join(body)].append(method['name'])
    copies = [names for names in same.values() if len(names) > 1]
    counts['bodies of 3 lines or more written twice'] = '%d groups, %d methods' % (len(copies), sum(map(len, copies)))
    long = [(method['name'], frozenset(body)) for method, body in zip(part, bodies) if len(body) >= 8]
    near = []
    for index, (name, body) in enumerate(long):
        for other, another in long[index + 1:]:
            if abs(len(body) - len(another)) <= 0.3 * max(len(body), len(another)) \
                    and len(body & another) >= 0.8 * len(body | another):
                near.append((name, other))
    counts['bodies of 8 lines or more 80% alike'] = '%d pairs' % len(near)
    largest = collections.Counter(method['class'] for method in part if method['own']).most_common(5)
    counts['largest classes'] = ', '.join('%s %d' % each for each in largest)
    return counts, {'copies': copies, 'near': near, 'waits': waits}


def main(arguments):
    listing = '--list' in arguments
    roots = [each for each in arguments if not each.startswith('--')]
    root = roots[0] if roots else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
    every = list(methods(root))
    for label, part in (('code', [m for m in every if not m['test']]), ('tests', [m for m in every if m['test']])):
        counts, behind = count(part)
        print('== ' + label)
        for name, value in counts.items():
            print('  %-44s %s' % (name, value))
        if listing:
            for names in behind['copies']:
                print('  COPY ' + ' = '.join(names))
            for name, other in behind['near']:
                print('  NEAR ' + name + ' ~ ' + other)
            for name in behind['waits']:
                print('  WAIT ' + name)


if __name__ == '__main__':
    main(sys.argv[1:])
