holding it still
stop

	"Stop the process with SIGSTOP so that a read is consistent, the map read before forgotten:
	running, it may have mapped or unmapped regions since (#102). Needs only leave to signal it."

	segments := nil.
	LibC system: 'kill -STOP ' , pid asString.
	^ self waitForState: $T
