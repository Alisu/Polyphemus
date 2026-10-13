reading registers
threadRegisters

	"Each thread's arm64 registers (task_threads, thread_get_state): #x0 to #x28, #fp, #lr,
	#sp, #pc and #pstate, as ElfCoreDump answers them from an aarch64 core."

	^ (self threadPorts collect: [ :each | self registersOfThread: each ]) reject: [ :each | each isNil ]
