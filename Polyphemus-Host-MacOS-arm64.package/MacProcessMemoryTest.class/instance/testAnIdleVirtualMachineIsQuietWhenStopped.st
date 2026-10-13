tests
testAnIdleVirtualMachineIsQuietWhenStopped

	"Its main thread waits for events in the kernel (kevent): its pc is just after svc #0x80,
	so nothing of its heap is half changed."

	| pid reader |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	reader := MacProcessMemory on: pid.
	reader whileStopped: [ self assert: reader isQuiet ] ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
