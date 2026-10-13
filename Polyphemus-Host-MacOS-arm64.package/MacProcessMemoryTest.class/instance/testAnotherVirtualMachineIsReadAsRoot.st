tests
testAnotherVirtualMachineIsReadAsRoot

	"A stock Pharo VM, not re-signed: macOS gives root its task port, as it is not hardened. Read
	as Polyphemus readProcess: reads one on Linux: everything reified, then its processes."

	| pid dumped reified |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	dumped := SpurDumpedMemory on: (MacProcessMemory on: pid).
	reified := dumped reifyEverything: dumped reifiedMemory.
	self assert: reified allReifiedProcesses notEmpty ] ensure: [
		LibC system: 'kill ' , pid printString ]
