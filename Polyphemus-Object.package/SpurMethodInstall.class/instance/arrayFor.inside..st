literals
arrayFor: anArray inside: anOuterOop

	"An array of the image's own, holding what its elements became."

	| oop |
	oop := memory
		       allocateSlots: anArray size
		       format: 2
		       classIndex: (reading oopClassNamed: 'Array') oopHash.
	anArray doWithIndex: [ :each :index |
		memory
			storePointer: index - 1
			ofObject: oop
			withValue: (self literalFor: each inside: anOuterOop) ].
	^ oop
