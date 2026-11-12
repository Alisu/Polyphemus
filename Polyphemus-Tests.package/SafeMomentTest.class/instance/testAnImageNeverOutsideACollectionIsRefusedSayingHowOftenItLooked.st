tests
testAnImageNeverOutsideACollectionIsRefusedSayingHowOftenItLooked

	| stops |
	stops := 0.
	memory safeMomentWait: 200 milliSeconds.
	self
		should: [
			memory
				whileStoppedUnless: [ :variables |
					stops := stops + 1.
					'collecting garbage (gcPhaseInProgress 1)' ]
				do: [ self fail ] ]
		raise: SpurCannotRead
		withExceptionDo: [ :refusal |
			self assert: refusal reason equals: #itWasNeverStoppedAtASafeMoment.
			self assert: (refusal messageText includesSubstring: 'in ' , stops printString , ' stops').
			self assert: (refusal messageText includesSubstring: 'gcPhaseInProgress 1') ].
	self assert: stops > 5.
	self deny: memory isStopped
