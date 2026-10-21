tests
testASavedMethodKeepsTheImagesOwnSymbolForItsSelector

	"tick: compiled in the image moments before, its symbol still among the image's new ones: a
	method saved in place of it is found by that symbol, and no second #tick: is made (#106)."

	| pid session |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	^ n + 1''.
[ | n | n := 0. [ n := cls new tick: n. (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	session recompileMethodTo: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]' inContext: session interruptedContext notifying: nil.
	self
		assert: (session heldProcess ask: '(Counter methodDict includesKey: #tick:) printString') = '''true'''
		description: 'the image no longer finds tick: by its own symbol'.
	self
		assert: (session heldProcess ask: '(ByteSymbol allInstances count: [ :each | each = #tick: ]) printString') = '''1'''
		description: 'a second #tick: was made'.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
