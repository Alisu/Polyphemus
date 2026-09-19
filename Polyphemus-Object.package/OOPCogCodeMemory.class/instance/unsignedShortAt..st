memory protocol
unsignedShortAt: anAddress

	^ (self isInCodeZone: anAddress)
		  ifTrue: [ raw space unsignedAt: anAddress size: 2 ]
		  ifFalse: [ objectMemory unsignedShortAt: anAddress ]
