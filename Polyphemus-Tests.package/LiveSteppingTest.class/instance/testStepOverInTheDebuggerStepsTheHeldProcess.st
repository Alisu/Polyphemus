tests
testStepOverInTheDebuggerStepsTheHeldProcess

	"What Step Over does when the stack on screen is a held image's: the image steps, and the
	debugger is shown the context memory now holds."

	self withTheRunawayHeldDo: [ :held :reader |
		| session before |
		session := ReifiedDebugSession
			           named: 'Polyphemus'
			           on: nil
			           startedAt: held topContext
			           fixing: nil.
		session stepWith: held.
		before := session interruptedContext selector -> session interruptedContext pc.
		session stepOver: session interruptedContext.
		self deny: session interruptedContext selector -> session interruptedContext pc equals: before.
		self assert: session interruptedContext pc equals: held pc.
		self assert: session interruptedContext selector asString equals: held selector ]
