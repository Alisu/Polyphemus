running
setUp

	"Found before anything is overwritten: the process that was snapshotting, of it a context
	running a method and one running a block, and an object of another stack, whose class is
	made unreadable for one kind of damage."

	| stackOfSize |
	super setUp.
	stackOfSize := [ :size |
	               reifiedMemory allReifiedProcesses detect: [ :each |
		               (reifiedMemory contextsOfProcess: each) size = size ] ].
	process := stackOfSize value: 19.
	contexts := (reifiedMemory contextsOfProcess: process) in: [ :all | { (all at: 2). (all at: 4) } ].
	victim := (reifiedMemory contextsOfProcess: (stackOfSize value: 9)) first receiver
