tests
testTheRunningProcessOfAStoppedImageShowsItsStack

	"Stopped, each thread of the target says where it was (/proc/<pid>/task/*/syscall). None
	was in machine code, so the registers the VM saved on leaving for C are its own, and the
	running process's stack reads from them."

	| pid reader stack |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	reader whileStopped: [
		| dumped memory |
		self assert: reader threadRegisters notEmpty.
		self assert: (reader threadRegisters allSatisfy: [ :each | each includesKey: #rip ]).
		self deny: (VMVariables on: reader) wasRunningMachineCode.
		dumped := SpurDumpedMemory on: reader.
		memory := dumped reifyEverything: dumped reifiedMemory.
		stack := memory activationsOfProcess: memory reifiedActiveProcess ].

	self assert: stack notEmpty.
	self assert: stack first isStackFrame.
	self assert: stack first pc notNil ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
