tests
testATrapFiringAsItsDeadlinePassesIsHeldOnce

	"#137: runUntil:'s deadline can pass as the trap fires; its fallback hold then signalled a
	watcher the trap had woken, which took it for its serve ring and left with no agent."

	| pid image |
	pid := self launchTargetDefining: 'Counter' thenRunning: 'cls compile: ''tick: n
	^ n + 1''.
[ | n | n := 0. [ n := cls new tick: n ] repeat ] forkAt: Processor userBackgroundPriority named: ''counter''.'.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	"The race is won either way now and then: five tries."
	5 timesRepeat: [
		image := HeldImage on: pid watchedIn: self spikeDirectory.
		image holdWithin: 1 minute.
		image runUntil: 'Counter >> #tick:' within: 0 seconds.
		self assert: (image process ask: '3 + 4') equals: '7'.
		image letGo.
		self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'never let go' ] ]
		ensure: [ LibC system: 'kill -9 ' , pid printString ]
