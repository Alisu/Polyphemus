tests
testVMMakersMemoryHoldsNewSpaceAsTheDumpedVMHadIt

	"The survivors and eden where the VM had them, filled as far as it had filled them, so
	VMMaker's own walk of new space finds the objects the raw heap finds (#68). Before, new
	space was declared empty: its fill marks are VM variables, read only later."

	| memory ranges walked raw |
	memory := dumped interpreter objectMemory.
	ranges := dumped raw liveYoungRanges.
	ranges ifNil: [ ^ self skip: 'this dump does not say where its new space was' ].

	self assert: memory scavenger pastSpace start -> memory pastSpaceStart equals: ranges first.
	self assert: memory scavenger eden start -> memory freeStart equals: ranges last.
	walked := 0.
	memory allNewSpaceEntitiesDo: [ :each | (memory isFreeObject: each) ifFalse: [ walked := walked + 1 ] ].
	raw := 0.
	dumped raw youngObjectsDo: [ :each | raw := raw + 1 ].
	self assert: walked equals: raw
