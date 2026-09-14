tests
testTheOnlyProcessOfTheCandleImageIsTheRunningOne

	"Classification on the simplest possible population."

	| states |
	states := reifiedMemory processStates.

	self assert: states size equals: 1.
	self
		assert: (states at: reifiedMemory reifiedActiveProcess)
		equals: #active
