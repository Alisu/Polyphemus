tests
testAQueueEndingSomewhereElseIsReported

	"lastLink has to be the last process of the chain."

	self withRunningProcessQueuedDo: [ :list :process |
		list
			slotAt: reifiedMemory listLastLinkSlot
			put: reifiedMemory reifiedNilObject.

		self assert: (reifiedMemory processInconsistencies
				 includes: list -> #queueEndsElsewhere) ]
