memory protocol
unsignedLong64At: anAddress

	^ (self isInCodeZone: anAddress)
		  ifTrue: [ raw space unsignedAt: anAddress size: 8 ]
		  ifFalse: [ objectMemory unsignedLong64At: anAddress ]
