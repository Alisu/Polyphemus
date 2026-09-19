accessing
boundsOf: aName

	"A SpurNewSpaceSpace (eden, pastSpace, futureSpace): its start -> its limit."

	| address |
	address := self addressOf: aName.
	^ (memory unsignedAt: address size: 8) -> (memory unsignedAt: address + 8 size: 8)
