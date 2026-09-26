signalling
excessSignalsOfExternalSemaphore: anIndex

	"Where the semaphore at anIndex of the external objects table (special objects 39) counts
	signals nobody took. Found afresh: a young semaphore moves at every scavenge. Stopped."

	| table |
	table := self fetchPointer: 38 ofObject: (self variables at: 'specialObjectsOop').
	^ (self fetchPointer: anIndex - 1 ofObject: table) + 8 + (2 * 8)
