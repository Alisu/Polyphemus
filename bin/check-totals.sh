#!/usr/bin/env bash
# check-totals.sh LOG MIN_CLASSES MIN_RUN: a suite is not green on what it did not run (#164).
# Fails, with a !! line, when fewer classes answered (a class run again for a retry counts
# once) or fewer tests ran, skipped ones not counted, than the job is known to run.
set -uo pipefail
log=$1 min_classes=$2 min_run=$3
classes=$(grep -a '^RES ' "$log" | awk '{ print $2 }' | sort -u | wc -l | tr -d ' ')
totals=$(grep -a '^== totals:' "$log" | tail -1)
[ -n "$totals" ] || { echo "!! no totals: the suite did not end"; exit 1; }
run=$(sed -E 's/.*totals: ([0-9]+) run.*/\1/' <<<"$totals")
skipped=$(sed -nE 's/.*, ([0-9]+) skipped.*/\1/p' <<<"$totals"); skipped=${skipped:-0}
bad=0
[ "$classes" -ge "$min_classes" ] || { echo "!! $classes classes answered, fewer than $min_classes"; bad=1; }
ran=$((run - skipped))
[ "$ran" -ge "$min_run" ] || { echo "!! $ran tests ran ($run run, $skipped skipped), fewer than $min_run"; bad=1; }
[ "$bad" = 0 ] && echo "== $classes classes answered, $ran tests ran ($skipped skipped)"
exit "$bad"
