holding it still
stopItsThreads

	"SIGSTOP, which needs only leave to signal it."

	LibC system: 'kill -STOP ' , pid asString.
	^ self waitForState: $T
