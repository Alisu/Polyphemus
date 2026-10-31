source
sourceServingOnItsOwnBell: aDirectory

	"The agent on a semaphore it registers itself, ending itself after the hold limit without a
	request: a ring after it ended never reaches the watcher (#137)."

	^ self sourceServing: aDirectory bell: nil limit: self holdLimit
