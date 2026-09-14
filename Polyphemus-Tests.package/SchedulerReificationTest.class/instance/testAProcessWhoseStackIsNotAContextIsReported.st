tests
testAProcessWhoseStackIsNotAContextIsReported

	"suspendedContext is where a process' whole stack hangs in a snapshot. If it
	points at something that is not a context, the stack is gone."

	self withRunningProcessQueuedDo: [ :list :process |
		process
			slotAt: reifiedMemory processSuspendedContextSlot
			put: reifiedMemory reifiedScheduler.

		self assert: (reifiedMemory processInconsistencies
				 includes: process -> #suspendedContextIsNotAContext) ]
