tests
testTheFrontDoorReadsABusyProcessWhenQuietOrRefusesAndSaysWhy

	"As on Linux (#66): a busy VM is read at a quiet moment (it polls for events between
	bytecodes) or, if none comes, refused by name. Nothing else."

	| pid |
	MacProcessMemory isRoot ifFalse: [ ^ self skip: 'reading another process on macOS needs the observer run as root (sudo)' ].
	pid := self launchSpinningTarget.
	[
	[ self assert: (Polyphemus readProcess: pid) allReifiedProcesses notEmpty ]
		on: SpurCannotRead
		do: [ :refusal | self assert: refusal reason equals: #itWasNeverQuietWhenStopped ] ]
		ensure: [ LibC system: 'kill ' , pid printString ]
