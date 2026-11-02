#!/usr/bin/env bash
# What a CI run says, its failures sorted from the flakes we know (#31): green, known (only
# listed flakes failed), infra (no suite ran: a download, a runner) or new (anything else).
#
#   bin/ci-verdict.sh <run id>         each job of that run, its log read through gh
#   bin/ci-verdict.sh --log <file>     one job's log
#
# Exit 0 for green or known, 1 for new, 2 for infra or a run gh could not read. A listed flake is its test and the start of
# its message: the same test failing with another message is new. The list: bin/known-flakes.txt.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
KNOWN_FLAKES="${KNOWN_FLAKES:-$HERE/known-flakes.txt}"

judge() {  # one job's log on stdin: what failed, then VERDICT green|known|infra|new
  sed -E 's/^[0-9]{4}-[0-9-]+T[0-9:.]+Z //' | awk -v known="$KNOWN_FLAKES" '
    function trim(s) { gsub(/^ +| +$/, "", s); return s }
    BEGIN {
      while ((getline line < known) > 0) {
        if (line ~ /^#/ || split(line, f, "|") < 3) continue
        k++; ktest[k] = trim(f[1]); kmsg[k] = trim(f[2]); kissue[k] = trim(f[3]) } }
    /== totals/ { totals = 1 }
    /WARM ERR|Could not|##\[error\]|prepare BROKEN/ { if (!evidence) evidence = $0 }
    /^    FLAKY / { flaky[trim(substr($0, 11))] = 1; next }
    /^    (FAIL |ERROR) / {
      rest = $0; sub(/^    (FAIL |ERROR) +/, "", rest)
      at = index(rest, " -- "); t = at ? substr(rest, 1, at - 1) : rest; m = at ? substr(rest, at + 4) : ""
      if (!(t in msg)) { order[++n] = t; msg[t] = m }; next }
    /^RES [A-Za-z0-9]+ BROKEN/ {
      t = $2; if (!(t in msg)) { order[++n] = t; msg[t] = "BROKEN" substr($0, index($0, "BROKEN") + 6) } }
    END {
      if (!totals) { print "INFRA " (evidence ? evidence : "no suite ran"); print "VERDICT infra"; exit 2 }
      verdict = "green"
      for (i = 1; i <= n; i++) {
        t = order[i]; if (t in flaky) continue
        issue = ""
        for (j = 1; j <= k; j++) if (ktest[j] == t && index(msg[t], kmsg[j]) > 0) issue = kissue[j]
        if (issue != "") { print "KNOWN " issue " " t; if (verdict == "green") verdict = "known" }
        else { print "NEW " t (msg[t] ~ /^BROKEN/ ? " " : " -- ") msg[t]; verdict = "new" } }
      print "VERDICT " verdict
      exit (verdict == "new") }'
}

if [ "${1:-}" = "--log" ]; then judge < "$2"; exit $?; fi
[ $# -eq 1 ] || { sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

jobs=$(gh run view "$1" --json jobs -q '.jobs[] | "\(.databaseId) \(.conclusion // "pending") \(.name)"' 2>&1)
if [ $? -ne 0 ] || [ -z "$jobs" ]; then  # a run not read is no verdict, least of all green
  echo "${jobs:-no jobs}" | head -1; echo "VERDICT unread: read the run again"; exit 2; fi
worst=0
while read -r id conclusion name; do
  case "$conclusion" in
    success) echo "== $name: green" ;;
    failure|cancelled|timed_out)
      out=$(gh api "repos/{owner}/{repo}/actions/jobs/$id/logs" 2>/dev/null | judge); rc=$?
      echo "== $name: ${out##*VERDICT }"; grep -v '^VERDICT' <<<"$out" | sed 's/^/   /'
      [ "$rc" -eq 1 ] && worst=1
      [ "$rc" -eq 2 ] && [ "$worst" -eq 0 ] && worst=2 ;;
    *) echo "== $name: not finished ($conclusion)"; [ "$worst" -eq 0 ] && worst=2 ;;
  esac
done <<< "$jobs"
case "$worst" in 0) echo "VERDICT green or known: fast-forward stage2" ;; 1) echo "VERDICT new: look at it" ;;
  *) echo "VERDICT infra or unfinished: run the failed jobs again" ;; esac
exit "$worst"
