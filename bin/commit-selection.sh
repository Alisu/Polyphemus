#!/usr/bin/env bash
# What changed in the working copy, for the commit gate (bin/gate.sh --commit), which asks the
# image which tests reach it (bin/select-tests.st, TestImpact):
#
#   bin/commit-selection.sh        CHANGE <Class> <selector> for a method (its file names it, a
#                                  colon written as a dot), CHANGE <Class> for a class's definition,
#                                  then CORE <Class> for changed classes in bin/core-classes: those
#                                  the whole suite tests (CI)
set -uo pipefail
cd "$(dirname "$0")/.."
paths=$( { git diff --name-only HEAD; git ls-files --others --exclude-standard; } | sort -u)
sed -nE 's#^[^/]+\.package/([A-Za-z0-9_]+)\.(class|extension)/(instance|class)/(.+)\.st$#CHANGE \1 \4#p' <<<"$paths" \
  | awk '{ gsub(/\./, ":", $3); print }'
sed -nE 's#^[^/]+\.package/([A-Za-z0-9_]+)\.(class|trait)/properties\.json$#CHANGE \1#p' <<<"$paths"
changed=$(sed -nE 's#^[^/]+\.package/([A-Za-z0-9_]+)\.(class|trait|extension)/.*#\1#p' <<<"$paths" | sort -u)
for c in $changed; do grep -qx "$c" bin/core-classes && echo "CORE $c"; done
exit 0
