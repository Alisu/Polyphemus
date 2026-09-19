tests
testADamagedObjectDoesNotStopTheImageFromOpening

	"The blanked-context fixture is damaged inside one object. Its structure is intact, so
	it climbs the ladder and opens."

	| path |
	path := PharoImageAccessor pathToImageNamed: 'cleanP10-blanked-context.image'.
	path asFileReference exists ifFalse: [ ^ self skip: 'the blanked-context fixture is not built' ].

	self assert: (SpurRawHeap on: (self open: path)) readability isFullyReadable.
	self assert: (Polyphemus readImageFile: path) allReifiedProcesses notEmpty
