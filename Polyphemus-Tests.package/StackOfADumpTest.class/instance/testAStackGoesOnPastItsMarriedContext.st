tests
testAStackGoesOnPastItsMarriedContext

	"On the real core most stacks stop at a context married to a frame. Following the frames
	of its page shows 46 activations that were hidden behind it."

	| contexts activations |
	contexts := 0.
	activations := 0.
	memory allReifiedProcesses do: [ :each |
		contexts := contexts + (memory contextsOfProcess: each) size.
		activations := activations + (memory activationsOfProcess: each) size ].

	self assert: activations >= (contexts + 46)
