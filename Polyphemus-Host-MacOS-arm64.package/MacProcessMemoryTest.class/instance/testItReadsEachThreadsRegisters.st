tests
testItReadsEachThreadsRegisters

	"thread_get_state, arm64: each thread's frame pointer, link register, stack pointer and pc;
	its stack pointer is in its memory."

	| memory threads |
	memory := MacProcessMemory onSelf.
	threads := memory threadRegisters.
	self assert: threads notEmpty.
	threads do: [ :each |
		self assert: (each includesKey: #fp).
		self assert: (each includesKey: #lr).
		self assert: (each at: #pc) > 0.
		self assert: (memory hasAddress: (each at: #sp)) ]
