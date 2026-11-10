tests
testAFileThatHoldsNoIndexIsRefused

	"#163, risk 9: read between its deletion and its writing, the file was empty, and '' asNumber
	nil: the ring went nowhere, or a second watcher was put in."

	(directory / 'semaphore-index') writeStreamDo: [ :stream | ].
	self should: [ WatcherInjection semaphoreIndexIn: directory ] raise: HoldFailed
