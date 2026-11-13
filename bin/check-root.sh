#!/usr/bin/env bash
# check-root.sh LOG CLASSES: the root step's classes, CLASSES of them, each answered and green
# (#177). Red, with a !! line, on a class that did not answer, broke, timed out, failed, or had
# every test skipped: a class that ran nothing of its own is no green.
set -uo pipefail
log=$1 want=$2
bad=0
got=$(grep -ac '^RES ' "$log")
[ "$got" -eq "$want" ] || { echo "!! $got of $want classes answered"; bad=1; }
while IFS= read -r line; do
  echo "!! ${line#RES }"; bad=1
done < <(grep -aE '^RES [A-Za-z0-9_]+ (BROKEN|TIMEOUT)|^RES .* [1-9][0-9]* (failures|errors)' "$log")
while IFS= read -r class; do
  echo "!! $class: every test skipped"; bad=1
done < <(awk '$1 == "RES" && $4 == "run" && $10 == "skipped" && $9 == $3 { print $2 }' "$log")
exit "$bad"
