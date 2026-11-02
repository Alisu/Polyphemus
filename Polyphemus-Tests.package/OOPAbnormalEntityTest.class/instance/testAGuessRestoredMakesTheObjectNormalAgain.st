tests
testAGuessRestoredMakesTheObjectNormalAgain

	"Restoring a guess writes the header it says: the memory reads whole again, the object as one
	of that class holding what it held (#139)."

	| association key restored |
	association := self associationReachableWithItsSlots: false.
	key := memory fetchPointer: 0 ofObject: association.
	self wipe: association.
	reifiedMemory := FullyReifiedMemory on: memory.
	(reifiedMemory objectAt: association) restoreAs: ((reifiedMemory objectAt: association) guesses detect: [ :each |
			 each classIndex = self associationClassIndex ]).
	reifiedMemory update.
	restored := reifiedMemory objectAt: association.
	self assert: (reifiedMemory select: [ :each | each isAbnormalOop ]) isEmpty.
	self assert: restored oopClassTag equals: self associationClassIndex.
	self assert: (memory numSlotsOf: association) equals: 2.
	self assert: (memory fetchPointer: 0 ofObject: association) equals: key
