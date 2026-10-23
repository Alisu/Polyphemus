tests
testACounterSteppedIntoRoundItsLoopEditedCountsOn

	"Held in tick:, stepped into all the way round the loop, through Delay>>wait, into tick: again,
	as the Mac trial did; edited there and let go: no process lost as a zombie (#103)."

	| pid session read beat later processes |
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
	session stepOver: session interruptedContext.
	400 timesRepeat: [
		session interruptedContext selector = #tick: ifFalse: [ session stepInto: session interruptedContext ] ].
	self assert: session interruptedContext selector = #tick: description: 'stepping into never came round to tick: again'.
	self assert: (session
			 recompileMethodTo: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]'
			 inContext: session interruptedContext
			 notifying: nil).
	session resume.
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
