testing
hasAddress: anAddress

	"Whether this address can be read at all. An address in a region that was only partly
	written answers false: it was there, and the dump does not say what it held."

	^ (self segmentHolding: anAddress) notNil
