#!/usr/bin/env bash
# The test classes a change in the working copy calls for (bin/gate.sh --commit): each changed
# class's own test, every test class whose source names a changed class (by name, so perform:
# and shared fixtures are caught where senders would miss them), and changed test classes.
#
#   bin/commit-selection.sh        CLASS lines, then CORE lines for changed classes listed in
#                                  bin/core-classes: those the whole suite tests (CI)
set -uo pipefail
cd "$(dirname "$0")/.."
changed=$( { git diff --name-only HEAD; git ls-files --others --exclude-standard; } \
  | sed -nE 's#^[^/]+\.package/([A-Za-z0-9_]+)\.(class|trait|extension)/.*#\1#p' | sort -u)
tests=$(ls -d *.package/*Test.class 2>/dev/null)
{
  for c in $changed; do
    case "$c" in *Test) echo "$c"; continue ;; esac
    ls -d *.package/"${c}Test.class" >/dev/null 2>&1 && echo "${c}Test"
    for t in $tests; do grep -rqw "$c" "$t" && basename "$t" .class; done
  done
} | sort -u | while read -r t; do
  ls -d *.package/"$t.class" >/dev/null 2>&1 && echo "CLASS $t"
done
for c in $changed; do grep -qx "$c" bin/core-classes && echo "CORE $c"; done
exit 0
