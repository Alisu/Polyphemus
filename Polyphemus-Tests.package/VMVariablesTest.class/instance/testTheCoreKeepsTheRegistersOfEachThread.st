tests
testTheCoreKeepsTheRegistersOfEachThread

	"NT_PRSTATUS notes: one per thread. The VM was in C when the core was taken, so no
	thread was running Cog's machine code."

	| threads |
	threads := dump threadRegisters.

	self assert: threads notEmpty.
	threads do: [ :each |
		self assert: ((each at: #rip) notNil and: [ (each at: #rsp) notNil ]) ].
	self deny: variables wasRunningMachineCode
