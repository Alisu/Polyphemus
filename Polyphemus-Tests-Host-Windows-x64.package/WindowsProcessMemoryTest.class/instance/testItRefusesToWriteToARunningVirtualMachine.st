tests
testItRefusesToWriteToARunningVirtualMachine

	"Writing to a running machine breaks it: stopped only, as on Linux and macOS (#24)."

	| pid reader address |
	pid := self launchIdleTarget.
	[
	reader := WindowsProcessMemory on: pid.
	address := (VMVariables on: reader) addressOf: 'statStackOverflow'.
	self deny: reader isStopped.
	self should: [ reader storeWord: 1 at: address ] raise: Error ] ensure: [
		reader ifNotNil: [ reader close ].
		LibC system: 'taskkill /F /PID ' , pid printString ]
