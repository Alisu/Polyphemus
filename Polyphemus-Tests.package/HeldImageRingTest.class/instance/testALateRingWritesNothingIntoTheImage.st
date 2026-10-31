tests
testALateRingWritesNothingIntoTheImage

	"#137: once the agent let its bell go, its slot of the external objects table holds nil; a ring
	counted there would write past nil, into another object."

	| pid before |
	pid := self launchCounter.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	self holdAskAndLetGo: pid.
	before := self wordsAfterNilIn: pid.
	self ringLateIn: pid.
	self assert: (self wordsAfterNilIn: pid) equals: before ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
