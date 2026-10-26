tests
testACounterSteppedIntoRoundItsLoopEditedCountsOn

	"Held in tick:, stepped into all the way round the loop, through Delay>>wait, into tick: again,
	as the Mac trial did; edited there and let go: no process lost as a zombie (#103)."

	| pid session pulse later processes |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 5000 after: '') , self pulse.
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
