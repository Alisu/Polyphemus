tests
testItWritesAWordIntoAStoppedVirtualMachine

	"mach_vm_write, as on Linux /proc/<pid>/mem: a word set from outside is in the VM when the
	same reader reads it again. A count of stack overflows is inert in an idle VM."

	| pid reader address was |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	reader := MacProcessMemory on: pid.
	address := (VMVariables on: reader) addressOf: 'statStackOverflow'.
	was := reader unsignedAt: address size: 8.

	reader whileStopped: [ reader storeWord: was + 1 at: address ].

	self assert: (reader unsignedAt: address size: 8) equals: was + 1.
	self assert: ((MacProcessMemory on: pid) unsignedAt: address size: 8) equals: was + 1 ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
