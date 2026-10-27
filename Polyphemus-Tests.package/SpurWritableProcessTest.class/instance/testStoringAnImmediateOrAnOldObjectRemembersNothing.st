tests
testStoringAnImmediateOrAnOldObjectRemembersNothing

	"16r11201 is a SmallInteger whose bits fall in new space: no object, not young."

	| old |
	old := self objectAt: 16r13800 slots: 2.
	memory storePointer: 0 ofObject: old withValue: (self objectAt: 16r13900 slots: 1).
	memory storePointer: 1 ofObject: old withValue: 16r11201.
	self assert: (memory variables at: 'rememberedSetSize') equals: 0
