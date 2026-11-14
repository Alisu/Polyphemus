reading
byteAt: anAddress

	"The byte the memory holds there; an address it does not hold is refused by name."

	^ (raw space unsignedAt: anAddress size: 1) ifNil: [ self refuseTheAddress: anAddress ]
