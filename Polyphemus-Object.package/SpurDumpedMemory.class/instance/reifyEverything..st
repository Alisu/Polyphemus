reifying
reifyEverything: aReifiedMemory

	"Reify every object of old space, and of new space found by shape, into aReifiedMemory,
	then rebuild its compressed view."

	self memory allOldSpaceObjectsDo: [ :oop | aReifiedMemory reifyOop: oop ].
	raw youngObjectsDo: [ :oop | aReifiedMemory reifyOop: oop ].
	aReifiedMemory createCompressedVersion.
	^ aReifiedMemory
