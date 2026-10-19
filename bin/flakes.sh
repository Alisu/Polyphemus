#!/usr/bin/env bash
# How often each test flaked or failed in CI's last runs, most often first, with the jobs it
# happened in: counted from the runs' annotations (bin/annotate-results.sh). Needs gh, logged in
# (the annotations of 30 runs are some 300 requests, past GitHub's unauthenticated limit).
#
#   bin/flakes.sh          the last 30 runs, every branch
#   bin/flakes.sh 100
set -euo pipefail
RUNS="${1:-30}"
REPO="${REPO:-Alisu/Polyphemus}"
python3 - "$RUNS" "$REPO" <<'PY'
import json, subprocess, sys, collections
runs, repo = int(sys.argv[1]), sys.argv[2]
def api(path):
    return json.loads(subprocess.run(["gh", "api", path], check=True, capture_output=True, text=True).stdout)
seen = collections.defaultdict(lambda: collections.Counter())
jobs_of = collections.defaultdict(set)
listed = api(f"repos/{repo}/actions/runs?per_page={min(runs, 100)}")["workflow_runs"][:runs]
for run in listed:
    for job in api(f"repos/{repo}/actions/runs/{run['id']}/jobs?per_page=100")["jobs"]:
        for note in api(f"repos/{repo}/check-runs/{job['id']}/annotations"):
            if note.get("title") not in ("flaky", "failed"):
                continue
            test = note["message"].split(" -- ")[0].split(" ")[0]
            seen[test][note["title"]] += 1
            jobs_of[test].add(job["name"])
print(f"{len(listed)} runs, {listed[-1]['created_at'][:10] if listed else '-'} to {listed[0]['created_at'][:10] if listed else '-'}")
for test, counts in sorted(seen.items(), key=lambda kv: -sum(kv[1].values())):
    print(f"{counts['flaky']:4} flaky {counts['failed']:4} failed  {test}  ({', '.join(sorted(jobs_of[test]))})")
if not seen:
    print("no flake or failure annotated")
PY
