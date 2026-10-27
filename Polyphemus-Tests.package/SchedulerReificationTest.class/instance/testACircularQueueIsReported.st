tests
testACircularQueueIsReported

	"A chain that comes back on itself would hang a naive walk; the report names it
	and the walk still terminates."

	self withRunningProcessQueuedDo: [ :list :process |
		process slotAt: reifiedMemory processes processNextLinkSlot put: process.

		self assert: (reifiedMemory processInconsistencies
				 includes: list -> #queueIsCircular).
		self assert: (reifiedMemory processes processesInList: list) size equals: 1 ]
