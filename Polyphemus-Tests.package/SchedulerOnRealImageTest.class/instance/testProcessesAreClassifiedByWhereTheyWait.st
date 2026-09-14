tests
testProcessesAreClassifiedByWhereTheyWait

	"A real image has processes in three different places at once: queued in the
	scheduler, parked in a semaphore's own queue, and the one that was running."

	| states counted |
	states := reifiedMemory processStates.
	counted := [ :state | (states values select: [ :each | each = state ]) size ].

	self assert: states size equals: reifiedMemory allReifiedProcesses size.
	self assert: (counted value: #active) equals: 1.
	self assert: (counted value: #runnable) equals: reifiedMemory runnableProcesses size.
	self assert: (counted value: #waiting) > 0.
	self assert: (states values allSatisfy: [ :each |
			 #( #active #runnable #waiting #suspended ) includes: each ])
