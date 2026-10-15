tests
testAnotherVirtualMachineIsRead

	"A Pharo VM of the same user, as anyone starts it: OpenProcess needs no elevation for it.
	Read whole, idle, its processes found."

	| pid dumped reified |
	pid := self launchIdleTarget.
	[
	dumped := SpurDumpedMemory on: (WindowsProcessMemory on: pid).
	reified := dumped reifyEverything: dumped reifiedMemory.
	self assert: reified allReifiedProcesses notEmpty ] ensure: [
		LibC system: 'taskkill /F /PID ' , pid printString ]
