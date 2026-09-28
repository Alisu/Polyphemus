tests
testPharosDebuggerOpensOnTheDeepestStack

	"StDebugger wants its session to carry an exception, and ours carried none: the debugger
	could not be built at all (#41). Built here without a window."

	| memory debugger |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	debugger := StDebugger on: (Polyphemus sessionOnDeepestProcessIn: memory).
	self
		assert: (PolyphemusTestCase actionModelOf: debugger) topContext
		equals: debugger session interruptedContext
