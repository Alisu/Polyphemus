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
			self count: index bytes: (scanner bytesOfObjectAt: address) ].
		address := scanner objectAfter: address ]
