helpers
holdWithTheInterrupt: aReader

	"Interrupt the image and wait until its watcher says it is holding."

	aReader whileStopped: [
		aReader
			storeWord: 1
			at: ((VMVariables on: aReader) addressOf: 'interruptPending') ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'interrupted') exists ])
		description: 'it never took the interrupt'
