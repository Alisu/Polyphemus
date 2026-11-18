tests
testATrapNobodyWaitsForTakesItselfOutAndTheImageRunsOn

	"#181: a runUntil: that failed left its trap in the image: the next process to reach the method
	held the image with nobody there, and left a trap file for the next hold. Given up, the trap
	takes itself out when reached: the counter ticks on, and no trap is found at the next hold."

	| pid image |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: 'n \\ 25 = 0 ifTrue: [ (dir / ''ticked'') ensureCreateFile ].').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	image := HeldImage holding: pid watchedIn: self spikeDirectory within: 1 minute.
	image armTheTrapUntil: 'Counter >> #tick:'.
	image giveUpTheTrap.
	(self spikeDirectory / 'ticked') ensureDelete.
	image letGo.
	self assert: (self waitFor: [ (self spikeDirectory / 'ticked') exists ]) description: 'the image stayed held at a trap nobody waits for'.
	self deny: (self spikeDirectory / 'trap') exists.
	image := HeldImage holding: pid watchedIn: self spikeDirectory within: 1 minute.
	self assert: (image process ask: 'Smalltalk globals includesKey: #PolyphemusTrap') equals: 'false'.
	image letGo ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
