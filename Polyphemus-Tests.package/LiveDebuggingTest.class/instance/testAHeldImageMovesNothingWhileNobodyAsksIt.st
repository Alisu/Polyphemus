tests
testAHeldImageMovesNothingWhileNobodyAsksIt

	"Between our requests the agent allocates nothing, so the image does not collect and what
	was read stays where it was read: what makes an edit of it safe (#20)."

	| pid reader scavenges before |
	pid := self launchSpinningTarget.
	[
	Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	reader := LinuxProcessMemory on: pid.
	scavenges := [ reader whileStopped: [ (VMVariables on: reader) at: 'statScavenges' ] ].
	before := scavenges value.
	(Delay forSeconds: 2) wait.
	self assert: scavenges value equals: before ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
