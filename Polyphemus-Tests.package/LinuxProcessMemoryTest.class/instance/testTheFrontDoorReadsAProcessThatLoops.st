tests
testTheFrontDoorReadsAProcessThatLoops

	"#113: a VM running a loop is never quiet; it is read at a moment outside a collection, its
	classes and special objects reading whole, where it was refused (#66)."

	| pid |
	pid := self launchSpinningTarget.
	[ self assert: (Polyphemus readProcess: pid) allReifiedProcesses notEmpty ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
