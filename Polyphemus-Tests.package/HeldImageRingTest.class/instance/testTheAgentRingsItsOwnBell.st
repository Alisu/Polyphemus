tests
testTheAgentRingsItsOwnBell

	"#137: the agent waits on a semaphore of its own, named in bell-index, never the watcher's,
	and says bell-ended before it lets it go."

	| pid image bell |
	pid := self launchCounter.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	image := HeldImage on: pid watchedIn: self spikeDirectory.
	image holdWithin: 1 minute.
	bell := self spikeDirectory / 'channel' / 'bell-index'.
	self assert: bell exists.
	self deny: bell contents trimBoth asNumber equals: image semaphoreIndex.
	self deny: (self spikeDirectory / 'channel' / 'bell-ended') exists.
	image letGo.
	self assert: (self waitFor: [ (self spikeDirectory / 'channel' / 'bell-ended') exists ]) ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
