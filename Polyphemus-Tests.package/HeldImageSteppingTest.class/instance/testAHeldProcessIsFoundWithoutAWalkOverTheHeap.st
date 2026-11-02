tests
testAHeldProcessIsFoundWithoutAWalkOverTheHeap

	"Waiting, the held process is in no run queue: found the first time by a walk over the whole
	heap, 20 s on a large image (#129). The agent says where to look instead, a slot of the
	external objects table; a walk, made impossible here, is not needed."

	| pid session held dumped |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory until: 'Counter >> #tick:'.
	held := session heldProcess heldReading.
	dumped := held instVarNamed: #dumped.
	held instVarNamed: #dumped put: nil.
	held instVarNamed: #address put: nil.
	[ self assert: (held heldIn: held reading) oopHash equals: (held instVarNamed: #hash) ]
		ensure: [ held instVarNamed: #dumped put: dumped ].
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
