tests
testItMapsTheHeapFromNilToWhereOldSpaceIsFree

	self assert: (presenter picture geometryOf: 2) start equals: memory nilObject.
	self assert: (presenter picture geometryOf: 2) end equals: memory freeOldSpaceStart
