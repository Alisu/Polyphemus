tests
testItCountsSlotsAsTheScannerDoes

	| specials |
	specials := memory raw specialObjectsOop.
	self assert: (memory numSlotsOf: specials) equals: (memory raw scanner slotsAt: specials)
