tests
testOutsideTheMapThereIsNoAddress

	self assert: (map addressAt: 4 @ 0) isNil.
	self assert: (map addressAt: 1 @ 3) isNil.
	self assert: (map addressAt: 0 @ -1) isNil
