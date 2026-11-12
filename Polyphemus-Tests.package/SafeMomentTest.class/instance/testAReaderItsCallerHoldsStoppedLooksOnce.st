tests
testAReaderItsCallerHoldsStoppedLooksOnce

	"Held stopped by its caller, it is as it was at every look: one look, and no wait."

	| stops |
	stops := 0.
	memory stop.
	self
		should: [
			memory
				whileStoppedUnless: [ :variables |
					stops := stops + 1.
					'collecting garbage' ]
				do: [ self fail ] ]
		raise: SpurCannotRead.
	self assert: stops equals: 1.
	self assert: memory isStopped
