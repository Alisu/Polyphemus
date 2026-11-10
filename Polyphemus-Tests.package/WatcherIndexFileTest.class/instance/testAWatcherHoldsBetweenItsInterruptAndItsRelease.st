tests
testAWatcherHoldsBetweenItsInterruptAndItsRelease

	"#163, risk 6: a semaphore nobody waits on was taken for ours holding the image, whoever's it was."

	self deny: (WatcherInjection isHoldingIn: directory).
	(directory / 'interrupted') ensureCreateFile.
	self assert: (WatcherInjection isHoldingIn: directory).
	(directory / 'released') ensureCreateFile.
	self deny: (WatcherInjection isHoldingIn: directory)
