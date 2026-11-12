tests
testMakingObjectsIsForMachineCodeOrAVMAtRest

	"#167: in its own code and not at rest, the VM may be remembering an object, the set's size
	in a register: our entry would take its place, or lose its own. In machine code it is in none
	of its routines, at rest neither. Its registers silent, it cannot be told, and is refused."

	| state collecting |
	state := CollectorStateDouble phase: 0 marking: 0.
	self assert: ((ProcessMemory whyNotToAllocateIn: state) includesSubstring: 'its own code').
	state machineCode: false.
	self assert: ((ProcessMemory whyNotToAllocateIn: state) includesSubstring: 'its own code').
	state atRest: true.
	self assert: (ProcessMemory whyNotToAllocateIn: state) isNil.
	state atRest: false; machineCode: true.
	self assert: (ProcessMemory whyNotToAllocateIn: state) isNil.
	collecting := CollectorStateDouble phase: 1 marking: 0.
	collecting machineCode: true.
	self assert: ((ProcessMemory whyNotToAllocateIn: collecting) includesSubstring: 'gcPhaseInProgress')
