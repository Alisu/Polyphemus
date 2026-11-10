# Each class's times in a setup's .test-timings, as "Class worst best t1 ... t5": its last five
# times, the worst of them for its time limit (a busy machine must not cut it off, #54; a busy day
# no longer sets it for good, #164), the best for its tier (a busy run must not move it to the slow
# tier, #118). Older lines read as their times: "Class t" one, "Class worst best" two.
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

merge_timings() {  # file new: the new runs' "Class seconds" folded into the file, five kept
  cat "$1" "$2" 2>/dev/null \
    | awk -v keep=5 '
        function add(c, t) { n[c]++; T[c, n[c]] = t }
        NF >= 4 { for (i = 4; i <= NF; i++) add($1, $i); next }
        NF == 3 { add($1, $3); add($1, $2); next }
        NF == 2 { add($1, $2) }
        END { for (c in n) {
                first = n[c] > keep ? n[c] - keep + 1 : 1; w = -1; b = -1; times = ""
                for (i = first; i <= n[c]; i++) { t = T[c, i]; times = times " " t
                  if (w < 0 || t + 0 > w + 0) w = t; if (b < 0 || t + 0 < b + 0) b = t }
                print c, w, b times } }' | sort > "$1.tmp"
  mv "$1.tmp" "$1"
}

prune_timings() {  # file class...: only the classes named kept, the suite's (#164)
  local file=$1; shift
  printf '%s\n' "$@" | awk 'NR == FNR { k[$1] = 1; next } $1 in k' - "$file" > "$file.tmp" 2>/dev/null
  mv "$file.tmp" "$file"
}
