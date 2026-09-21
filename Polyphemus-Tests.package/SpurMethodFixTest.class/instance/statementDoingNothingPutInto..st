helpers
statementDoingNothingPutInto: aSource

	"A statement that changes nothing and names no literal of its own: an inlined selector
	like ifTrue: would be one, and would move the rest of the frame along with it."

	^ self statementPutInto: aSource source: '1 + 1. '
