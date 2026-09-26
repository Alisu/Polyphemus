updating
snapshotMemory

	"A slot per eight bytes of new space and of old space, and none for what lies between: VM 10
	(and VMMaker v10.0.5) lay them gigabytes apart."

	self forgetWhatWasRead.
	objectsArray := OOPAddressTable covering: {
			                (memory newSpaceStart -> memory newSpaceLimit).
			                (memory oldSpaceStart -> memory endOfMemory) }.
	self initializeObjectsFromMemory
