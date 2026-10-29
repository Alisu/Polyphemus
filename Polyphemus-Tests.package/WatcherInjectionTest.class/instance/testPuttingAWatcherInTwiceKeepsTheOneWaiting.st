tests
testPuttingAWatcherInTwiceKeepsTheOneWaiting

	"Put in again where ours already waits, nothing changes and no error: the one waiting is
	answered, and holds as before (#124)."

	| pid first |
	pid := self launchStockSpinningTarget.
	[
	first := Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	self assert: (Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory) equals: first.
	(Polyphemus holdProcess: pid watchedIn: self spikeDirectory) resume.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
