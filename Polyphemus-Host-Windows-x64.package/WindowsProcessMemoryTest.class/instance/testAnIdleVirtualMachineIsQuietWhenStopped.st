tests
testAnIdleVirtualMachineIsQuietWhenStopped

	"Its main thread waits for events in the kernel: its rip is just after a syscall
	instruction (0F 05), so nothing of its heap is half changed."

	| pid reader |
	pid := self launchIdleTarget.
	[
	reader := WindowsProcessMemory on: pid.
	reader whileStopped: [ self assert: reader isQuiet ] ] ensure: [
		reader ifNotNil: [ reader close ].
		LibC system: 'taskkill /F /PID ' , pid printString ]
