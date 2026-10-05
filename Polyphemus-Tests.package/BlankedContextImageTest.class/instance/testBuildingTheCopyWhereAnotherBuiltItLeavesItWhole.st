tests
testBuildingTheCopyWhereAnotherBuiltItLeavesItWhole

	"Classes run side by side: on a fresh checkout two may both find the copy absent and build
	it, and the second found the first's there (FileExists in CI). Each build leaves the copy
	whole and blanked, and nothing else beside it."

	| clean directory copy |
	clean := PharoImageAccessor pathToPharo10 asFileReference.
	directory := PolyphemusEdition current scratch / 'polyphemus-blanked-test'.
	directory ensureDeleteAll.
	directory ensureCreateDirectory.
	copy := directory / 'blanked.image'.

	BlankedContextImageResource buildBlankedCopyFrom: clean to: copy.
	BlankedContextImageResource buildBlankedCopyFrom: clean to: copy.

	self assert: (directory children collect: [ :each | each basename ]) asArray equals: #( 'blanked.image' ).
	self assert: copy size equals: clean size.
	self assert: (Polyphemus readImageFile: copy fullName) allReifiedProcesses notEmpty.
	directory ensureDeleteAll
