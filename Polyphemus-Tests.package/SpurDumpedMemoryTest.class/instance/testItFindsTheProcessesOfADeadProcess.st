tests
testItFindsTheProcessesOfADeadProcess

	"The whole point of stage two. The processes of a virtual machine that is not running any
	more, with the states stage one works out, read out of its core file.

	Including the one that was running. It lives in new space, as the newest objects do, and
	was missing from every answer until new space was walked by shape -- so exactly one
	process being `#active` is the thing worth asserting here: it is the process that was on
	the processor when the dump was taken."

	| reified processes states |
	reified := dumped reifyEverything: dumped reifiedMemory.

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
