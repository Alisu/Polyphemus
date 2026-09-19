holding it still
stop

	"Stop the process with SIGSTOP so that a read is consistent. Needs only permission to
	signal it, not to read it."

	LibC system: 'kill -STOP ' , pid asString.
	^ self waitForState: $T
