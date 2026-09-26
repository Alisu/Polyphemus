accessing
at: anAddress put: anObject

	| range |
	range := (self rangeHolding: anAddress) ifNil: [
		         ^ self error: anAddress printStringHex , ' is in none of the spaces read' ].
	^ (slots at: range) at: anAddress - (starts at: range) >> 3 + 1 put: anObject
