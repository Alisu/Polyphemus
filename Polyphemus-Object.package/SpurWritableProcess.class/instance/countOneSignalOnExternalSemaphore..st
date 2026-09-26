signalling
countOneSignalOnExternalSemaphore: anIndex

	"What the watcher holding the image, and our agent between requests, spin on: released by
	it. The process must be stopped."

	self wordAt: (self excessSignalsOfExternalSemaphore: anIndex) put: 1 * 8 + 1
