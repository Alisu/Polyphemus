tests
testTheRunningProcessOfAStoppedVirtualMachineShowsItsStack

	"Idle, no thread is in machine code, so the frame pointer, stack pointer and pc the VM
	saved on leaving for C are its own, and the running process's stack reads from them."

	| pid reader stack |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	reader := MacProcessMemory on: pid.
	reader whileStopped: [
		| dumped memory |
		self deny: (VMVariables on: reader) wasRunningMachineCode.
		dumped := SpurDumpedMemory on: reader.
		memory := dumped reifyEverything: dumped reifiedMemory.
		stack := memory activationsOfProcess: memory reifiedActiveProcess ].

	self assert: stack notEmpty.
	self assert: stack first isStackFrame.
	self assert: stack first pc notNil ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
