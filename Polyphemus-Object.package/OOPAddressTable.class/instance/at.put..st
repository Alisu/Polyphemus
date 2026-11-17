accessing
at: anAddress put: anObject

	| range |
	(anAddress bitAnd: 7) = 0 ifFalse: [
		^ NotInTheReading signal: anAddress printStringHex , ' is not aligned on eight bytes: no object starts there' ].
	range := (self rangeHolding: anAddress) ifNil: [
		         ^ NotInTheReading signal: anAddress printStringHex , ' is in none of the spaces read' ].
	^ (slots at: range) at: anAddress - (starts at: range) >> 3 + 1 put: anObject
