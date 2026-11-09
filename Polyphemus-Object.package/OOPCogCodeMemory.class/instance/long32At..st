memory protocol
long32At: anAddress

	"The 32 bits there, unsigned, as Cog's back ends read a call or a literal in machine code (#95)."

	^ (self isInCodeZone: anAddress)
		  ifTrue: [ raw space unsignedAt: anAddress size: 4 ]
		  ifFalse: [ objectMemory long32At: anAddress ]
