editing
store: aValue inSlot: anIndex ofObjectShown: aReifiedObject

	"Set one slot, counting from one as an inspector does, of an object the reading shows."

	^ memory
		  storePointer: anIndex - 1
		  ofObject: (self addressOf: aReifiedObject)
		  withValue: (self wordFor: aValue)
