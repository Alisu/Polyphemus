literals
valueFor: aValue

	"The literals that are values rather than objects of their own, or are immediate here."

	aValue isNil ifTrue: [ ^ self nilOop ].
	aValue == true ifTrue: [ ^ self trueOop ].
	aValue == false ifTrue: [ ^ self falseOop ].
	aValue isCharacter ifTrue: [ ^ self characterOop: aValue asInteger ].
	aValue isFloat ifTrue: [ ^ self floatOop: aValue ].
	aValue isInteger ifFalse: [
		^ self error: 'this image would have to be given ' , aValue class name ].
	^ (self isSmallInteger: aValue)
		  ifTrue: [ self smallIntegerOop: aValue ]
		  ifFalse: [ self largeIntegerFor: aValue ]
