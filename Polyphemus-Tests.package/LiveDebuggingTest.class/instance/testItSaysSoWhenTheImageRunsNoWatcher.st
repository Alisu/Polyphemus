tests
testItSaysSoWhenTheImageRunsNoWatcher

	| pid |
	pid := self launchObservableTarget.
	[
	self
		should: [
			Polyphemus
				holdProcess: pid
				watchedIn: self spikeDirectory
				within: 5 seconds ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'watcher') ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
