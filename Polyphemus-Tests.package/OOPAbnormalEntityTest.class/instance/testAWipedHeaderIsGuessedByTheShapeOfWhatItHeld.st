tests
testAWipedHeaderIsGuessedByTheShapeOfWhatItHeld

	"A header wiped to zero says nothing, but the object ends where the next sound one begins and
	its slots hold objects: each class making such an object is a guess (#139)."

	| association guesses |
	association := self associationReachableWithItsSlots: true.
	self wipe: association.
	reifiedMemory := FullyReifiedMemory on: memory.
	guesses := (reifiedMemory objectAt: association) guesses.
	self assert: (guesses allSatisfy: [ :each | each numSlots = 2 ]).
	self assert: (guesses anySatisfy: [ :each |
			 each classIndex = self associationClassIndex and: [ each format = memory nonIndexablePointerFormat ] ]).
	self assert: (guesses anySatisfy: [ :each |
			 each classIndex = self arrayClassIndex and: [ each format = memory arrayFormat ] ])
