#!/usr/bin/env bash
# What a newcomer gets: load Polyphemus from GitHub into a clean Pharo 10 and say what arrived.
#
# It builds the image from the pinned clean fixture on purpose. Every image lying about here
# already holds an older Polyphemus, and Metacello keeps what it has rather than fetching --
# a check run in one of those passes while proving nothing.
#
#   bin/check-newcomer.sh [branch] [--group=core] [--tests]
set -euo pipefail

branch="stage2"
run_tests="no"
group=""
for argument in "$@"; do
	case "$argument" in
		--tests) run_tests="yes" ;;
		--group=*) group="${argument#--group=}" ;;
		*) branch="$argument" ;;
	esac
done

repository="$(cd "$(dirname "$0")/.." && pwd)"
root="$(dirname "$repository")"
work="${POLYPHEMUS_NEWCOMER_DIR:-$HOME/newcomer}"

rm -rf "$work"
mkdir -p "$work"
cd "$work"
cp "$repository/resources/cleanP10.image" newcomer.image
cp "$repository/resources/cleanP10.changes" newcomer.changes
ln -sf "$repository/resources/cleanP10.sources" .
cp "$root/pharo" .
ln -sf "$root/pharo-vm" .

load="load"
[ -n "$group" ] && load="load: '$group'"

cat > check.st <<SMALLTALK
| say |
say := [ :label :blk | [ (label , ': ' , blk value printString) traceCr ]
	on: Error do: [ :e | (label , ': ERR ' , e class name , ' ' , e messageText asString) traceCr ] ].
say value: 'loading' value: [
	Metacello new
		baseline: 'Polyphemus';
		repository: 'github://Alisu/Polyphemus:$branch';
		onConflictUseIncoming;
		$load.
	'$branch $group' ].
say value: 'packages' value: [
	((RPackageOrganizer default packages select: [ :p | p name beginsWith: 'Polyphemus' ])
		 collect: [ :p | p name ]) asSortedCollection asArray ].
say value: 'methods loaded in all' value: [
	RPackageOrganizer default packages inject: 0 into: [ :all :p | all + p methods size ] ].
say value: 'VMMaker packages here' value: [
	((RPackageOrganizer default packages select: [ :p |
		  (p name beginsWith: 'VMMaker') or: [ (p name beginsWith: 'Slang') or: [
			  (p name beginsWith: 'Unicorn') or: [ p name beginsWith: 'LLVM' ] ] ] ])
		 collect: [ :p | p name -> p methods size ]) asSortedCollection asArray ].
say value: 'classes missing' value: [
	(#( AbstractReifiedMemory LinuxProcessMemory SpurImageEdit SpurImageFromDump
	    SpurMethodInstall SpurReadability OOPCogLayout VMVariables OOPBuilder )
		 reject: [ :each | Smalltalk includesKey: each ]) asArray ].
Smalltalk exitSuccess
SMALLTALK

echo "== loading $branch ${group:+group $group }into a clean Pharo 10 =="
timeout 1800 ./pharo newcomer.image st check.st 2>&1 | tr -d '\033' \
	| grep -E "^(loading|packages|methods loaded|VMMaker packages|classes missing)" || {
	echo "BROKEN the load said nothing"
	exit 1
}

if [ "$run_tests" = "yes" ]; then
	echo "== running Polyphemus-Tests in it =="
	timeout 3000 ./pharo newcomer.image test "Polyphemus-Tests" 2>&1 | tr -d '\033' | tail -5
fi
