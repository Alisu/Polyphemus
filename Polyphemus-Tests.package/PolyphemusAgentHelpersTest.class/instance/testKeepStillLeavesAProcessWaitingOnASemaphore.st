tests
testKeepStillLeavesAProcessWaitingOnASemaphore

	"Taken off its semaphore, it would lose its wait (#103)."

	process := [ Semaphore new wait ] newProcess.
	process resume.
	Processor yield.
	workspace at: #process put: process.
	(workspace at: #keepStill) value.
	self deny: (workspace includesKey: #suspended)
