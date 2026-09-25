tests
testItRefusesASlotPastTheLastOne

	| specials last |
	specials := memory raw specialObjectsOop.
	last := (memory numSlotsOf: specials) - 1.
	self
		shouldnt: [ memory fetchPointer: last ofObject: specials ] raise: Error;
		should: [
			memory
				storePointer: last + 1
				ofObject: specials
				withValue: (memory smallIntegerOop: 0) ]
		raise: Error
