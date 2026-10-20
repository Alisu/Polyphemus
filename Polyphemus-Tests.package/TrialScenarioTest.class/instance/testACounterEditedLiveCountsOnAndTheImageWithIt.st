tests
testACounterEditedLiveCountsOnAndTheImageWithIt

	"A counter held live in tick:, stepped through its loop, run to tick: again, the method edited there
	and the image let go: it counts on with the new code, another process of its priority with it (#103)."

	| pid session read count beat |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	^ n + 1''.
[ | n | n := 5000.
  [ n := cls new tick: n.
    (dir / ''count.part'') ensureDelete; writeStreamDo: [ :s | s print: n ].
    (dir / ''count'') ensureDelete.
    (dir / ''count.part'') renameTo: ''count''.
    (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.
[ | b | b := 0.
  [ b := b + 1.
    (dir / ''beat.part'') ensureDelete; writeStreamDo: [ :s | s print: b ].
    (dir / ''beat'') ensureDelete.
    (dir / ''beat.part'') renameTo: ''beat''.
    (Delay forMilliseconds: 50) wait ] repeat ] forkAt: 40.'.
	read := [ :name | [ (self spikeDirectory / name) contents trimBoth asNumber ] on: Error do: [ :e | nil ] ].
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
	count := read value: 'count'.
	beat := read value: 'beat'.
	(Delay forSeconds: 2) wait.
	self
		assert: ((read value: 'count') notNil and: [ (read value: 'count') ~= count and: [ (read value: 'count') <= 1010 ] ])
		description: [ 'the counter did not count on with the new code: ' , count printString , ' then '
			, (read value: 'count') printString ].
	self
		assert: ((read value: 'beat') notNil and: [ (read value: 'beat') > beat ])
		description: [ 'the other process stopped: ' , beat printString , ' then ' , (read value: 'beat') printString ] ]
		ensure: [ LibC system: 'kill -9 ' , pid printString ]
