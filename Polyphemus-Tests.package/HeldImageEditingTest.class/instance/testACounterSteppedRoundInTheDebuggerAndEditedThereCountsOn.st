tests
testACounterSteppedRoundInTheDebuggerAndEditedThereCountsOn

	"The Mac trial through the debugger window, not the session: held in tick:, stepped into round
	the loop with its buttons, each step drawn, tick: edited in its code pane, Proceed (#103)."

	| pid session pulse later processes debugger model |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 5000 after: '') , self pulse.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	debugger := StDebugger openOn: session withFullView: true.
	[
	model := PolyphemusTestCase actionModelOf: debugger.
	model stepOver: debugger session interruptedContext.
	PolyphemusTestCase drawWindowOf: debugger.
	400 timesRepeat: [
		debugger session interruptedContext selector = #tick: ifFalse: [
			model stepInto: debugger session interruptedContext.
			PolyphemusTestCase drawWindowOf: debugger ] ].
	self assert: debugger session interruptedContext selector = #tick: description: 'stepping into never came round to tick: again'.
	debugger
		acceptCodeChanges: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]'
		forContext: debugger session interruptedContext.
	PolyphemusTestCase drawWindowOf: debugger.
	model proceedDebugSession ] ensure: [ debugger window ifNotNil: [ :window | window close ] ].
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'it was never let go'.
	(Delay forSeconds: 2) wait.
	pulse := self valueIn: 'pulse'.
	(Delay forSeconds: 2) wait.
	later := self valueIn: 'pulse'.
	self
		deny: ((self spikeDirectory / 'target.log') contents includesSubstring: 'zombie')
		description: [ 'the VM lost processes: ' , (self spikeDirectory / 'target.log') contents ].
	self
		assert: (later notNil and: [ pulse notNil and: [ later > pulse ] ])
		description: [ 'the image''s pulse stopped: ' , pulse printString , ' then ' , later printString , ' -- ' , (self processesOf: pid) ].
	processes := (Polyphemus readProcess: pid) allReifiedProcesses.
	self
		assert: (processes anySatisfy: [ :each | (Polyphemus nameOfProcess: each) = 'counter' ])
		description: 'the counter process is gone' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
