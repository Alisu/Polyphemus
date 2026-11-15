running
setUp

	"Found before anything is overwritten: a context of the process that was snapshotting, the
	method it runs, and an object of another stack, whose class is made unreadable for one kind
	of damage."

	| stackOfSize |
	super setUp.
	stackOfSize := [ :size |
	               reifiedMemory allReifiedProcesses detect: [ :each |
		               (reifiedMemory contextsOfProcess: each) size = size ] ].
	process := stackOfSize value: 19.
	context := (reifiedMemory contextsOfProcess: process) at: 9.
	subject := context compiledCode.
	victim := (reifiedMemory contextsOfProcess: (stackOfSize value: 9)) first receiver
