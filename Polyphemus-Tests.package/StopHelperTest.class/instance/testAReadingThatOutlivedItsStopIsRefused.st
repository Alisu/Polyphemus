tests
testAReadingThatOutlivedItsStopIsRefused

	"#137: the stop ended at its bound, so the process ran under the reading: refused, not answered."

	| reader |
	reader := self aReaderOfTheSleeper.
	reader stopBound: 1 second.
	self
		should: [ reader whileStopped: [ (Delay forSeconds: 3) wait ] ]
		raise: SpurCannotRead
		withExceptionDo: [ :error | self assert: error reason equals: #itRanWhileRead ].
	self deny: self isStopped
