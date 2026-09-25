literals
valueFor: aValue

	"The literals that are values rather than objects of their own, or are immediate here."

	aValue isNil ifTrue: [ ^ self nilOop ].
	aValue == true ifTrue: [ ^ self trueOop ].
	aValue == false ifTrue: [ ^ self falseOop ].
	aValue isCharacter ifTrue: [ ^ memory characterOop: aValue asInteger ].
	aValue isFloat ifTrue: [ ^ memory floatOop: aValue ].
	aValue isInteger ifFalse: [
		^ self error: 'this image would have to be given ' , aValue class name ].
	^ (memory isSmallInteger: aValue)
		  ifTrue: [ memory smallIntegerOop: aValue ]
		  ifFalse: [ self largeIntegerFor: aValue ]
