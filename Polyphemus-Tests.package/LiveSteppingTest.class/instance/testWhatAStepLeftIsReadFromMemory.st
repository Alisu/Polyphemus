tests
testWhatAStepLeftIsReadFromMemory

	"After a step, reading the process from outside finds the context the image says it is in:
	the debugger here can show the step without asking for the stack."

	self withTheRunawayHeldDo: [ :held :reader |
		| dumped top |
		held stepOver.
		reader whileStopped: [
			dumped := SpurDumpedMemory on: reader.
			dumped raw bytes ].
		top := held topContextIn: (dumped reifyEverything: dumped reifiedMemory).
		self assert: top selector asString equals: held selector.
		self assert: top pc equals: held pc ]
