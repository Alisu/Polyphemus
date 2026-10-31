tests
testALateRingLeavesTheWatchersCountAtZero

	"#137: what a late ring left behind, read where it went: the watcher's semaphore."

	| pid index |
	pid := self launchCounter.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	index := self holdAskAndLetGo: pid.
	self ringLateIn: pid.
	self assert: (self excessSignalsOn: index in: pid) equals: 0 ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
