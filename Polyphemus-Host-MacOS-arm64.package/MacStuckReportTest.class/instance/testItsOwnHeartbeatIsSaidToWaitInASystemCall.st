tests
testItsOwnHeartbeatIsSaidToWaitInASystemCall

	"A thread waiting in the kernel has its pc just after svc #0x80, in a stub of
	libsystem_kernel named by dladdr: this VM's heartbeat sleeps in __semwait_signal."

	| threads |
	threads := MacStuckReport new readThreadsOf: MacProcessMemory onSelf.
	self assert: (threads anySatisfy: [ :each |
			 each systemCallName = '__semwait_signal' and: [
				 each location = 'libsystem_kernel.dylib, in __semwait_signal' ] ])
