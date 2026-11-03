tests
testDebugWithNoProcessSelectedOpensNothing

	browser selectProcess: nil.
	self assert: browser debugSelectedProcess isNil
