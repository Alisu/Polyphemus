tests
testAScriptsLoopIsSteppedLive

	"A counter a script forked, held live in its tick: method: stepped over back into the script's
	loop, a DoIt with no source, and on through it, each step drawn and moving it (the Mac trial)."

	| pid session debugger trail |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self windowedCounterTicking: 'tick: n
	^ n + 1' from: 0).
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	[
	debugger := StDebugger openOn: session withFullView: true.
	trail := OrderedCollection with: debugger session interruptedContext selector -> debugger session interruptedContext pc.
	6 timesRepeat: [
		(PolyphemusTestCase actionModelOf: debugger) stepOver: debugger session interruptedContext.
		PolyphemusTestCase drawWindowOf: debugger.
		trail add: debugger session interruptedContext selector -> debugger session interruptedContext pc ].
	self
		assert: (trail count: [ :each | each key = #DoIt ]) >= 2
		description: [ 'never stepped on through the script''s loop: ' , trail printString ].
	self assert: trail asSet size = trail size description: [ 'a step did not move it: ' , trail printString ].
	(PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ] ensure: [
		debugger ifNotNil: [ debugger window ifNotNil: [ :window | window close ] ] ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
