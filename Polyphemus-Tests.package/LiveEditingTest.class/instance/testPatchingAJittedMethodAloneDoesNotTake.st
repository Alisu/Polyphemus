tests
testPatchingAJittedMethodAloneDoesNotTake

	"Why a wedged image is the hard case: the method it is stuck in is the one the machine has
	compiled, and machine code is what runs. The bytecodes are patched here and the image goes
	on answering as before -- which is the thing to fix, not to hide."

	| pid reader |
	pid := self launchWarmedSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	self holdWithTheInterrupt: reader.

	reader whileStopped: [
		| dumped |
		dumped := SpurDumpedMemory on: reader.
		self
			assert: (self patchEvenIn: dumped through: reader)
			description: 'the machine had not compiled that method, so this proves nothing'.
		self letGo: reader heap: dumped raw ].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self assert: (self spikeDirectory / 'answer') contents trimBoth equals: 'true' ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
