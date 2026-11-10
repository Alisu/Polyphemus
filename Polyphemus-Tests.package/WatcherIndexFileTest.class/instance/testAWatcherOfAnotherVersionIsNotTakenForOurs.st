tests
testAWatcherOfAnotherVersionIsNotTakenForOurs

	"#163, risk 6: a watcher an older Polyphemus put in an image was driven by a newer observer."

	WatcherInjection leaveSemaphoreIndex: 7 in: directory.
	self assert: (WatcherInjection isOfThisVersionIn: directory).
	(directory / 'watcher-version') writeStreamDo: [ :stream | stream truncate; nextPutAll: '12345' ].
	self deny: (WatcherInjection isOfThisVersionIn: directory).
	(directory / 'watcher-version') ensureDelete.
	self deny: (WatcherInjection isOfThisVersionIn: directory)
