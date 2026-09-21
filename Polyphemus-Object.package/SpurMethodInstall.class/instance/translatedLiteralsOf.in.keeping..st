literals
translatedLiteralsOf: aCompilation in: aReifiedClass keeping: aReifiedMethod

	"Every literal as an oop of the image. A method ends with the binding of the class it was
	compiled in, and before it either its selector or the state that carries its pragmas --
	that state is the image's own, kept, since making one is not done yet."

	| count |
	count := aCompilation numLiterals.
	^ (1 to: count) collect: [ :each |
		  each = count
			  ifTrue: [ self bindingOf: aReifiedClass ]
			  ifFalse: [
				  each = (count - 1)
					  ifTrue: [ self selectorOf: aCompilation keeping: aReifiedMethod ]
					  ifFalse: [ self literalFor: (aCompilation literalAt: each) ] ] ]
