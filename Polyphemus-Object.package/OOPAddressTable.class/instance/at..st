accessing
at: anAddress

	^ (self rangeHolding: anAddress) ifNotNil: [ :range |
		  (slots at: range) at: anAddress - (starts at: range) >> 3 + 1 ]
