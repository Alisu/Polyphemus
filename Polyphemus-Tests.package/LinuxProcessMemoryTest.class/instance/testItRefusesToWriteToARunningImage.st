tests
testItRefusesToWriteToARunningImage

	"Reading a running machine gives a muddle; writing to one breaks it. Stopped only (#24)."

	| pid reader address |
	pid := self launchObservableTarget.
	[
	reader := LinuxProcessMemory on: pid.
	address := (VMVariables on: reader) addressOf: 'interruptKeycode'.

	self deny: reader isStopped.
	self should: [ reader storeWord: 1 at: address ] raise: Error ] ensure: [
		LibC system: 'kill ' , pid printString.
		reader ifNotNil: [ reader close ] ]
