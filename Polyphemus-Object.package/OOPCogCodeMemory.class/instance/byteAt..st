memory protocol
byteAt: anAddress

	^ (self isInCodeZone: anAddress)
		  ifTrue: [ raw space unsignedAt: anAddress size: 1 ]
		  ifFalse: [ objectMemory byteAt: anAddress ]
