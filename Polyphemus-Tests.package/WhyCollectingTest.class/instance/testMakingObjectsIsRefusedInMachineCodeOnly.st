tests
testMakingObjectsIsRefusedInMachineCodeOnly

	"#163, risk 3: stopped in machine code, the JIT may be allocating, freeStart in a register: what
	we make in eden then is written over once it runs on. Its registers silent, it cannot be told."

	| state |
	state := CollectorStateDouble phase: 0 marking: 0.
	self assert: (ProcessMemory whyNotToAllocateIn: state) isNil.
	state machineCode: false.
	self assert: (ProcessMemory whyNotToAllocateIn: state) isNil.
	state machineCode: true.
	self assert: ((ProcessMemory whyNotToAllocateIn: state) includesSubstring: 'machine code').
	self assert: ((ProcessMemory whyNotToAllocateIn: (CollectorStateDouble phase: 1 marking: 0)) includesSubstring: 'gcPhaseInProgress')
