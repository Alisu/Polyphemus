reading
wordAt: anAddress

	"The word the memory holds there; an address it does not hold is refused by name."

	^ (raw space unsignedAt: anAddress size: memory wordSize) ifNil: [ self refuseTheAddress: anAddress ]
