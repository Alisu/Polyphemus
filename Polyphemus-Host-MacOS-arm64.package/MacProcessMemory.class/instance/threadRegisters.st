reading registers
threadRegisters

	"Each thread's arm64 registers (task_threads, thread_get_state), as ElfCoreDump answers them
	from an aarch64 core. A thread caught being created or ending answers pc 0, no user state
	yet: left out (CI, macOS Pharo 10, 2026-10-15)."

	^ (self threadPorts collect: [ :each | self registersOfThread: each ]) reject: [ :each |
		  each isNil or: [ (each at: #pc) = 0 ] ]
