accessing
at: anAddress put: anObject

	(anAddress bitAnd: 7) = 0 ifFalse: [
		^ NotInTheReading signal: anAddress printStringHex , ' is not aligned on eight bytes: no object starts there' ].
	(self holds: anAddress) ifFalse: [
		^ NotInTheReading signal: anAddress printStringHex , ' is in none of the spaces read' ].
	anObject ifNil: [ objects removeKey: anAddress ifAbsent: [  ]. ^ nil ].
	^ objects at: anAddress put: anObject
