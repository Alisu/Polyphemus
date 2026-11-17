tests
testAFunctionOfTheSystemsLibrariesIsNamedInEveryProcess

	"The system's shared libraries lie at the same addresses in every process: what dladdr says
	here names another process's pc there."

	| kevent |
	kevent := MacStuckThread addressOfFunction: 'kevent'.
	self assert: (MacStuckThread functionAt: kevent) equals: 'libsystem_kernel.dylib, in kevent'.
	self assert: (MacStuckThread functionAt: kevent + 8) equals: 'libsystem_kernel.dylib, in kevent'.
	self assert: (MacStuckThread functionAt: 16r1000) isNil
