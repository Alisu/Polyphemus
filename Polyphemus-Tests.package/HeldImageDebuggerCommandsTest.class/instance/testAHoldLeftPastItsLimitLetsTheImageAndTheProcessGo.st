tests
testAHoldLeftPastItsLimitLetsTheImageAndTheProcessGo

	"An observer that died holds no image for ever: past the limit without a request the agent lets
	it go, the held process back in its run queue (#103), and what is asked afterwards is told why."

	| pid session before |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: 'n \\ 25 = 0 ifTrue: [ (dir / ''ticked'') ensureCreateFile ].').
	before := Polyphemus holdLimit.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	Polyphemus holdLimit: 3 seconds.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	(self spikeDirectory / 'ticked') ensureDelete.
	self assert: (self waitFor: [ (self spikeDirectory / 'ticked') exists ]) description: 'the counter never ran again'.
	self
		should: [ session heldProcess ask: 'nil' ]
		raise: PolyphemusChannelError
		withExceptionDo: [ :error | self assert: (error messageText includesSubstring: 'without a request') ] ]
		ensure: [
			Polyphemus holdLimit: before.
			LibC system: 'kill -9 ' , pid printString ]
