tests
testAStockVirtualMachineIsReadAsRoot

	"What closes the gap the launcher leaves: a VM already running, started by anyone, read by
	an observer run as root, as on macOS. Held still while copied, then let go."

	| pid reified |
	self isRoot ifFalse: [ ^ self skip: 'reading a process we did not start, without its consent, needs root (sudo)' ].
	pid := self launchStockTargetRunning: 'nil'.
	[
	reified := Polyphemus readProcess: pid.
	self assert: reified allReifiedProcesses notEmpty.
	self deny: (LinuxProcessMemory on: pid) isStopped ] ensure: [ LibC system: 'kill ' , pid printString ]
