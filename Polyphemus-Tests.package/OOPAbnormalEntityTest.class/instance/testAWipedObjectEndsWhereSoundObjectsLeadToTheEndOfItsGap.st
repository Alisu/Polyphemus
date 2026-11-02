tests
testAWipedObjectEndsWhereSoundObjectsLeadToTheEndOfItsGap

	"Objects read from nothing else fall into the same gap as the wiped object: it ends where a run
	of sound objects begins that ends with the gap (#139)."

	| association abnormal |
	association := self associationReachableWithItsSlots: false.
	self wipe: association.
	reifiedMemory := FullyReifiedMemory on: memory.
	abnormal := reifiedMemory objectAt: association.
	self assert: abnormal size > 24.
	self assert: (abnormal guesses anySatisfy: [ :each | each classIndex = self associationClassIndex ]).
	self assert: (abnormal guesses allSatisfy: [ :each | each numSlots = 2 ])
