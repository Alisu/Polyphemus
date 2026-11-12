frames
oldSpaceStretches

	"Old space's own mappings, start -> limit: what else the process mapped between two segments
	far apart is not its heap (#185). The mapping whole when they do not make it up."

	| first stretches |
	first := (space loadableSegments ifNil: [ #(  ) ])
		         detect: [ :each | each address = mappingStart and: [ each sizeInFile > 0 ] ]
		         ifNone: [ ^ { (mappingStart -> mappingLimit) } ].
	stretches := self class stretchesFrom: first in: space endingBy: mappingLimit.
	^ stretches last value = mappingLimit
		  ifTrue: [ stretches ]
		  ifFalse: [ { (mappingStart -> mappingLimit) } ]
