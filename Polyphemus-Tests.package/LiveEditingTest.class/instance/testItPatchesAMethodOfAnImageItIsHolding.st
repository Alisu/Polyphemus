tests
testItPatchesAMethodOfAnImageItIsHolding

	"Where #24 and #25 meet: a wedged image is held, one of its methods is recompiled here and
	written into it, and once let go it answers the new code. SmallInteger>>even is made odd,
	so four is no longer even -- and the image says so itself, after we have gone."

	| pid reader |
	pid := self launchSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	self holdWithTheInterrupt: reader.

	reader whileStopped: [
		| dumped |
		dumped := SpurDumpedMemory on: reader.
		self makeEvenOdd: dumped through: reader.
		self letGo: reader heap: dumped raw ].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self assert: (self spikeDirectory / 'answer') contents trimBoth equals: 'false' ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
