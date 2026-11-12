tests
testAnImageNeverOutsideACollectionIsRefusedSayingHowOftenItLooked

	"A second of looking, twenty milliseconds apart: well past five stops even where a wait of
	twenty lasts thirty (Windows)."

	| stops |
	stops := 0.
	memory safeMomentWait: 1 second.
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
