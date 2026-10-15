tests
testItWritesAWordIntoAStoppedVirtualMachine

	"WriteProcessMemory, as /proc/<pid>/mem and mach_vm_write: a word set from outside is in
	the VM when it is read again. A count of stack overflows is inert in an idle VM."

	| pid reader address was |
	pid := self launchIdleTarget.
	[
	reader := WindowsProcessMemory on: pid.
	address := (VMVariables on: reader) addressOf: 'statStackOverflow'.
	was := reader unsignedAt: address size: 8.
	reader whileStopped: [ reader storeWord: was + 1 at: address ].
	self assert: (reader unsignedAt: address size: 8) equals: was + 1.
	self assert: ((WindowsProcessMemory on: pid) unsignedAt: address size: 8) equals: was + 1 ] ensure: [
		reader ifNotNil: [ reader close ].
		LibC system: 'taskkill /F /PID ' , pid printString ]
