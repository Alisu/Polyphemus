tests
testItReadsEachThreadsRegisters

	"GetThreadContext, named as a minidump's are: each thread's rip, and its rsp in its memory."

	| memory threads |
	memory := WindowsProcessMemory onSelf.
	threads := memory threadRegisters.
	self assert: threads notEmpty.
	threads do: [ :each |
		self assert: (each at: #rip) > 0.
		self assert: (memory hasAddress: (each at: #rsp)) ]
