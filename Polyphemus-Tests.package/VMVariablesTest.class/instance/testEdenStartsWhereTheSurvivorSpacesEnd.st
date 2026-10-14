tests
testEdenStartsWhereTheSurvivorSpacesEnd

	"VMMaker lays the two survivor spaces out before eden, which they swap at each scavenge:
	eden starts where the higher one ends. What a VM naming no eden (macOS) is read by (#82)."

	| past future |
	past := variables boundsOf: 'pastSpace'.
	future := variables boundsOf: 'futureSpace'.

	self assert: (past value max: future value) equals: (variables boundsOf: 'eden') key.
	self assert: variables edenStart equals: (variables boundsOf: 'eden') key
