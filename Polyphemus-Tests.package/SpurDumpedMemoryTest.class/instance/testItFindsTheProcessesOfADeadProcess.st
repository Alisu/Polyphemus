tests
testItFindsTheProcessesOfADeadProcess

	"A dead VM's processes are read with their states, exactly one #active, found in new
	space."

	| reified processes states |
	reified := self reified.

	processes := reified allReifiedProcesses.
	self assert: processes size > 1.
	self assert: (processes anySatisfy: [ :each |
			 each address = reified reifiedActiveProcess address ]).

	states := reified processStates.
	self assert: (states values allSatisfy: [ :state |
			 #( #active #runnable #waiting #suspended ) includes: state ]).
	self
		assert: (states values count: [ :state | state = #active ])
		equals: 1
