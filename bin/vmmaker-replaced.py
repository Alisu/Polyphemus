#!/usr/bin/env python3
# vmmaker-replaced.py VMMAKER_SRC [REPO [PHARO]]: the VMMaker methods our packages replace,
# which bin/vmmaker-replaced.txt lists and may only shrink (#118). VMMAKER_SRC is pharo-vm's
# smalltalksrc (Tonel), REPO this checkout (FileTree), PHARO the edition, whose packages are
# those its baseline loads: its own edition package, the memory map's from Pharo 11 on.
import glob, os, re, sys

def vmmaker_methods(src):
    defs = {}
    for f in glob.glob(os.path.join(src, "**", "*.st"), recursive=True):
        text = open(f, encoding="utf-8", errors="ignore").read()
        for m in re.finditer(r"#name : #([A-Za-z0-9_]+)", text):
            defs.setdefault(m.group(1), set())
        for m in re.finditer(r"^([A-Z][A-Za-z0-9_]*)( class)? >> (.+?)\s*\[\s*$", text, re.M):
            parts = m.group(3).split()
            keywords = [p for p in parts if p.endswith(":")]
            selector = "".join(keywords) if keywords else parts[0]
            defs.setdefault(m.group(1) + (m.group(2) or ""), set()).add(selector)
    return defs

def loaded(package, pharo):
    if pharo is None:
        return True
    m = re.match(r"Polyphemus-Edition-Pharo(\d+)$", package)
    if m:
        return int(m.group(1)) == pharo
    return not ("MemoryMap" in package and pharo < 11)

def replaced(src, repo, pharo=None):
    defs, found = vmmaker_methods(src), []
    for d in glob.glob(os.path.join(repo, "Polyphemus-*.package", "*.extension")):
        if not loaded(os.path.basename(os.path.dirname(d))[:-len(".package")], pharo):
            continue
        cls = os.path.basename(d)[:-len(".extension")]
        for side in ("instance", "class"):
            key = cls + (" class" if side == "class" else "")
            for f in glob.glob(os.path.join(d, side, "*.st")):
                selector = os.path.basename(f)[:-3].replace(".", ":")
                if selector in defs.get(key, ()):
                    found.append(os.path.basename(os.path.dirname(d))[:-len(".package")] + " " + key + ">>" + selector)
    return sorted(found)

if __name__ == "__main__":
    repo = sys.argv[2] if len(sys.argv) > 2 else os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
    listed = set()
    with open(os.path.join(repo, "bin", "vmmaker-replaced.txt")) as f:
        listed = {l.strip() for l in f if l.strip() and not l.startswith("#")}
    pharo = int(sys.argv[3]) if len(sys.argv) > 3 else None
    new = [r for r in replaced(sys.argv[1], repo, pharo) if r not in listed]
    for r in new:
        print("!! replaces a VMMaker method, not listed in bin/vmmaker-replaced.txt: " + r)
    sys.exit(1 if new else 0)
