tests
testAHeldProcessIsSteppedWithoutAWalkOverTheHeap

	"Suspended while held (#103), the process is in no run queue, where its stack was looked for:
	each step walked the whole heap to find it (1.7 s a step against 0.45 s, the Mac trial felt it).
	Found once, it is found again where it was: a walk, made impossible here, is not needed."

	| pid session held dumped |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	session stepOver: session interruptedContext.
	held := session heldProcess.
	dumped := held instVarNamed: #dumped.
	held instVarNamed: #dumped put: nil.
	[ self shouldnt: [ held heldIn: (held instVarNamed: #reading) ] raise: Error ]
		ensure: [ held instVarNamed: #dumped put: dumped ].
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
