tests
testItHoldsAWedgedImageStillAndThenLetsItGo

	"#24 whole: a wedged image is interrupted from outside, holds without yielding while its
	heap is read entire, and goes back to running when the word it watches changes -- one
	signal nobody has taken, written into the semaphore from here. Untouched, it still says
	four is even, which is what makes the patching test mean something."

	| pid reader |
	pid := self launchSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	reader whileStopped: [
		reader storeWord: 1 at: ((VMVariables on: reader) addressOf: 'interruptPending') ].
	self
		assert: (self waitFor: [ (self spikeDirectory / 'interrupted') exists ])
		description: 'it never took the interrupt'.

	reader whileStopped: [
		| raw |
		raw := (SpurDumpedMemory on: reader) raw.
		self assert: raw heapWalk objectCount > 100000.
		self assert: raw readability refusals asArray equals: #(  ).
		self assert: raw freeListsAreIntact.
		reader
			storeWord: 1 * 8 + 1
			at: (self excessSignalsOfTheInterruptSemaphoreIn: raw) ].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self assert: (self spikeDirectory / 'answer') contents trimBoth equals: 'true'.
	self
		assert: (self waitFor: [ (LinuxProcessMemory unchecked: pid) isQuiet not ])
		description: 'it never went back to running' ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		reader ifNotNil: [ reader close ] ]
