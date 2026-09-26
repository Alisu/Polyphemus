private
slot: aName of: anOop in: aClassName put: aValue

	^ installer memory
		  storePointer: (self indexOf: aName in: aClassName)
		  ofObject: anOop
		  withValue: aValue
