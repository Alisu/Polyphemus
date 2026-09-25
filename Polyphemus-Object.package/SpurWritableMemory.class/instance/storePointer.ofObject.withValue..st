objects
storePointer: anIndex ofObject: anOop withValue: aWord

	"Set one slot, counting from zero as the machine does. Refused past the last one."

	^ self wordAt: (self addressOfSlot: anIndex of: anOop) put: aWord
