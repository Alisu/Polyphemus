tests
testASignalNobodyWantsLeavesTheImageRunning

	"#137: a hold's signal delivered after the observer let go (runUntil:'s fallback, the trap's hold
	taken instead) woke the waiting watcher, which held the image 60 s with nobody to serve it.
	Seen by the counter ticking on, twice twenty-five ticks, not by a wait of a few seconds (#164)."

	| pid index |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: 'n \\ 25 = 0 ifTrue: [ (dir / ''ticked'') ensureCreateFile ].').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	index := self holdAskAndLetGo: pid.
	(self spikeDirectory / 'interrupted') ensureDelete.
	self signalLateIn: pid on: index.
	2 timesRepeat: [
		(self spikeDirectory / 'ticked') ensureDelete.
		self assert: (self waitFor: [ (self spikeDirectory / 'ticked') exists ]) description: 'the image stopped ticking' ].
	self deny: (self spikeDirectory / 'interrupted') exists.
	self holdAskAndLetGo: pid ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
