tests
testTheImageStopsRunningAwayOnceTheFixIsIn

	"The whole of it, on a machine that is not responding: the process that will not yield is
	looping on SmallInteger>>even, which the machine has compiled. Held, patched, its code
	discarded, and let go -- the loop ends at its next question and the image goes idle, which
	is what an image that answers again looks like from outside."

	| pid reader |
	pid := self launchWarmedSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	self deny: (LinuxProcessMemory unchecked: pid) isQuiet description: 'it was not running away'.
	self holdWithTheInterrupt: reader.

	reader whileStopped: [
		| dumped |
		dumped := SpurDumpedMemory on: reader.
		self
			assert: (self patchEvenIn: dumped through: reader)
			description: 'the machine had not compiled that method, so this proves nothing'.
		self askTheHeldImageTo: '(SmallInteger >> #even) voidCogVMState'.
		reader
			storeWord: 1 * 8 + 1
			at: (self excessSignalsOfTheInterruptSemaphoreIn: dumped raw) ].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self
		assert: (self waitFor: [ (LinuxProcessMemory unchecked: pid) isQuiet ])
		description: 'it went on running away'.
	self assert: (LinuxProcessMemory unchecked: pid) exists description: 'it did not survive' ]
		ensure: [
			LibC system: 'kill -9 ' , pid printString.
			reader ifNotNil: [ reader close ] ]
