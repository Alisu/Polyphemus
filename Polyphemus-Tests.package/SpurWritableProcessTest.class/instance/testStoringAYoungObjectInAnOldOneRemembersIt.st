tests
testStoringAYoungObjectInAnOldOneRemembersIt

	"As the VM's own stores do: the old object may now point at a younger one."

	| old young |
	old := self objectAt: 16r13800 slots: 2.
	young := self objectAt: 16r11200 slots: 1.
	memory storePointer: 1 ofObject: old withValue: young.
	self assert: (memory fetchPointer: 1 ofObject: old) equals: young.
	self assert: (memory variables at: 'rememberedSetSize') equals: 1.
	self assert: (memory wordAt: 16r10100) equals: old
