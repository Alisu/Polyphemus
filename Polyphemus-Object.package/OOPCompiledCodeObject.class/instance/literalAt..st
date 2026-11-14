accessing-literals
literalAt: anIndex
	"The ultimate is not counted and is the methodClass penultimate is selector"
	anIndex < 1 ifTrue: [ ^ self errorSubscriptBounds: anIndex ].
	anIndex > self numberOfLiterals ifTrue: [ ^ self refuseItsLacking: 'literal' at: anIndex ].
	^ self reifiedSlotAt: anIndex + 1
