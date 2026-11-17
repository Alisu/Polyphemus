tests
testItHoldsAVirtualMachineStillAndLetsItGo

	"NtSuspendProcess holds every thread; NtResumeProcess lets them go. Stopped, as Windows
	keeps no such state, means every thread suspended."

	| pid reader |
	pid := self launchIdleTarget.
	[
	reader := WindowsProcessMemory on: pid.
	self deny: reader isStopped.
	reader whileStopped: [ self assert: reader isStopped ].
	self deny: reader isStopped ] ensure: [
		reader ifNotNil: [ reader close ].
		LibC system: 'taskkill /F /PID ' , pid printString ]
