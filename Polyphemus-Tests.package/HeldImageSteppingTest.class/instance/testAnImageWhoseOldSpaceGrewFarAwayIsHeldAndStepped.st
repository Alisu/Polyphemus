tests
testAnImageWhoseOldSpaceGrewFarAwayIsHeldAndStepped

	"#133: VM 9 maps each segment old space adds about 127 TB above the heap. Putting the watcher
	in, holding and stepping read the image across that bridge, never the gap."

	| pid session span |
	(self spikeDirectory / 'grown') ensureDelete.
	pid := self launchTargetDefining: 'Counter' thenRunning: 'Smalltalk at: #PolyphemusGrown put: (ByteArray new: 200 * 1024 * 1024).
Smalltalk garbageCollect.
(dir / ''grown'') ensureCreateFile.' , (self counterTicking: 'tick: n
	^ n + 1').
	[
	self assert: (self waitFor: [ (self spikeDirectory / 'grown') exists ]) description: 'it never grew'.
	span := self spanOfOldSpaceIn: pid.
	span < (1 bitShift: 40) ifTrue: [ ^ self skip: 'old space grew beside the heap here: no gap to read across' ].
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	session stepOver: session interruptedContext.
	self assert: (session heldProcess ask: '(Smalltalk at: #PolyphemusGrown) size printString') equals: '''209715200'''.
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
