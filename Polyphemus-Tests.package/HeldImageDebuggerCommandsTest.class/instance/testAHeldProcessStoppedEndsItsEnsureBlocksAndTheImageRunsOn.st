tests
testAHeldProcessStoppedEndsItsEnsureBlocksAndTheImageRunsOn

	"Stopping ends the held process as Pharo's debugger ends one of its own, its ensure blocks
	run, and lets the image go: it runs on without it (#125)."

	| pid session count |
	pid := self launchCounterWithAnEnsure.
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	session stopTheHeldProcess.
	self assert: (self waitFor: [ (self spikeDirectory / 'released') exists ]) description: 'the image was never let go'.
	self assert: (self waitFor: [ (self spikeDirectory / 'ensured') exists ]) description: 'its ensure block never ran'.
	count := self valueIn: 'n'.
	(Delay forMilliseconds: 500) wait.
	self assert: (self valueIn: 'n') equals: count.
	self assert: (LibC system: 'kill -0 ' , pid printString) equals: 0 ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
