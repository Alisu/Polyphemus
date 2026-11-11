#!/usr/bin/env bash
# check-shards.sh DIR MIN_CLASSES MIN_RUN: the suite logs of one edition's shards, found under
# DIR as *.log, read as one suite (bin/run-tests.sh, SHARD=k/n). Fails, with a !! line, when a
# shard is missing or did not end, when the shards do not hold the suite between them, each
# class once, or when fewer classes answered or fewer tests ran, skipped ones not counted, than
# the edition is known to run (bin/check-totals.sh, #164). Says the totals of them all.
set -uo pipefail
dir=$1 min_classes=$2 min_run=$3
logs=()
while IFS= read -r f; do logs+=("$f"); done < <(find "$dir" -type f -name '*.log' | LC_ALL=C sort)
[ ${#logs[@]} -gt 0 ] || { echo "!! no shard's log under $dir"; exit 1; }
awk -v min_classes="$min_classes" -v min_run="$min_run" '
  function bad(text) { print "!! " text; failed = 1 }
  FNR == 1 { file++; name[file] = FILENAME }
  /^== shard [0-9]+\/[0-9]+: [0-9]+ of [0-9]+ classes ==/ && !(file in k) {
    split($3, part, "[/:]"); k[file] = part[1] + 0; n[file] = part[2] + 0; whole[file] = $6 + 0 }
  /^RES / && !((file, $2) in seen) { seen[file, $2] = 1; shards_of[$2]++ }
  /^== totals:/ { totals[file] = 1; run[file] = $3; failures[file] = $5; errors[file] = $7
                  broken[file] = $9; flaky[file] = $11; skipped[file] = $13 }
  END {
    for (f = 1; f <= file; f++) {
      if (!(f in k)) { bad("a log that names no shard: " name[f]); continue }
      if (!shards) { shards = n[f]; suite = whole[f] }
      if (n[f] != shards || whole[f] != suite)
        bad("the shards do not agree on the suite: " k[f] "/" n[f] " of " whole[f] " classes, another of " shards " shards and " suite)
      logs_of[k[f]]++
      if (!(f in totals)) bad("no totals in shard " k[f] "/" n[f] ": it did not end")
      r += run[f]; fl += failures[f]; e += errors[f]; b += broken[f]; fk += flaky[f]; s += skipped[f] }
    for (i = 1; i <= shards; i++) {
      if (!(i in logs_of)) bad("no log of shard " i "/" shards)
      else if (logs_of[i] > 1) bad("two logs of shard " i "/" shards) }
    for (c in shards_of) { classes++; if (shards_of[c] > 1) bad("in more than one shard: " c) }
    if (classes + 0 != suite + 0) bad(classes + 0 " classes answered, the suite has " suite + 0)
    if (classes + 0 < min_classes + 0) bad(classes + 0 " classes answered, fewer than " min_classes)
    if (r - s < min_run + 0) bad(r - s " tests ran (" r + 0 " run, " s + 0 " skipped), fewer than " min_run)
    printf "== totals: %d run, %d failures, %d errors, %d broken, %d flaky, %d skipped ==\n", r, fl, e, b, fk, s
    if (!failed) printf "== %d classes answered in %d shards, %d tests ran (%d skipped)\n", classes, shards, r - s, s
    exit failed + 0 }' "${logs[@]}"
