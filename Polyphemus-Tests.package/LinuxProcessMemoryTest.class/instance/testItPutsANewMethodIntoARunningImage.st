tests
testItPutsANewMethodIntoARunningImage

	"A method the class never had, made in an image that is running: in its eden, where the
	machine allocates too, with the dictionary that now points at it remembered. The image is
	asked to collect its garbage before answering, so a pointer the collector could lose
	would be lost."

	| pid reader selector |
	pid := self launchSpinningTarget.
	[
	reader := LinuxProcessMemory on: pid.
	self holdWithTheInterrupt: reader.
	reader whileStopped: [
		| dumped reading integer |
		dumped := SpurDumpedMemory on: reader.
		reading := dumped reifiedMemory.
		integer := reading oopClassNamed: 'Integer'.
		selector := self aSelectorIntegersDoNotUnderstandIn: reading.
		(SpurProcessInstall on: reader reading: reading)
			install: (reading compileHostSource: selector asString , ' ^ 42' for: integer) first
			under: selector address
			in: integer.
		self askTheHeldImageTo: (self scriptAsking: selector asString).
		reader
			storeWord: 1 * 8 + 1
			at: (self excessSignalsOfTheInterruptSemaphoreIn: dumped raw) ].

	self
		assert: (self waitFor: [ (self spikeDirectory / 'released') exists ])
		description: 'it never let go'.
	self deny: (self spikeDirectory / 'do-failed') exists description: 'the image refused what we asked'.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'live-answer') exists ])
		description: 'the image never answered with the new method'.
	self assert: (self spikeDirectory / 'live-answer') contents trimBoth equals: '42'.
	self assert: (LinuxProcessMemory unchecked: pid) exists description: 'it did not survive' ]
		ensure: [
			LibC system: 'kill -9 ' , pid printString.
			reader ifNotNil: [ reader close ] ]
