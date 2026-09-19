young objects
youngSpaceStart

	"Where new space's objects begin, found by shape: our geometry for the memory manager is not
	the VM's, so only objects that walk can be trusted."

	^ youngStart ifNil: [
		  youngStart := self scanner
			                firstObjectRunFrom: mappingStart
			                upTo: self heapStart
			                atLeast: 50 ]
