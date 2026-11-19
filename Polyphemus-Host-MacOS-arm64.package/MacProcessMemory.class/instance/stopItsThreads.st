holding it still
stopItsThreads

	"SIGSTOP, as on Linux, through the stop helper where it builds (#137); else waits up to two
	seconds to see it stopped."

	^ self stopThroughTheHelperOr: [
		  LibC system: 'kill -STOP ' , pid printString.
		  Poll until: [ self isStopped ] every: 100 milliSeconds atMost: 20 ]
