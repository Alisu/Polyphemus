making
processFor: aContext waitingOn: aSemaphore

	"A process as [ ] newProcess makes one -- not terminating, everything else nil -- at the
	watcher's priority, named, and in the semaphore's list."

	| process |
	process := self new: 'Process' extra: 0 format: 1.
	self slot: 'suspendedContext' of: process in: 'Process' put: aContext.
	self slot: 'priority' of: process in: 'Process' put: (installer memory smallIntegerOop: 70).
	self slot: 'myList' of: process in: 'Process' put: aSemaphore.
	self slot: 'name' of: process in: 'Process' put: (installer stringFor: 'Polyphemus watcher').
	self slot: 'terminating' of: process in: 'Process' put: installer falseOop.
	^ process
