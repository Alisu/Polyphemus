accessing
at: anAddress put: anObject

	(self holds: anAddress) ifFalse: [
		^ NotInTheReading signal: anAddress printStringHex , ' is in none of the spaces read' ].
	anObject ifNil: [ objects removeKey: anAddress ifAbsent: [  ]. ^ nil ].
	^ objects at: anAddress put: anObject
