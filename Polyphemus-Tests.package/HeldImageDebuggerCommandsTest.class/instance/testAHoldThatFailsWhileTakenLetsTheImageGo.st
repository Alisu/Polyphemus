tests
testAHoldThatFailsWhileTakenLetsTheImageGo

	"Taking a hold can fail once the agent serves (here its process is not found): the image is let
	go, not left spinning in an agent nobody will ask."

	| pid image |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: 'n \\ 25 = 0 ifTrue: [ (dir / ''ticked'') ensureCreateFile ].').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	image := HeldImageMisreadingItsProcess on: pid watchedIn: self spikeDirectory.
	self should: [ image holdWithin: 1 minute ] raise: Error.
	(self spikeDirectory / 'ticked') ensureDelete.
	self assert: (self waitFor: [ (self spikeDirectory / 'ticked') exists ]) description: 'the image stayed held' ]
		ensure: [ LibC system: 'kill -9 ' , pid printString ]
