tests
testItMakesRoomForAFixThatDoesNotFit

	"And one that is longer is installed as a method of its own, which is what an edit in a
	debugger usually is."

	| method source |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].
	source := method getSourceFromFile.

	self
		assert: (self fix
				 apply: (self statementDoingNothingPutInto: source)
				 to: method)
		equals: #madeRoomForIt
