taking
take

	"Every live object from nil to the end of old space's objects; free chunks are not counted."

	| address limit |
	address := objectMemory nilObject.
	limit := objectMemory freeOldSpaceStart.
	[ address notNil and: [ address < limit ] ] whileTrue: [
		(scanner isFreeChunkAt: address) ifFalse: [
			| index |
			index := scanner classIndexIn: (scanner headerAt: address).
			counts at: index put: (counts at: index ifAbsent: [ 0 ]) + 1.
			sizes at: index put: (sizes at: index ifAbsent: [ 0 ]) + (scanner bytesOfObjectAt: address) ].
		address := scanner objectAfter: address ]
