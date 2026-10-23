tests
testACounterSteppedRoundInTheDebuggerAndEditedThereCountsOn

	"The Mac trial through the debugger window, not the session: held in tick:, stepped into round
	the loop with its buttons, each step drawn, tick: edited in its code pane, Proceed (#103)."

	| pid session read beat later processes debugger model |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	^ n + 1''.
[ | n | n := 5000. [ n := cls new tick: n. (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.
[ | b | b := 0.
  [ b := b + 1.
    (dir / ''beat.part'') ensureDelete; writeStreamDo: [ :s | s print: b ].
    (dir / ''beat'') ensureDelete.
    (dir / ''beat.part'') renameTo: ''beat''.
    (Delay forMilliseconds: 50) wait ] repeat ] forkAt: 40.'.
	read := [ :name |
	        | value |
	        "Replaced every few ms: between two versions, there is none for an instant."
	        10 timesRepeat: [
		        value ifNil: [
			        value := [ (self spikeDirectory / name) contents trimBoth asNumber ] on: Error do: [ :e | nil ].
			        value ifNil: [ (Delay forMilliseconds: 20) wait ] ] ].
	        value ].
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
	beat := read value: 'beat'.
	(Delay forSeconds: 2) wait.
	later := read value: 'beat'.
	self
		deny: ((self spikeDirectory / 'target.log') contents includesSubstring: 'zombie')
		description: [ 'the VM lost processes: ' , (self spikeDirectory / 'target.log') contents ].
	self
		assert: (later notNil and: [ beat notNil and: [ later > beat ] ])
		description: [ 'the other process stopped: ' , beat printString , ' then ' , later printString , ' -- ' , (self processesOf: pid) ].
	processes := (Polyphemus readProcess: pid) allReifiedProcesses.
	self
		assert: (processes anySatisfy: [ :each | (Polyphemus nameOfProcess: each) = 'counter' ])
		description: 'the counter process is gone' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
