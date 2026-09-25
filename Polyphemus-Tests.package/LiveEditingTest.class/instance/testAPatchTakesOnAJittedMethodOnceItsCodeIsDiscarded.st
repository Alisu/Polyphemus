tests
testAPatchTakesOnAJittedMethodOnceItsCodeIsDiscarded

	"And the fix: voidCogVMState, primitive 215, discards the machine code a method has.
	flushCache was measured not to, though why is not established -- see editing-an-image.md.
	Asked for it while held, the image answers the new bytecodes once it is let go."

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
		self askTheHeldImageTo: '(SmallInteger >> #even) voidCogVMState'.
		self letGo: reader heap: dumped raw ].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self deny: (self spikeDirectory / 'do-failed') exists description: 'the image refused what we asked'.
	self assert: (self spikeDirectory / 'answer') contents trimBoth equals: 'false' ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
