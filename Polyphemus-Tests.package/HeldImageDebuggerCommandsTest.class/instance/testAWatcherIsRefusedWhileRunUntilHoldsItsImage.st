tests
testAWatcherIsRefusedWhileRunUntilHoldsItsImage

	"Held at a method by runUntil:, a watcher put in again is refused as other refusals are, said in
	the observer: as a plain error it only went to PharoDebug.log (#132)."

	| pid session |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	[
	self
		should: [ Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory ]
		raise: NotOnAReading
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'held right now') ] ]
		ensure: [ session resume ] ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
