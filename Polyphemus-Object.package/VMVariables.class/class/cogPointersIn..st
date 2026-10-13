registers
cogPointersIn: aThreadsRegisters

	"Cog's #framePointer, #stackPointer and #instructionPointer in a thread's registers: rbp,
	rsp, rip on x86-64; x29 (#fp), x28, pc on arm64, where sp is C's (CogARMv8Compiler). nil
	without an instruction pointer; a pointer not kept is nil."

	| names |
	names := (aThreadsRegisters includesKey: #pc)
		         ifTrue: [ #( #fp #x28 #pc ) ]
		         ifFalse: [ #( #rbp #rsp #rip ) ].
	(aThreadsRegisters includesKey: names last) ifFalse: [ ^ nil ].
	^ Dictionary newFrom: (#( #framePointer #stackPointer #instructionPointer ) with: names collect: [ :pointer :name |
			   pointer -> (aThreadsRegisters at: name ifAbsent: [ nil ]) ])
