injecting
inject

	"In one stop: refused if something already waits on the interrupt semaphore; otherwise the
	watcher's method, a context for it and a process holding it, queued there. Answers the
	process's address."

	^ reader whileStopped: [
		  | semaphore process |
		  reading := (SpurDumpedMemory on: reader) reifiedMemory.
		  installer := SpurMethodInstall on: reading into: (SpurWritableProcess on: reader).
		  semaphore := (reading reifiedSpecialObjectArray reifiedSlotAt: 31) address.
		  (self slot: 'firstLink' of: semaphore in: 'Semaphore') = installer nilOop ifFalse: [
			  ^ self error: 'something already waits on the interrupt semaphore' ].
		  process := self processFor: self context waitingOn: semaphore.
		  self slot: 'firstLink' of: semaphore in: 'Semaphore' put: process.
		  self slot: 'lastLink' of: semaphore in: 'Semaphore' put: process.
		  installer memory remember: semaphore.
		  process ]
