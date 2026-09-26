injecting
inject

	"In one stop: refused if a watcher already waits on the semaphore left in that directory;
	otherwise a semaphore registered in a free slot of the external objects table, and the
	watcher's method, a context for it and a process holding it, queued there. Answers the
	process's address."

	^ reader whileStopped: [
		  | index semaphore process |
		  reading := (SpurDumpedMemory on: reader) reifiedMemory.
		  installer := SpurMethodInstall on: reading into: (SpurWritableProcess on: reader).
		  self refuseAWatchedImage.
		  index := self freeExternalSlot.
		  semaphore := self new: 'Semaphore' extra: 0 format: 1.
		  self slot: 'excessSignals' of: semaphore in: 'Semaphore' put: (installer memory smallIntegerOop: 0).
		  installer memory storePointer: index - 1 ofObject: self externalObjects withValue: semaphore.
		  installer memory remember: self externalObjects.
		  process := self processFor: (self contextSignalledAt: index) waitingOn: semaphore.
		  self slot: 'firstLink' of: semaphore in: 'Semaphore' put: process.
		  self slot: 'lastLink' of: semaphore in: 'Semaphore' put: process.
		  (directory / 'semaphore-index')
			  ensureDelete;
			  writeStreamDo: [ :stream | stream print: index ].
		  process ]
