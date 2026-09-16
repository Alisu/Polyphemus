young objects
youngSpaceStart

	"Where the objects in new space begin, found by shape.

	The VM knows this from its own variables; a dump does not carry them, and the geometry
	`#setUpNewSpaceOf:` gives the memory manager is our arithmetic rather than the VM's, so
	it cannot be trusted to land on the real eden. What can be trusted is that objects walk."

	^ youngStart ifNil: [
		  youngStart := self scanner
			                firstObjectRunFrom: mappingStart
			                upTo: self heapStart
			                atLeast: 50 ]
