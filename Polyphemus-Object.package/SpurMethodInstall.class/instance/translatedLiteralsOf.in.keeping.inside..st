literals
translatedLiteralsOf: aCompilation in: aReifiedClass keeping: aReifiedMethod inside: anOop

	"Every literal as an oop of the image. A method ends with the binding of the class it was
	compiled in, and before it either its selector or the state that carries its pragmas; a
	block among them belongs to the method being made, which is why it is made first."

	| count |
	count := aCompilation numLiterals.
	^ (1 to: count) collect: [ :each |
		  each = count
			  ifTrue: [ self bindingOf: aReifiedClass ]
			  ifFalse: [
				  each = (count - 1)
					  ifTrue: [ self selectorOf: aCompilation keeping: aReifiedMethod ]
					  ifFalse: [ self literalFor: (aCompilation literalAt: each) inside: anOop ] ] ]
