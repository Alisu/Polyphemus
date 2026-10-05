tests
testTheThreadInMachineCodeIsTheOneWhoseRegistersAreTaken

	| core variables registers |
	core := (self machineCodeCoreWhere: #inItsFrame) ifNil: [ ^ self skip: 'no gdb here, or no core caught in machine code' ].
	variables := VMVariables on: (ElfCoreDump on: core).
	registers := variables registersOfTheThreadInMachineCode.

	self assert: ((registers at: #rip) between: (variables at: 'codeBase') and: (variables at: 'mzFreeStart') - 1)
