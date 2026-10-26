tests
testACounterHeldTwiceSteppedAndEditedEachTimeCountsOn

	"The Mac trial, again: held, stepped from the loop's frame into tick:, tick: saved, let go; then
	held once more and the same, the method saved being the one Polyphemus wrote. Nothing lost (#103)."

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
	debugger
		acceptCodeChanges: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]'
		forContext: debugger session interruptedContext.
	PolyphemusTestCase drawWindowOf: debugger.
	model proceedDebugSession ] ensure: [ debugger window ifNotNil: [ :window | window close ] ].
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'it was never let go'.
	(self spikeDirectory / 'released') ensureDelete.
	(Delay forSeconds: 1) wait.
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
	debugger
		acceptCodeChanges: 'tick: n
	^ n > 10000 ifTrue: [ 0 ] ifFalse: [ n + 100 ]'
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
