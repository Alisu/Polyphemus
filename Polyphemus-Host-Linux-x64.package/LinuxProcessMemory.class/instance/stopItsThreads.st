holding it still
stopItsThreads

	"SIGSTOP, which needs only leave to signal it, through the stop helper where it builds (#137)."

	^ self stopThroughTheHelperOr: [
		  LibC system: 'kill -STOP ' , pid asString.
		  self waitForState: $T ]
