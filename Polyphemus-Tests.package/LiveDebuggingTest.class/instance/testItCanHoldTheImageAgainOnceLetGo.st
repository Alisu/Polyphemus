tests
testItCanHoldTheImageAgainOnceLetGo

	"The watcher arms itself again: an image let go can be debugged a second time."

	| pid |
	pid := self launchSpinningTarget.
	[
	(Polyphemus holdProcess: pid watchedIn: self spikeDirectory) resume.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]).
	(Polyphemus holdProcess: pid watchedIn: self spikeDirectory) resume.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
