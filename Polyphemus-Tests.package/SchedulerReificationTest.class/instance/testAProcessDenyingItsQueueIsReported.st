tests
testAProcessDenyingItsQueueIsReported

	"The queue holds it, the process says it is in none: the two must be reconciled
	by hand, so say so."

	self withRunningProcessQueuedDo: [ :list :process |
		process
			slotAt: reifiedMemory processMyListSlot
			put: reifiedMemory reifiedNilObject.

		self assert: (reifiedMemory processInconsistencies
				 includes: process -> #notInTheQueueItClaims) ]
