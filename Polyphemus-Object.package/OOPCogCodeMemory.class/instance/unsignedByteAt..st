memory protocol
unsignedByteAt: anAddress

	^ (self isInCodeZone: anAddress)
		  ifTrue: [ raw space unsignedAt: anAddress size: 1 ]
		  ifFalse: [ objectMemory unsignedByteAt: anAddress ]
