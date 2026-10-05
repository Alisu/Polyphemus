tests
testADamagedObjectDoesNotStopTheImageFromOpening

	"The blanked-context fixture is damaged inside one object. Its structure is intact, so
	it climbs the ladder and opens."

	| path |
	path := BlankedContextImageResource corruptedImagePath.

	self assert: (SpurRawHeap on: (self open: path)) readability isFullyReadable.
	self assert: (Polyphemus readImageFile: path) allReifiedProcesses notEmpty
