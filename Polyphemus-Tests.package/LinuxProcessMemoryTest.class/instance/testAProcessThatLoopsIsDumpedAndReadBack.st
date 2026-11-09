tests
testAProcessThatLoopsIsDumpedAndReadBack

	"#113: dumped as it is read, at a moment outside a collection, and read back as a core."

	| pid core |
	pid := self launchSpinningTarget.
	core := self spikeDirectory / 'looping.core'.
	[
	Polyphemus dumpProcess: pid to: core fullName.
	self assert: (Polyphemus readCoreDump: core fullName) allReifiedProcesses notEmpty ] ensure: [
		LibC system: 'kill -9 ' , pid printString.
		core ensureDelete ]
