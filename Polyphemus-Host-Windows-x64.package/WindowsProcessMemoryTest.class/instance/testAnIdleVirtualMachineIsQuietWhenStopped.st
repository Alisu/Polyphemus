tests
testAnIdleVirtualMachineIsQuietWhenStopped

	"Its main thread waits for events in the kernel, its rip just after a syscall instruction
	(0F 05): at one of ten stops at least, as an idle VM still wakes now and then (its heartbeat,
	its delays), as on macOS."

	| pid reader |
	pid := self launchIdleTarget.
	[
	reader := WindowsProcessMemory on: pid.
	self
		assert: ((1 to: 10) anySatisfy: [ :each |
				 (reader whileStopped: [ reader isQuiet ]) or: [ (Delay forMilliseconds: 100) wait. false ] ])
		description: 'stopped ten times, it was never waiting in the kernel' ] ensure: [
		reader ifNotNil: [ reader close ].
		LibC system: 'taskkill /F /PID ' , pid printString ]
