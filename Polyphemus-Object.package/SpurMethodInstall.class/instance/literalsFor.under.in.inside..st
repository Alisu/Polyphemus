installing
literalsFor: aCompilation under: aSelectorOop in: aReifiedClass inside: anOop

	"Every literal as an oop of the image. A method ends with its selector and the binding of
	the class it was compiled in; the rest are found there or made there, blocks among them
	belonging to the method being made."

	| count |
	count := aCompilation numLiterals.
	^ (1 to: count) collect: [ :each |
		  each = count
			  ifTrue: [ self bindingOf: aReifiedClass ]
			  ifFalse: [
				  each = (count - 1)
					  ifTrue: [ aSelectorOop ]
					  ifFalse: [ self literalFor: (aCompilation literalAt: each) inside: anOop ] ] ]
