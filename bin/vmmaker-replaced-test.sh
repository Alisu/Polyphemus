#!/usr/bin/env bash
# Tests of bin/vmmaker-replaced.py, on a VMMaker and a checkout made here. No Pharo.
#
#   bin/vmmaker-replaced-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
failures=0
check() { if eval "$2"; then echo "ok   $1"; else echo "FAIL $1"; failures=$((failures + 1)); fi; }
dir=$(mktemp -d)
mkdir -p "$dir/vm/VMMaker" "$dir/repo/bin" "$dir/repo/Polyphemus-Memory.package/StackInterpreter.extension/instance" \
  "$dir/repo/Polyphemus-Memory.package/StackInterpreter.extension/class"
cat > "$dir/vm/VMMaker/StackInterpreter.class.st" <<'ST'
Class {
	#name : #StackInterpreter,
	#superclass : #Object
}

StackInterpreter >> interpreterAllocationReserveBytes [
	^ 1
]

StackInterpreter >> at: index put: value [
	^ value
]

StackInterpreter class >> initialize [
]
ST
printf 'accessing\ninterpreterAllocationReserveBytes\n\t^ 2\n' > "$dir/repo/Polyphemus-Memory.package/StackInterpreter.extension/instance/interpreterAllocationReserveBytes.st"
printf 'accessing\nourOwn\n\t^ 3\n' > "$dir/repo/Polyphemus-Memory.package/StackInterpreter.extension/instance/ourOwn.st"
: > "$dir/repo/bin/vmmaker-replaced.txt"
out=$(python3 "$HERE/vmmaker-replaced.py" "$dir/vm" "$dir/repo" 2>&1); rc=$?
check "a replaced method not listed fails, named" "[ $rc = 1 ] && grep -q 'Polyphemus-Memory StackInterpreter>>interpreterAllocationReserveBytes' <<<\"\$out\""
check "a method VMMaker has not is no replacement" "! grep -q ourOwn <<<\"\$out\""
echo 'Polyphemus-Memory StackInterpreter>>interpreterAllocationReserveBytes' > "$dir/repo/bin/vmmaker-replaced.txt"
out=$(python3 "$HERE/vmmaker-replaced.py" "$dir/vm" "$dir/repo" 2>&1); rc=$?
check "a listed one passes" "[ $rc = 0 ]"
printf 'accessing\nat: index put: value\n\t^ nil\n' > "$dir/repo/Polyphemus-Memory.package/StackInterpreter.extension/instance/at.put..st"
printf 'class initialization\ninitialize\n' > "$dir/repo/Polyphemus-Memory.package/StackInterpreter.extension/class/initialize.st"
out=$(python3 "$HERE/vmmaker-replaced.py" "$dir/vm" "$dir/repo" 2>&1); rc=$?
check "keyword selectors and the class side are read" "grep -q 'StackInterpreter>>at:put:' <<<\"\$out\" && grep -q 'StackInterpreter class>>initialize' <<<\"\$out\""
# Only what the edition loads, as the baseline says: an edition package on its own Pharo, the
# memory map packages from Pharo 11 on.
mkdir -p "$dir/repo/Polyphemus-Edition-Pharo10.package/StackInterpreter.extension/instance" "$dir/repo/Polyphemus-VMMaker-MemoryMap.package/StackInterpreter.extension/instance"
cp "$dir/repo/Polyphemus-Memory.package/StackInterpreter.extension/instance/at.put..st" "$dir/repo/Polyphemus-Edition-Pharo10.package/StackInterpreter.extension/instance/"
cp "$dir/repo/Polyphemus-Memory.package/StackInterpreter.extension/instance/at.put..st" "$dir/repo/Polyphemus-VMMaker-MemoryMap.package/StackInterpreter.extension/instance/"
out=$(python3 "$HERE/vmmaker-replaced.py" "$dir/vm" "$dir/repo" 13 2>&1)
check "another edition's package is not loaded" "! grep -q 'Edition-Pharo10' <<<\"\$out\" && grep -q 'VMMaker-MemoryMap StackInterpreter>>at:put:' <<<\"\$out\""
out=$(python3 "$HERE/vmmaker-replaced.py" "$dir/vm" "$dir/repo" 10 2>&1)
check "nor the memory map's on Pharo 10" "grep -q 'Edition-Pharo10 StackInterpreter>>at:put:' <<<\"\$out\" && ! grep -q 'MemoryMap' <<<\"\$out\""
rm -rf "$dir"
echo "== vmmaker-replaced-test: $failures failing"
[ "$failures" = 0 ]
