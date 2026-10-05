printing
descriptionOf: aThread

	"The main thread is diagnosed (idle, blocked in C, running); the VM's other threads, its
	heartbeat for one, are only said to wait where they wait, which is their normal state."

	^ aThread descriptionAs: (aThread == self mainThread
			   ifTrue: [ aThread summary ]
			   ifFalse: [ aThread neutralSummary ])
