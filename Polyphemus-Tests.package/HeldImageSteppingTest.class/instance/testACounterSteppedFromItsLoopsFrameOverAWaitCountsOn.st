tests
testACounterSteppedFromItsLoopsFrameOverAWaitCountsOn

	"As the Mac trial stepped: into the loop's calls (its label's among them), and when one was not tick:, from the loop's
	frame below it, which runs that call to its end, Delay>>wait among them; no edit (#103)."

	| pid session pulse later processes debugger model |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self windowedCounterTicking: 'tick: n
	^ n + 1' from: 5000) , self pulse.
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
		| loop |
		debugger session interruptedContext selector = #tick: ifFalse: [
			"The loop's frame as the stack list shows it, the one the user selects."
			loop := debugger stackTable items detect: [ :each | each selector = #DoIt ] ifNone: [ nil ].
			model stepInto: (loop ifNil: [ debugger session interruptedContext ]).
			PolyphemusTestCase drawWindowOf: debugger ] ].
	self assert: debugger session interruptedContext selector = #tick: description: 'stepping never came round to tick: again'.
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
