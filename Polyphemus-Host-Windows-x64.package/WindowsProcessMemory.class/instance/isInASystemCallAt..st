testing
isInASystemCallAt: aRip

	"Whether a thread's rip is just after a syscall instruction (0F 05): it waits in the kernel,
	in a stub of ntdll or win32u."

	^ (self bytesAt: aRip - 2 count: 2) = #[ 16r0F 16r05 ]
