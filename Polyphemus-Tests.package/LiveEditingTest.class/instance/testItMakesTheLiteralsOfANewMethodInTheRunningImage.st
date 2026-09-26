tests
testItMakesTheLiteralsOfANewMethodInTheRunningImage

	"What a new method names goes where the method goes: a string made in eden, as the machine
	makes one. The image collects its garbage before answering, so a young object nothing
	remembered would be gone by then -- and the answer is ten and thirty-two."

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
			install: (reading
					 compileHostSource: selector asString , ' ^ ''polyphemus'' size + 32'
					 for: integer) first
			under: selector address
			in: integer.
		self askTheHeldImageTo: (self scriptAsking: selector asString).
		self letGo: reader].

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
