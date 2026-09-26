tests
testThePutInWatcherHoldsAgainOnceLetGo

	| pid |
	pid := self launchStockSpinningTarget.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	(Polyphemus holdProcess: pid watchedIn: self spikeDirectory) resume.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]).
	(Polyphemus holdProcess: pid watchedIn: self spikeDirectory) resume.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
