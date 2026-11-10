tests
testAnIndexIsLeftWholeUnderItsName

	WatcherInjection leaveSemaphoreIndex: 7 in: directory.
	WatcherInjection leaveSemaphoreIndex: 12 in: directory.
	self assert: (WatcherInjection semaphoreIndexIn: directory) equals: 12.
	self assert: (directory children collect: [ :each | each basename ]) asArray sort equals: #( 'semaphore-index' 'watcher-version' )
