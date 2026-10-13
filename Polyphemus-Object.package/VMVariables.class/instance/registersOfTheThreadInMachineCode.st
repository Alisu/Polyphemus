accessing
registersOfTheThreadInMachineCode

	"Cog's frame pointer, stack pointer and instruction pointer (cogPointersIn:) in the thread
	that was in Cog's code zone (wasRunningMachineCode, #17). nil when none was."

	(memory respondsTo: #threadRegisters) ifFalse: [ ^ nil ].
	^ (memory threadRegisters collect: [ :each | self class cogPointersIn: each ])
		  detect: [ :each | each notNil and: [ self isMachineCodeAddress: (each at: #instructionPointer) ] ]
		  ifNone: [ nil ]
