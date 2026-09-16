tests
testItFindsTheProcessesOfADeadProcess

	"The whole point of stage two. The processes of a virtual machine that is not running
	any more, with the states stage one works out, read out of its core file.

	The running process is not among them: it lives in new space, which is not enumerated."

	| reified processes |
	reified := dumped reifyEverything: dumped reifiedMemory.

	self assert: reified reifiedActiveProcess oopClass name equals: 'Process'.
	processes := reified allReifiedProcesses.
	self assert: processes size > 1.
	self assert: (reified processStates values allSatisfy: [ :state |
			 #( #active #runnable #waiting #suspended ) includes: state ])
