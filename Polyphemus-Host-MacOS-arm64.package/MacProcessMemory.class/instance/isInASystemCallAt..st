testing
isInASystemCallAt: aPc

	"Whether a thread's pc is just after svc #0x80: it waits in the kernel, in a stub of
	libsystem_kernel (arm64)."

	^ ((self bytesAt: aPc - 4 count: 4) ifNotNil: [ :bytes | bytes unsignedLongAt: 1 ]) = 16rD4001001
