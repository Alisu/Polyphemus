literals
valueFor: aValue

	"The literals that are values rather than objects of their own, or are immediate here."

	aValue isNil ifTrue: [ ^ memory nilObject ].
	aValue == true ifTrue: [ ^ memory trueObject ].
	aValue == false ifTrue: [ ^ memory falseObject ].
	aValue isCharacter ifTrue: [ ^ memory characterObjectOf: aValue asInteger ].
	aValue isFloat ifTrue: [ ^ memory floatObjectOf: aValue ].
	aValue isInteger ifFalse: [
		^ self error: 'this image would have to be given ' , aValue class name ].
	^ (memory isIntegerValue: aValue)
		  ifTrue: [ memory integerObjectOf: aValue ]
		  ifFalse: [ self largeIntegerFor: aValue ]
