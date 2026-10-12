tools
describe: anObject

	"Short enough for an agent to read many of."

	| text |
	text := anObject printString.
	^ text size > 120
		  ifTrue: [ (text first: 117) , '...' ]
		  ifFalse: [ text ]
