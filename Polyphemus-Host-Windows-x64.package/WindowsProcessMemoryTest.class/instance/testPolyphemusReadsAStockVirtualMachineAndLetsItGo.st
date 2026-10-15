tests
testPolyphemusReadsAStockVirtualMachineAndLetsItGo

	"Through the front door, as on Linux and macOS: held still at a quiet moment while copied,
	then running again."

	| pid reified |
	pid := self launchIdleTarget.
	[
	reified := Polyphemus readProcess: pid.
	self assert: reified allReifiedProcesses notEmpty.
	self deny: (WindowsProcessMemory on: pid) isStopped ] ensure: [
		LibC system: 'taskkill /F /PID ' , pid printString ]
