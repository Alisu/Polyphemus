tests
testEachClassHearsOfItsOwnTargetOnly

	"#31: one pid file for the edition let two classes launching at once each read, stop and
	kill the other's target."

	self deny: LinuxProcessMemoryTest new observablePidFile = LiveDebuggingTest new observablePidFile
