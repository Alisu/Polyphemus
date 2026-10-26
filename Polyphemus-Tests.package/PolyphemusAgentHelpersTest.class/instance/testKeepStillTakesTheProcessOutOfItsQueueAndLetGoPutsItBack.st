tests
testKeepStillTakesTheProcessOutOfItsQueueAndLetGoPutsItBack

	workspace at: #process put: self runnable.
	(workspace at: #keepStill) value.
	self assert: process isSuspended.
	(workspace at: #letGo) value.
	self deny: process isSuspended.
	self deny: (workspace includesKey: #suspended)
