helpers
holdWithTheInterrupt: aReader

	"Signal the watcher's semaphore from outside and wait until it says it is holding."

	aReader whileStopped: [
		(SpurWritableProcess on: aReader) signalExternalSemaphore: self watcherSemaphoreIndex ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'interrupted') exists ])
		description: 'it never took the interrupt'
