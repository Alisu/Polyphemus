literals
blockFor: aBlock inside: anOuterOop

	"A compiled block of the image's own: the same shape as a method, and last among its
	literals the code it belongs to -- which is why what holds a block is made before it."

	| oop |
	oop := self allocateCodeFor: aBlock ofClassNamed: 'CompiledBlock'.
	memory
		storePointerUnchecked: 0
		ofObject: oop
		withValue: (memory integerObjectOf: aBlock header).
	1 to: aBlock numLiterals do: [ :each |
		memory
			storePointerUnchecked: each
			ofObject: oop
			withValue: (each = aBlock numLiterals
					 ifTrue: [ anOuterOop ]
					 ifFalse: [ self literalFor: (aBlock literalAt: each) inside: oop ]) ].
	aBlock initialPC to: aBlock size do: [ :each |
		memory
			byteAt: oop + 8 + (aBlock numLiterals + 1 * 8) + (each - aBlock initialPC)
			put: (aBlock at: each) ].
	^ oop
