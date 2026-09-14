tests
testHeapScanFindsProcessesTheSchedulerDoesNot

	"The point of stage one: a real image keeps processes the scheduler cannot reach,
	waiting on semaphores or suspended outright. Walking the queues alone loses them."

	| all runnable |
	all := reifiedMemory allReifiedProcesses.
	runnable := reifiedMemory runnableProcesses.

	self assert: runnable size < all size.
	runnable do: [ :each | self assert: (all includes: each) ]
