building the fixture
corruptedImagePath

	"A copy of the image file with bytes damaged by something other than the reader, never
	repaired -- unlike damage injected through our own API and undone in an ensure:."

	| clean corrupted |
	clean := PharoImageAccessor pathToPharo10 asFileReference.
	corrupted := clean parent / 'cleanP10-blanked-context.image'.
	corrupted exists ifFalse: [ self buildBlankedCopyFrom: clean to: corrupted ].
	^ corrupted fullName
