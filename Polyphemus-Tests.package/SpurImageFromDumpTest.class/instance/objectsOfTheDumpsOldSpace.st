helpers
objectsOfTheDumpsOldSpace

	"Counted to where the VM allocates next: the walk of a dump runs on past it, into memory
	that has never held an object."

	| scanner oop count |
	scanner := raw scanner.
	oop := raw heapStart.
	count := 0.
	[ oop notNil and: [ oop < raw liveEnd ] ] whileTrue: [
		(scanner isFreeChunkAt: oop) ifFalse: [ count := count + 1 ].
		oop := scanner objectAfter: oop ].
	^ count
