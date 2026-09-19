memory protocol
unsignedLongAt: anAddress

	^ (self isInCodeZone: anAddress)
		  ifTrue: [ raw space unsignedAt: anAddress size: 4 ]
		  ifFalse: [ objectMemory unsignedLongAt: anAddress ]
