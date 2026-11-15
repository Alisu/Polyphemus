running
setUp

	"Found before anything is overwritten: a context of the process that was snapshotting whose
	receiver is an ordinary object, the class of that receiver, and an object of another stack,
	whose class is made unreadable for one kind of damage."

	| stackOfSize |
	super setUp.
	stackOfSize := [ :size |
	               reifiedMemory allReifiedProcesses detect: [ :each |
		               (reifiedMemory contextsOfProcess: each) size = size ] ].
	process := stackOfSize value: 19.
	context := (reifiedMemory contextsOfProcess: process) at: 9.
	subject := context receiver oopClass.
	victim := (reifiedMemory contextsOfProcess: (stackOfSize value: 9)) first receiver
