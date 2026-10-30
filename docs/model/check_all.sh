#!/usr/bin/env bash
# Check every property of the four models, in each design, with TLC. One line per check; the
# counterexamples are left in results/, and trace.py prints one step by step.
#
#   ./check_all.sh
#
# Needs Java and tools/tla2tools.jar (TLA+ 1.7.4, from github.com/tlaplus/tlaplus/releases).
cd "$(dirname "$0")"
jar=tools/tla2tools.jar
[ -f "$jar" ] || { echo "no $jar: get tla2tools.jar from the TLA+ releases on GitHub"; exit 2; }
mkdir -p results

check() {   # $1 module, $2 property kind and name, $3 a label, the rest: NAME=VALUE constants
  local module=$1 prop=$2 label=$3; shift 3
  { echo "SPECIFICATION Spec"; echo "CONSTANTS"
    for c in "$@"; do echo "    ${c%%=*} = ${c#*=}"; done
    echo "$prop"
    grep -q "^StateBound" "$module.tla" && echo "CONSTRAINT StateBound"
  } > results/check.cfg
  local out="results/$module-${prop#* }-$(echo "$@" | tr ' =' '_-').txt"
  java -XX:+UseParallelGC -cp "$jar" tlc2.TLC -config results/check.cfg -workers 4 -deadlock \
    -metadir "results/states-$$" -nowarning "$module.tla" > "$out" 2>&1
  rm -rf "results/states-$$"
  local verdict
  if grep -qE "^Error: (Invariant|Temporal)" "$out"; then
    verdict="FAILS ($(grep -c '^State ' "$out") steps)"
  elif grep -q "^Error" "$out"; then
    verdict="ERROR: $(grep -m1 '^Error' "$out")"
  else
    verdict="holds ($(grep -o '[0-9,]* distinct states' "$out" | tail -1))"
  fi
  printf '%-12s %-42s %-22s %s\n' "$module" "$label" "${prop#* }" "$verdict"
}

# Hold: a plain hold, then a runUntil:, either side dying at any step.
for stop in FALSE TRUE; do
  for design in "FALSE FALSE FALSE" "TRUE FALSE FALSE" "TRUE TRUE FALSE" "TRUE TRUE TRUE"; do
    set -- $design; bell=$1 guard=$2 sees=$3
    for prop in "INVARIANT NoStrayHold" "INVARIANT NoTrapLeft" "INVARIANT NoBadWrite" \
                "INVARIANT NoLostHold" "PROPERTY AskEnds" "PROPERTY FreeIfObserverDies" \
                "PROPERTY FreeWhenThrough"; do
      check Hold "$prop" "stop=$stop bell=$bell guard=$guard trap=$sees" MaxHolds=2 MaxAsks=1 \
        WithTrap=TRUE HoldLimit=TRUE FastObserver=TRUE SeparateBell=$bell \
        BellEndedGuard=$guard FallbackSeesTrap=$sees StopEndsWithObserver=$stop
    done
  done
done

# HoldPair: two observers holding each other (#117).
for watchdog in FALSE TRUE; do
  for limit in TRUE FALSE; do
    check HoldPair "PROPERTY BothThrough" "watchdog=$watchdog limit=$limit" HoldLimit=$limit \
      AtomicStops=FALSE RefuseWhileHolding=FALSE WatchdogStops=$watchdog
  done
done

# InjectPair: two observers putting a watcher into the same image at once.
for lock in FALSE TRUE; do
  for prop in "INVARIANT NoWriteWhileRunning" "INVARIANT OneWatcher" "PROPERTY BothDone"; do
    check InjectPair "$prop" "stop lock=$lock" StopLock=$lock
  done
done

# StopHelper: the stop helper of #137, two observers, helpers that may be killed.
for kill in FALSE TRUE; do
  for prop in "INVARIANT NoBadReadOrWrite" "INVARIANT OneHolder" "PROPERTY NeverStoppedForEver"; do
    check StopHelper "$prop" "helpers killable=$kill" RecoverStale=TRUE MaxTries=2 HelpersKillable=$kill
  done
done
