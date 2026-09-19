tests
testItRefusesAStorePastTheEndOfAnObject

	| edit specials |
	edit := SpurImageEdit on: PharoImageAccessor pathToCandle64Bit.
	specials := edit raw specialObjectsOop.

	self
		should: [
			edit
				storePointer: (edit raw scanner slotsAt: specials) + 1
				ofObject: specials
				value: edit nilOop ]
		raise: Error
