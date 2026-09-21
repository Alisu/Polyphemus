editing
store: aValue inSlot: anIndex ofObjectShown: aReifiedObject

	"Set one slot, counting from one, of an object the reading shows."

	^ self
		  storePointer: anIndex
		  ofObject: (self addressOf: aReifiedObject)
		  value: (self wordFor: aValue)
