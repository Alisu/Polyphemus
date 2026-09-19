tests
testTheSpecialObjectsFoundByShapeAreTheOnesTheHeaderNames

	| file |
	file := self open: PharoImageAccessor pathToPharo10.

	self assert: (SpurRawHeap on: file) specialObjectsOop equals: file specialObjectsOop
