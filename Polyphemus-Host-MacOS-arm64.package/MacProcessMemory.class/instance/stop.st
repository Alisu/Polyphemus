holding it still
stop

	"SIGSTOP, as on Linux, the map and blocks read before forgotten: running, it may have changed
	any of them since (#102). Waits up to two seconds to see it stopped."

	segments := nil.
	blocks := nil.
	LibC system: 'kill -STOP ' , pid printString.
	20 timesRepeat: [ self isStopped ifTrue: [ ^ true ]. (Delay forMilliseconds: 100) wait ].
	^ self isStopped
