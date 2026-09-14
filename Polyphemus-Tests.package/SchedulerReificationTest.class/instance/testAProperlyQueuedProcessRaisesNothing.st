tests
testAProperlyQueuedProcessRaisesNothing

	"Build a queue the way the VM would and nothing else is reported. Candle holds a
	single process, so the one we queue is also the running one, and a running process
	sitting in a queue is itself reported: that lone complaint is what we expect here."

	self withRunningProcessQueuedDo: [ :list :process |
		self assert: (reifiedMemory processesInList: list) asArray equals: { process }.
		self
			assert: reifiedMemory processInconsistencies asArray
			equals: { process -> #activeProcessIsQueued } ]
