tests
testCogsPointersAreNamedByTheProcessor

	"Cog's frame pointer, stack pointer and pc in a thread's registers: rbp, rsp and rip on
	x86-64; x29 (fp), x28 and pc on arm64, where sp is the C stack's (CogARMv8Compiler).
	/proc gives only rsp and rip: no frame pointer then."

	| x64 arm64 proc |
	x64 := VMVariables cogPointersIn: (Dictionary newFrom: { #rbp -> 1. #rsp -> 2. #rip -> 3 }).
	arm64 := VMVariables cogPointersIn: (Dictionary newFrom: { #fp -> 1. #sp -> 9. #x28 -> 2. #pc -> 3 }).
	proc := VMVariables cogPointersIn: (Dictionary newFrom: { #rsp -> 2. #rip -> 3 }).

	{ x64. arm64 } do: [ :each |
		self assert: (each at: #framePointer) equals: 1.
		self assert: (each at: #stackPointer) equals: 2.
		self assert: (each at: #instructionPointer) equals: 3 ].
	self assert: (proc at: #framePointer) isNil.
	self assert: (proc at: #instructionPointer) equals: 3.
	self assert: (VMVariables cogPointersIn: Dictionary new) isNil
