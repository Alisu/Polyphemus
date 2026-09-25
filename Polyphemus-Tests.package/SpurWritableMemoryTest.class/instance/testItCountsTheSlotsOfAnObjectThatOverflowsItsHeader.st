tests
testItCountsTheSlotsOfAnObjectThatOverflowsItsHeader

	| big |
	big := self anObjectWithMoreThan254Slots.
	big ifNil: [ ^ self fail: 'no object of candle''s first twenty has more than 254 slots' ].
	self assert: (memory numSlotsOf: big) equals: (memory raw scanner slotsAt: big)
