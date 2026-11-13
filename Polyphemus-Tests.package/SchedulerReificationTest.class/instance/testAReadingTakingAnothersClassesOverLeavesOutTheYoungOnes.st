tests
testAReadingTakingAnothersClassesOverLeavesOutTheYoungOnes

	"#189: a class still in new space moves at the next scavenge. Its wrapper, taken over at the
	address it had, would answer for whatever lies there by then. One in old space stays."

	| old young other |
	old := reifiedMemory reifiedActiveProcess oopClass.
	young := YoungClassDouble at: old oopClass address.
	reifiedMemory objectAt: old address put: old; objectAt: young address put: young.
	other := reifiedMemory sharingClassesOn: memory.
	self assert: (other objectAt: old address) notNil description: 'a class in old space was not taken over'.
	self assert: (other objectAt: young address) isNil description: 'a class in new space was taken over where it was'
