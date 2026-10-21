tests
testAMethodSavedInTheDebuggerKeepsItsSourceAndSavesAgain

	"A method saved in a held image shows the source it was saved from, written over the old code
	or made anew, and can be saved again: the image keeps that source as any save does (#105)."

	| pid session sourceNow |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	^ n + 1''.
[ | n | n := 0. [ n := cls new tick: n. (Delay forMilliseconds: 20) wait ] repeat ] forkNamed: ''counter''.'.
	sourceNow := [
	             [ (session interruptedContext homeMethod oopMethodClass methodNamed: 'tick:') sourceCode ]
		             on: Error
		             do: [ :e | 'no source (' , e messageText , ')' ] ].
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	self assert: (session recompileMethodTo: 'tick: n
	^ n + 2' inContext: session interruptedContext notifying: nil).
	self assert: (sourceNow value includesSubstring: 'n + 2') description: [ 'written over the old code, it shows ' , sourceNow value ].
	self assert: (session recompileMethodTo: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]' inContext: session interruptedContext notifying: nil).
	self assert: (sourceNow value includesSubstring: 'n + 10') description: [ 'made anew, it shows ' , sourceNow value ].
	self
		assert: (session recompileMethodTo: 'tick: n
	^ n > 1000 ifTrue: [ 0 ] ifFalse: [ n + 100 ]' inContext: session interruptedContext notifying: nil)
		description: 'saved once, it could not be saved again'.
	self assert: (sourceNow value includesSubstring: 'n + 100') description: [ 'saved again, it shows ' , sourceNow value ].
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
