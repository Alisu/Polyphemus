tests
testClosingTheDebuggerLetsTheHeldImageGo

	"The debugger of a held image closed without Proceed: the image is let go, and runs on. It stayed
	held, still and a core busy, until something let it go (#116)."

	| pid session debugger |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	^ n + 1''.
Smalltalk at: #PolyphemusTicks put: 0.
[ | n | n := 0.
  [ n := cls new tick: n.
    Smalltalk at: #PolyphemusTicks put: (Smalltalk at: #PolyphemusTicks) + 1.
    (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.'.
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
