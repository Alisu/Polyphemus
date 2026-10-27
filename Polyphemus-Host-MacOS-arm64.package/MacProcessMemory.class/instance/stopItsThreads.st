holding it still
stopItsThreads

	"SIGSTOP, as on Linux; waits up to two seconds to see it stopped."

	LibC system: 'kill -STOP ' , pid printString.
	20 timesRepeat: [ self isStopped ifTrue: [ ^ true ]. (Delay forMilliseconds: 100) wait ].
	^ self isStopped
