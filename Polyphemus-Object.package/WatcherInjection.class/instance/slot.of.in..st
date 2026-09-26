private
slot: aName of: anOop in: aClassName

	^ installer memory
		  fetchPointer: (self indexOf: aName in: aClassName)
		  ofObject: anOop
