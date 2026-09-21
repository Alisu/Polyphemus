literals
arrayFor: anArray inside: anOuterOop

	"An array of the image's own, holding what its elements became."

	| oop |
	oop := self
		       allocateSlots: anArray size
		       format: 2
		       classIndex: (reading oopClassNamed: 'Array') oopHash.
	anArray doWithIndex: [ :each :index |
		self slot: index - 1 of: oop put: (self literalFor: each inside: anOuterOop) ].
	^ oop
