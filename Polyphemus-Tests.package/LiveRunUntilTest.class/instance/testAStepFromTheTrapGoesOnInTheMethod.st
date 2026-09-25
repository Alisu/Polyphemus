tests
testAStepFromTheTrapGoesOnInTheMethod

	"The trap's own frames are above the method; a step from where the debugger opened runs
	them out and goes on in the method, as a person would expect."

	self withASessionOn: self launchSpinningTarget do: [ :session |
		| pc |
		session runUntil: 'Integer >> #sqrt'.
		pc := session interruptedContext pc.
		session stepOver: session interruptedContext.
		self assert: session interruptedContext selector asString equals: 'sqrt'.
		self assert: session interruptedContext pc > pc.
		session resume ]
