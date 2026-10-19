tests
testPharosDebuggerOpensOnAProcessChosenByName

	| debugger |
	[
	debugger := Polyphemus debugProcessNamed: 'Morphic UI Process' in: memory.
	self
		assert: debugger session interruptedContext address
		equals: (memory contextsOfProcess: (Polyphemus processNamed: 'Morphic UI Process' in: memory)) first address.
	PolyphemusTestCase drawEachFrameOf: debugger ] ensure: [
		debugger ifNotNil: [ debugger window ifNotNil: [ :window | window close ] ] ]
