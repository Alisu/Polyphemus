holding it still
resume

	"Let it run again."

	LibC system: 'kill -CONT ' , pid asString.
	^ self isStopped not
