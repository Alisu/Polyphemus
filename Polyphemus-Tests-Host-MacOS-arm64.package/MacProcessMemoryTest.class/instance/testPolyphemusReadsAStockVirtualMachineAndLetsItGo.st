tests
testPolyphemusReadsAStockVirtualMachineAndLetsItGo

	"Through the front door, as on Linux: held still while copied, then running again."

	| pid reified |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	reified := Polyphemus readProcess: pid.
	self assert: reified allReifiedProcesses notEmpty.
	self deny: (MacProcessMemory on: pid) isStopped ] ensure: [ LibC system: 'kill ' , pid printString ]
