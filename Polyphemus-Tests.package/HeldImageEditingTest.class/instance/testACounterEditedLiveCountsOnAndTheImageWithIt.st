tests
testACounterEditedLiveCountsOnAndTheImageWithIt

	"A counter held live in tick:, stepped through its loop, run to tick: again, the method edited there
	and the image let go: it counts on with the new code, another process of its priority with it (#103)."

	| pid session count pulse later |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 5000 after: (self writing: 'n' as: 'count')) , self pulse.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	session stepOver: session interruptedContext.
	session stepOver: session interruptedContext.
	self assert: session interruptedContext selector = #DoIt description: 'two steps over did not go back into the loop'.
	4 timesRepeat: [ session stepOver: session interruptedContext ].
	self assert: (session runUntil: 'Counter >> #tick:') description: 'it never came round to tick: again'.
	self assert: (session
			 recompileMethodTo: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]'
			 inContext: session interruptedContext
			 notifying: nil).
	session resume.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'it was never let go'.
	(Delay forSeconds: 2) wait.
	count := self valueIn: 'count'.
	pulse := self valueIn: 'pulse'.
	(Delay forSeconds: 2) wait.
	later := self valueIn: 'count'.
	self
		assert: (later notNil and: [ later ~= count and: [ later <= 1010 ] ])
		description: [ 'the counter did not count on with the new code: ' , count printString , ' then ' , later printString ].
	later := self valueIn: 'pulse'.
	self
		assert: (later notNil and: [ pulse notNil and: [ later > pulse ] ])
		description: [ 'the image''s pulse stopped: ' , pulse printString , ' then ' , later printString , ' -- ' , (self processesOf: pid) ] ]
		ensure: [ LibC system: 'kill -9 ' , pid printString ]
