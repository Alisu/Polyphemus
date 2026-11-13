tests
testKeepStillLeavesAProcessWaitingOnASemaphore

	"Taken off its semaphore, it would lose its wait (#103)."

	workspace at: #process put: self waiting.
	(workspace at: #keepStill) value.
	self deny: (workspace includesKey: #suspended)
