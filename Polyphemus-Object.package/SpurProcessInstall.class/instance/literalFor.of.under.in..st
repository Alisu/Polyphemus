installing
literalFor: anIndex of: aCompilation under: aSelectorOop in: aReifiedClass

	"The last literal is the class's binding and the one before it the selector. Before those,
	only what needs no room of its own: making an object in a running image is one thing, and
	making its literals there is another (#25)."

	| count literal |
	count := aCompilation numLiterals.
	anIndex = count ifTrue: [ ^ self bindingOf: aReifiedClass ].
	anIndex = (count - 1) ifTrue: [ ^ aSelectorOop ].
	literal := aCompilation literalAt: anIndex.
	literal isInteger ifTrue: [ ^ (literal bitShift: 3) + 1 ].
	literal isCharacter ifTrue: [ ^ (literal asInteger bitShift: 3) + 2 ].
	^ self error: 'a live image is only given methods whose literals need no room yet, not '
		  , literal class name
