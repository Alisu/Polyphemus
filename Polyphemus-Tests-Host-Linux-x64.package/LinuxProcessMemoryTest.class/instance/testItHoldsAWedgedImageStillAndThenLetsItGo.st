tests
testItHoldsAWedgedImageStillAndThenLetsItGo

	"#24 whole: a wedged image is interrupted, holds while its heap is read entire, and runs
	again when the word it watches changes. Untouched it still says four is even, which is
	what makes the patching test mean anything."

	| pid reader |
	pid := self launchSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	self holdWithTheInterrupt: reader.

	reader whileStopped: [
		| raw |
		raw := (SpurDumpedMemory on: reader) raw.
		self assert: raw heapWalk objectCount > 100000.
		self assert: raw readability refusals asArray equals: #(  ).
		self assert: raw freeListsAreIntact.
		self letGo: reader].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self assert: (self spikeDirectory / 'answer') contents trimBoth equals: 'true'.
	self
		assert: (self waitFor: [ (LinuxProcessMemory unchecked: pid) isQuiet not ])
		description: 'it never went back to running' ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
