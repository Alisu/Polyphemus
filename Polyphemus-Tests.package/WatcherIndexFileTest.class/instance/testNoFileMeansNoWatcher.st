tests
testNoFileMeansNoWatcher

	self assert: (WatcherInjection semaphoreIndexIn: directory) isNil
