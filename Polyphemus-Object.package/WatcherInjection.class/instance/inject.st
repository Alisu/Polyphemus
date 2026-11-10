injecting
inject

	"In one stop at a safe moment (#91), unless ours already waits there (#124): a semaphore, the
	watcher's method, a context and a process waiting on it, then the semaphore in a free slot of
	the external objects table, last, so a stop cut short leaves garbage (#163). Answers the process."

	directory ensureCreateDirectory.
	^ reader whileStoppedAtASafeMoment: [ :dumped :stopped |
		  | index semaphore process |
		  reading := dumped reifiedMemory.
		  installer := SpurMethodInstall on: reading into: (SpurWritableProcess on: stopped).
		  self watcherAlreadyIn
			  ifNotNil: [ :waiting | waiting ]
			  ifNil: [
				  index := self freeExternalSlot.
				  self class leaveSemaphoreIndex: index in: directory.
				  [
				  semaphore := self new: 'Semaphore' extra: 0 format: 1.
				  self slot: 'excessSignals' of: semaphore in: 'Semaphore' put: (installer memory smallIntegerOop: 0).
				  process := self processFor: (self contextSignalledAt: index) waitingOn: semaphore.
				  self slot: 'firstLink' of: semaphore in: 'Semaphore' put: process.
				  self slot: 'lastLink' of: semaphore in: 'Semaphore' put: process.
				  installer memory storePointer: index - 1 ofObject: self externalObjects withValue: semaphore.
				  installer memory remember: self externalObjects ]
					  ifCurtailed: [ (directory / 'semaphore-index') ensureDelete ].
				  process ] ]
