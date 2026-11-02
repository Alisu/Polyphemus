tests
testAReadingOnlyEvaluatesNothing

	"A session on a reading only has no image to run code in: it answers nil, and the debugger falls
	back to the observer (#126)."

	| pid memory session |
	pid := self launchCounter.
	[
	memory := Polyphemus readProcess: pid.
	session := Polyphemus sessionOn: (Polyphemus processNamed: 'counter' in: memory) in: memory.
	self assert: (session evaluate: '3 + 4' in: session interruptedContext) isNil ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
