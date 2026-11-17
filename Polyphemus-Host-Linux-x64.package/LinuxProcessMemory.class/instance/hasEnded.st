testing
hasEnded

	"Gone, or dead and waiting for its parent to collect it (a zombie): either way it never
	answers again (#127)."

	^ self exists not or: [ self state = $Z ]
