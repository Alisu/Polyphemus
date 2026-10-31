tests
testASignalNobodyWantsLeavesTheImageRunning

	"#137: a hold's signal delivered after the observer let go (runUntil:'s fallback, the trap's hold
	taken instead) woke the waiting watcher, which held the image 60 s with nobody to serve it."

	| pid index |
	pid := self launchCounter.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	index := self holdAskAndLetGo: pid.
	(self spikeDirectory / 'interrupted') ensureDelete.
	self signalLateIn: pid on: index.
	(Delay forSeconds: 5) wait.
	self deny: (self spikeDirectory / 'interrupted') exists.
	self holdAskAndLetGo: pid ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
