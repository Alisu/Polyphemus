tests
testAMethodOneOfWhoseLiteralsPointsNowhereListsNoBlocksAndItsBlockFrameStillAnswers

	| block method |
	block := (reifiedMemory contextsOfProcess:
		          (DamagedPharoImageResource process: 'DelaySemaphoreScheduler>>suspendAtTimingPriority' in: reifiedMemory))
		         detect: [ :each | each isBlockContext ].
	method := block homeMethod.

	self should: [ method literalAt: 1 ] raise: NotInTheReading.
	self assert: method allCompiledBlocks isEmpty.
	self assert: (reifiedMemory highlightRangeOf: block active: false) isEmpty.
	self assert: (reifiedMemory tempNamesOf: block) isEmpty.
	self assert: (reifiedMemory descriptionOfContext: block) isString
