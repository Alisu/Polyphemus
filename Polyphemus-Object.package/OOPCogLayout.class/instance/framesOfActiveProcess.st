reading
framesOfActiveProcess

	"From the frame pointer, stack pointer and instruction pointer: those the VM saves on
	leaving for C, or, when a thread was in machine code, its registers (#17), the variables
	being stale then. The newest frame's operands Cog still held in registers are not read."

	| variables running registers |
	variables := raw vmVariables.
	running := variables wasRunningMachineCode.
	running ifNil: [ ^ self refuse: #itCannotTellWhetherItWasRunningMachineCode ].
	running ifFalse: [
		^ self
			  framesFrom: (variables at: 'framePointer')
			  stackPointer: (variables at: 'stackPointer')
			  instructionPointer: (variables at: 'instructionPointer')
			  strictly: false ].
	registers := variables registersOfTheThreadInMachineCode ifNil: [
		             ^ self refuse: #itWasRunningMachineCodeWhoseFramesAreInRegisters ].
	^ self
		  framesFrom: (registers at: #rbp)
		  stackPointer: (registers at: #rsp)
		  instructionPointer: (registers at: #rip)
		  strictly: true
