tests
testItRefusesAnImageThatAlreadyHasOne

	"A watcher of ours already waiting on the semaphore left in that directory is not doubled."

	| pid |
	pid := self launchSpinningTarget.
	[
	self
		should: [ Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'already has a watcher') ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
