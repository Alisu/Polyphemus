tests
testItRefusesAnImageThatAlreadyHasOne

	"Something waiting on the interrupt semaphore already -- a watcher of ours, or the image's
	own handler -- is not stood in front of."

	| pid |
	pid := self launchSpinningTarget.
	[
	self
		should: [ Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory ]
		raise: Error
		withExceptionDo: [ :error |
			self assert: (error messageText includesSubstring: 'already waits') ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
