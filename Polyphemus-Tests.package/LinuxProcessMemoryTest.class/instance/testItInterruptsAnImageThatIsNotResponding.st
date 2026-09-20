tests
testItInterruptsAnImageThatIsNotResponding

	"#24: a word set from outside makes the VM signal the image's interrupt semaphore at its
	next check, so a process that will not yield is preempted -- Pharo's own Cmd-. path,
	driven from outside, which is how a wedged image will be stopped where we want it."

	| pid reader address |
	pid := self launchSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	address := (VMVariables on: reader) addressOf: 'interruptPending'.
	self deny: (LinuxProcessMemory unchecked: pid) isQuiet.

	reader whileStopped: [ reader storeWord: 1 at: address ].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'interrupted') exists ])
		description: 'the image never took the interrupt'.
	self assert: (reader unsignedAt: address size: 8) equals: 0 ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
