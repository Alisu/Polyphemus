tests
testAHeldProcessIsSuspendedWhileSteppedAndRunsOnOnceLetGo

	"Held, the process shown is suspended, as Pharo's debugger keeps the one it debugs, also across
	steps over its wait: left in its run queue, the VM ran it, or dropped it as a zombie, whenever a
	step made the agent wait (#103). Let go, it runs on."

	| pid session state ticks before |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'Smalltalk at: #PolyphemusTicks put: 0.' , (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: 'Smalltalk at: #PolyphemusTicks put: (Smalltalk at: #PolyphemusTicks) + 1.').
	state := [ session heldProcess ask: '(self at: #process) isSuspended printString' ].
	ticks := [ (session heldProcess ask: '(Smalltalk at: #PolyphemusTicks) printString') ].
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	self assert: state value = '''true''' description: 'held, it is still in its run queue'.
	8 timesRepeat: [
		session stepOver: session interruptedContext.
		self assert: state value = '''true''' description: 'stepped, it is back in a run queue' ].
	before := (ticks value copyReplaceAll: '''' with: '') asNumber.
	session resume.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'it was never let go'.
	(Delay forSeconds: 1) wait.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self
		assert: (ticks value copyReplaceAll: '''' with: '') asNumber > (before + 5)
		description: 'let go, it did not run on'.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
