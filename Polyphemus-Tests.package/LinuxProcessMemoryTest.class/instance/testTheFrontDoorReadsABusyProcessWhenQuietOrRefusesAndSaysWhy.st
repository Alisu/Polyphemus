tests
testTheFrontDoorReadsABusyProcessWhenQuietOrRefusesAndSaysWhy

	"#66: stopped at any moment, a busy image was read half way through a change and failed on
	a nil. Now it is read at a quiet moment (its VM polls for events between bytecodes) or, if
	none comes, refused by name: hold it first (stage 3). Nothing else."

	| pid |
	pid := self launchSpinningTarget.
	[
	[ self assert: (Polyphemus readProcess: pid) allReifiedProcesses notEmpty ]
		on: SpurCannotRead
		do: [ :refusal | self assert: refusal reason equals: #itWasNeverQuietWhenStopped ] ]
		ensure: [ LibC system: 'kill -9 ' , pid printString ]
