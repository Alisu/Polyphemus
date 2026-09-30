tests
testAClickOutsideTheMapHandsNothingOn

	presenter chooseAt: 0 @ 0.

	self assert: chosen isNil
