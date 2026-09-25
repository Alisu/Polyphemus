naming
sourcesNameForPharo: aNumber

	"The name that version's pinned image looks for its sources under, beside itself: its
	build's sha, read from the pin. nil for a version that is not pinned."

	| download sha |
	download := self downloadNameForPharo: aNumber.
	(download includesSubstring: '.sha.') ifFalse: [ ^ nil ].
	sha := (download copyFrom: (download indexOfSubCollection: '.sha.') + 5 to: download size)
		       copyUpTo: $..
	^ 'Pharo' , aNumber printString , '.0-64bit-' , sha , '.sources'
