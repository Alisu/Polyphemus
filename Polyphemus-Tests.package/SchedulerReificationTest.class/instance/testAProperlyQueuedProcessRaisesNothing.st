tests
testAProperlyQueuedProcessRaisesNothing

	"Build a queue the way the VM would and the report must stay silent, otherwise
	the checks below would be proving nothing."

	self withRunningProcessQueuedDo: [ :list :process |
		self assert: (reifiedMemory processesInList: list) asArray equals: { process }.
		self assert: reifiedMemory processInconsistencies isEmpty ]
