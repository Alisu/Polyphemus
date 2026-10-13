accessing
wasRunningMachineCode

	"Whether a thread was in Cog's code zone: then the newest frames are only in its
	registers, and the variables the VM saves on leaving for C are stale. nil when that
	cannot be told: no registers kept, or a thread that gives none."

	| threads |
	(memory respondsTo: #threadRegisters) ifFalse: [ ^ nil ].
	threads := memory threadRegisters collect: [ :each | self class cogPointersIn: each ].
	(threads isEmpty or: [ threads anySatisfy: [ :each | each isNil ] ]) ifTrue: [ ^ nil ].
	^ threads anySatisfy: [ :each | self isMachineCodeAddress: (each at: #instructionPointer) ]
