installing
literalsFor: aCompilation under: aSelectorOop in: aReifiedClass

	"Every literal as an oop of the image. A method ends with its selector and its class's
	binding; before those, only what can be made here -- anything else is in the image and
	finding it is not done yet (#25)."

	| count |
	count := aCompilation numLiterals.
	^ (1 to: count) collect: [ :each |
		  each = count
			  ifTrue: [ self bindingOf: aReifiedClass ]
			  ifFalse: [
				  each = (count - 1)
					  ifTrue: [ aSelectorOop ]
					  ifFalse: [ self immediateFor: (aCompilation literalAt: each) ] ] ]
