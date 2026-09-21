installing
immediateFor: aValue

	"A literal that can be made here rather than found: a SmallInteger or a Character."

	aValue isInteger ifTrue: [ ^ memory integerObjectOf: aValue ].
	aValue isCharacter ifTrue: [ ^ memory characterObjectOf: aValue asInteger ].
	^ self error: 'this image would have to already hold ' , aValue printString
