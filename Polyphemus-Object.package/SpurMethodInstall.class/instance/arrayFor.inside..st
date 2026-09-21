literals
arrayFor: anArray inside: anOuterOop

	"An array of the image's own, holding what its elements became."

	| oop |
	oop := memory
		       allocateSlotsInOldSpace: anArray size
		       format: 2
		       classIndex: (reading oopClassNamed: 'Array') oopClassIndex.
	anArray doWithIndex: [ :each :index |
		memory
			storePointerUnchecked: index - 1
			ofObject: oop
			withValue: (self literalFor: each inside: anOuterOop) ].
	^ oop
