tests
testSystemCallsAreNamed

	"x86-64 numbers; these five were seen on Pharo targets (2026-10-05)."

	self assert: (LinuxStuckReport nameOfSystemCall: 61) equals: 'wait4'.
	self assert: (LinuxStuckReport nameOfSystemCall: 270) equals: 'pselect6'.
	self assert: (LinuxStuckReport nameOfSystemCall: 232) equals: 'epoll_wait'.
	self assert: (LinuxStuckReport nameOfSystemCall: 202) equals: 'futex'.
	self assert: (LinuxStuckReport nameOfSystemCall: 230) equals: 'clock_nanosleep'.
	self assert: (LinuxStuckReport nameOfSystemCall: 999) equals: 'system call 999'
