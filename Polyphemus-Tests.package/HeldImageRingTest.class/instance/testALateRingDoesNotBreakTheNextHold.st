tests
testALateRingDoesNotBreakTheNextHold

	"#137: a ring sent once the agent ended left the waiting watcher a signal it took for the next
	hold's serve ring: that hold found no agent, nothing serving (seen on a Mac, 2026-10-30)."

	| pid image |
	pid := self launchCounter.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	self holdAskAndLetGo: pid.
	self ringLateIn: pid.
	image := HeldImage on: pid watchedIn: self spikeDirectory.
	image holdWithin: 1 minute.
	self assert: (image process ask: '3 + 4') equals: '7'.
	image letGo ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
