tests
testTheRunningProcessOfAStoppedImageShowsItsStack

	"Stopped while quiet, each thread of the target says where it was
	(/proc/<pid>/task/*/syscall). None was in machine code, so the registers the VM saved on
	leaving for C are its own, and the running process's stack reads from them."

	| pid reader stack saved |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	reader whileStoppedWhenQuiet: [
		| dumped memory |
		self assert: reader threadRegisters notEmpty.
		self assert: (reader threadRegisters allSatisfy: [ :each | each includesKey: #rip ]).
		self deny: (VMVariables on: reader) wasRunningMachineCode.
		saved := #( 'framePointer' 'stackPointer' 'instructionPointer' ) collect: [ :each |
			         each -> ((VMVariables on: reader) at: each) ].
		dumped := SpurDumpedMemory on: reader.
		memory := dumped reifiedMemory.
		stack := memory activationsOfProcess: memory reifiedActiveProcess ].

	self assert: stack notEmpty.
	self assert: stack first isStackFrame.
	self assert: stack first pc notNil description: [
		(self whyHasNoPc: stack first) , ', frame pointer 16r'
		, (stack first instVarNamed: #framePointer) printStringHex , ', the VM saved '
		, (' ' join: (saved collect: [ :each | each key , ' 16r' , each value printStringHex ])) ] ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
