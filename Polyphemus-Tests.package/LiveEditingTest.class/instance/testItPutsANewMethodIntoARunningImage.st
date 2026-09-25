tests
testItPutsANewMethodIntoARunningImage

	"A method the class never had, made in a running image: in its eden, where the machine
	allocates too, with the dictionary now pointing at it remembered. It is asked to collect
	before answering, so a pointer nothing remembered would be gone."

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
		(SpurMethodInstall on: reading into: (SpurWritableProcess on: reader))
			install: (reading compileHostSource: selector asString , ' ^ 42' for: integer) first
			under: selector address
			in: integer.
		self askTheHeldImageTo: (self scriptAsking: selector asString).
		self letGo: reader heap: dumped raw ].

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
