tests
testWhatIsIntactStillReads

	"One broken slot is one broken slot. Every other process still has to say where it
	stands and show its stack, or a single bad word would cost the whole image."

	| states withStacks |
	states := reifiedMemory processStates.
	self assert: states size equals: reifiedMemory allReifiedProcesses size.
	self assert: (states values includes: #waiting).

	withStacks := reifiedMemory allReifiedProcesses count: [ :process |
		              ([ (reifiedMemory contextsOfProcess: process) notEmpty ]
			               on: Error
			               do: [ :e | false ]) ].
	self assert: withStacks >= (reifiedMemory allReifiedProcesses size - 1)
