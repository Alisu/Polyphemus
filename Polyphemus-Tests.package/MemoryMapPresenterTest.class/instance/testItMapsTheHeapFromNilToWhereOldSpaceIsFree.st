tests
testItMapsTheHeapFromNilToWhereOldSpaceIsFree

	self assert: presenter picture geometry start equals: memory nilObject.
	self assert: presenter picture geometry end equals: memory freeOldSpaceStart
