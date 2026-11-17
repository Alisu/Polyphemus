tests
testItRefusesToWriteToARunningVirtualMachine

	"Writing to a running machine breaks it: stopped only, as on Linux (#24)."

	| pid reader address |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	[
	reader := MacProcessMemory on: pid.
	address := (VMVariables on: reader) addressOf: 'statStackOverflow'.

	self deny: reader isStopped.
	self should: [ reader storeWord: 1 at: address ] raise: Error ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
