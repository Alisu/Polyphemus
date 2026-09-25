tests
testTheFixedMethodStillRuns

	"And it runs: the method is Integer>>digitSubtract: or another of its kind, so a machine
	subtracting large integers in the written image is running what was installed, with the
	literals that were made for it."

	| method source |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	source := self statementPutInto: method getSourceFromFile
		          source: '''polyphemus'' size = 10 ifTrue: [ ]. '.
	self assert: (self fix apply: source to: method) equals: #madeRoomForIt.
	(SpurWritableVMMakerMemory on: reading) writeTo: written.

	self
		assert: (self
				 evaluate: '(1000000000000000000000 - 999999999999999999999) printString , '' '' , (12345678901234567890 - 1) printString'
				 in: written)
		equals: '''1 12345678901234567889'''
