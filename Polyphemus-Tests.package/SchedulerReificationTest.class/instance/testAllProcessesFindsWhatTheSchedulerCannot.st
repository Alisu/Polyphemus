tests
testAllProcessesFindsWhatTheSchedulerCannot

	"Walking the scheduler misses the running process, a suspended one, and anything
	waiting on a semaphore. Scanning the heap for instances of the process class finds
	them all: here that is the single running process."

	| all |
	all := reifiedMemory allReifiedProcesses.

	self assert: all size equals: 1.
	self assert: (all anySatisfy: [ :each | each = reifiedMemory reifiedActiveProcess ]).
	self assert: reifiedMemory runnableProcesses isEmpty
