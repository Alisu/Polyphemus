tests
testTheFrontDoorReadsAProcessThatLoops

	"As on Linux (#113): a busy VM is read at a moment outside a collection when no quiet one comes."

	| pid |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchSpinningTarget.
	[ self assert: (Polyphemus readProcess: pid) allReifiedProcesses notEmpty ] ensure: [
		LibC system: 'kill ' , pid printString ]
