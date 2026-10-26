tests
testClosingTheDebuggerLetsTheHeldImageGo

	"The debugger of a held image closed without Proceed: the image is let go, and runs on. It stayed
	held, still and a core busy, until something let it go (#116)."

	| pid session debugger |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'Smalltalk at: #PolyphemusTicks put: 0.' , (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: 'Smalltalk at: #PolyphemusTicks put: (Smalltalk at: #PolyphemusTicks) + 1.').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	(self spikeDirectory / 'released') ensureDelete.
	debugger := StDebugger openOn: session withFullView: true.
	PolyphemusTestCase drawWindowOf: debugger.
	debugger window close.
	self
		assert: ((1 to: 200) anySatisfy: [ :each |
				 (self spikeDirectory / 'released') exists or: [ (Delay forMilliseconds: 100) wait. false ] ])
		description: 'closed without Proceed, the image stayed held' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
