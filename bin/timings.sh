# Each class's times in a setup's .test-timings, as "Class worst best": the worst for its time
# limit (a busy machine must not cut it off, #54), the best for its tier (a busy run must not move
# it to the slow tier for good, #118). A line of two fields is one time, both worst and best.
# Sourced by run-tests.sh and gate.sh; tested by timings-test.sh.

worst_time_of() {  # class file
  awk -v c="$1" '$1==c {print $2}' "$2" 2>/dev/null | tail -1
}

best_time_of() {  # class file
  awk -v c="$1" '$1==c {print ($3 == "" ? $2 : $3)}' "$2" 2>/dev/null | tail -1
}

is_slow_in() {  # file class threshold
  local t; t=$(best_time_of "$2" "$1")
  [ -n "$t" ] && [ "$t" -ge "$3" ]
}

merge_timings() {  # file new: the new runs' "Class seconds" folded into the file
  cat "$1" "$2" 2>/dev/null \
    | awk '{ w = $2; b = ($3 == "" ? $2 : $3) }
           !($1 in W) || w > W[$1] { W[$1] = w }
           !($1 in B) || b < B[$1] { B[$1] = b }
           END { for (c in W) print c, W[c], B[c] }' | sort > "$1.tmp"
  mv "$1.tmp" "$1"
}
