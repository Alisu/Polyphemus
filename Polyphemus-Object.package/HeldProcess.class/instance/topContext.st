where
topContext

	"The context the process is in, from a copy taken in one stop. Found in the scheduler's
	queues when it is runnable, by walking the heap otherwise."

	| process |
	self readAgain.
	process := reading runnableProcesses
		           detect: [ :each | each oopHash = hash ]
		           ifNone: [ self processIn: reading of: dumped ].
	^ (reading contextsOfProcess: process) first
