tests
testEdenLiesFromTheSurvivorSpacesToTheEndOfNewSpace

	"VMMaker lays the two survivor spaces out before eden, which they swap at each scavenge,
	and eden ends where new space does: what a VM naming no eden (macOS) is read by (#82)."

	| eden past future newSpaceEnd |
	eden := variables boundsOf: 'eden'.
	past := variables boundsOf: 'pastSpace'.
	future := variables boundsOf: 'futureSpace'.
	newSpaceEnd := [ variables at: 'newSpaceEnd' ] on: SpurCannotRead do: [ :e | variables at: 'newSpaceLimit' ].

	self assert: (past value max: future value) equals: eden key.
	self assert: newSpaceEnd equals: eden value.
	self assert: variables edenBounds equals: eden
