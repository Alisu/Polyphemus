tests
testAnIdleVirtualMachineIsQuietWhenStopped

	"Its main thread waits for events in the kernel (kevent), its pc just after svc #0x80: at one
	of ten stops at least, as an idle VM still wakes now and then (its heartbeat, its delays)."

	| pid reader |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	reader := MacProcessMemory on: pid.
	self
		assert: ((1 to: 10) anySatisfy: [ :each |
				 (reader whileStopped: [ reader isQuiet ]) or: [ (Delay forMilliseconds: 100) wait. false ] ])
		description: 'stopped ten times, it was never waiting in the kernel' ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
