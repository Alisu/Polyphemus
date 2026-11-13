tests
testItMakesNoObjectWhileItsVMCollects

	"#167: a scavenge stores pastSpaceStart from where its copying ended: an object made there
	meanwhile is written over, or left beyond it."

	process storeWord: 1 at: (memory variables addressOf: 'gcPhaseInProgress').
	self should: [ memory allocateSlots: 3 format: 2 classIndex: 51 ] raise: CannotWriteThere.
	self assert: (memory variables at: 'pastSpaceStart') equals: 16r11100
