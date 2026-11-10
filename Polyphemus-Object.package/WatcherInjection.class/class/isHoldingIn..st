semaphore index
isHoldingIn: aDirectory

	"Whether its watcher took an interrupt and has not let go since: then its semaphore has no
	waiter, and that is ours holding the image."

	^ (aDirectory / 'interrupted') exists and: [ (aDirectory / 'released') exists not ]
