objects
fetchPointer: anIndex ofObject: anOop

	"One slot, counting from zero as the machine does. Refused past the last one."

	^ self wordAt: (self addressOfSlot: anIndex of: anOop)
