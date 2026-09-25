helpers
endOfTheLastLiveObjectIn: aRawHeap

	"Where the last object that is not free space ends, found by walking every object."

	| scanner current limit last |
	scanner := aRawHeap scanner.
	current := aRawHeap heapStart.
	limit := aRawHeap mappingLimit.
	[ current notNil and: [ current < limit ] ] whileTrue: [
		(scanner isFreeChunkAt: current) ifFalse: [
			last := current + (scanner bytesOfObjectAt: current) ].
		current := scanner objectAfter: current ].
	^ last
