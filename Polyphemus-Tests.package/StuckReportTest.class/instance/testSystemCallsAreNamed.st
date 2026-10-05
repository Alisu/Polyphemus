tests
testSystemCallsAreNamed

	"x86-64 numbers; these five were seen on Pharo targets (2026-10-05)."

	self assert: (StuckReport nameOfSystemCall: 61) equals: 'wait4'.
	self assert: (StuckReport nameOfSystemCall: 270) equals: 'pselect6'.
	self assert: (StuckReport nameOfSystemCall: 232) equals: 'epoll_wait'.
	self assert: (StuckReport nameOfSystemCall: 202) equals: 'futex'.
	self assert: (StuckReport nameOfSystemCall: 230) equals: 'clock_nanosleep'.
	self assert: (StuckReport nameOfSystemCall: 999) equals: 'system call 999'
