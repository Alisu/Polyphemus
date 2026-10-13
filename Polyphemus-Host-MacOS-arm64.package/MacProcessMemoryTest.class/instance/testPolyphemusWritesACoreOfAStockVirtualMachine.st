tests
testPolyphemusWritesACoreOfAStockVirtualMachine

	"Through the front door, as on Linux: written while held still, read back with its processes."

	| pid file reified |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchIdleTarget.
	file := PolyphemusEdition current scratch / 'polyphemus-mac-stock.core'.
	[
	Polyphemus dumpProcess: pid to: file fullName.
	reified := Polyphemus readCoreDump: file fullName.
	self assert: reified allReifiedProcesses notEmpty ] ensure: [
		LibC system: 'kill ' , pid printString.
		file ensureDelete ]
