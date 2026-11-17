accessing
at: anAddress

	"Nothing at a word that is not aligned: no object starts there, and its slot is another's (#194)."

	(anAddress bitAnd: 7) = 0 ifFalse: [ ^ nil ].
	^ (self rangeHolding: anAddress) ifNotNil: [ :range |
		  (slots at: range) at: anAddress - (starts at: range) >> 3 + 1 ]
