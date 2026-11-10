#!/usr/bin/env bash
# already-judged.sh SHA: whether a ci/ branch's run of this very commit was judged green or
# known, as for its fast-forward to stage2; then stage2's run of it skips its suite (#164).
# Prints skip=true and run=<id>, or skip=false, for $GITHUB_OUTPUT. Tested by already-judged-test.sh.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
VERDICT="${VERDICT:-$HERE/ci-verdict.sh}"
sha=$1
runs=$(gh api "repos/$GITHUB_REPOSITORY/actions/runs?head_sha=$sha&status=completed&per_page=50" \
  -q '.workflow_runs[] | select(.head_branch | startswith("ci/")) | .id' 2>/dev/null)
for run in $runs; do
  if "$VERDICT" "$run" 2>/dev/null | grep -q '^VERDICT green or known'; then
    echo "skip=true"; echo "run=$run"; exit 0
  fi
done
echo "skip=false"
