reading registers
threadRegisters

	"Each thread's registers, named as ElfCoreDump and WindowsMinidump name x64's; a thread gone
	or with no user state yet (rip 0) is left out."

	^ (self threadIds collect: [ :each | self registersOfThread: each ]) reject: [ :each |
		  each isNil or: [ (each at: #rip) = 0 ] ]
