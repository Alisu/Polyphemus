#!/usr/bin/env bash
# A run's flakes and failures as GitHub annotations, which are kept, and public, even when the
# job's log is not: bin/flakes.sh counts them over many runs (#31). In CI, after the suite.
#
#   bin/annotate-results.sh ~/setup/.test-results
#
# FLAKY: failed, then passed alone in a fresh process (bin/run-tests.sh). failed: stayed failed.
f="${1:?the results file of a run}"
[ -f "$f" ] || exit 0
annotate() {  # title, then lines on stdin; % is the one character annotations need escaped here
  sed -e 's/%/%25/g' -e "s/^/::$1::/"
}
grep -a '^    FLAKY ' "$f" | cut -c11-400 | annotate 'warning title=flaky'
grep -aE '^    (FAIL |ERROR) ' "$f" | cut -c11-400 | annotate 'error title=failed'
grep -aE '^RES [A-Za-z0-9_]+ (TIMEOUT|BROKEN)' "$f" | cut -c5-400 | annotate 'error title=failed'
exit 0
