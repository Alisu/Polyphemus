tests
testRunnableProcessesAreEmptyWhenNothingIsQueued

	"Walking the scheduler alone finds no process here, which is exactly why stage one
	cannot stop at the scheduler: the running process is in no list at all."

	self assert: reifiedMemory runnableProcesses isEmpty
