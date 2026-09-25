tests
testProceedingInTheDebuggerLetsTheHeldImageGo

	"What proceeding means when the stack on screen belongs to an image being held: the word
	its watcher is waiting on is written, and it goes back to running. The debugger closes
	itself, which needs no help from here."

	| pid reader address session |
	pid := self launchSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	self holdWithTheInterrupt: reader.
	address := reader whileStopped: [
		           self excessSignalsOfTheInterruptSemaphoreIn:
			           (SpurDumpedMemory on: reader) raw ].
	session := ReifiedDebugSession named: 'Polyphemus' on: nil startedAt: nil fixing: nil.
	session releaseWith: [
		reader whileStopped: [ reader storeWord: 1 * 8 + 1 at: address ] ].

	self assert: session resume.

	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'proceeding never let it go'.
	self assert: (LinuxProcessMemory unchecked: pid) exists ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
