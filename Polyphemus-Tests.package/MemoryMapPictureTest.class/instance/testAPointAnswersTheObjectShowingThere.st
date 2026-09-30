tests
testAPointAnswersTheObjectShowingThere

	self assert: (picture objectAt: picture mapOrigin + (3 @ 0)) equals: self baseAddress + 16.
	self assert: (picture objectAt: 0 @ 0) isNil
