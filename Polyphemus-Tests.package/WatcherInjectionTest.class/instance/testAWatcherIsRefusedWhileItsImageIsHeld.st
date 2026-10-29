tests
testAWatcherIsRefusedWhileItsImageIsHeld

	"Ours is holding the image, so nobody waits on its semaphore: a second is not put in beside
	it, and the refusal says what to do (#124)."

	| pid session |
	pid := self launchStockSpinningTarget.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	[
	self
		should: [ Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory ]
		raise: Error
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'held right now') ] ]
		ensure: [ session resume ] ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
