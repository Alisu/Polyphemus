tests
testTheFrontDoorReadsAnIdleProcess

	"#66: Polyphemus readProcess: had no test."

	| pid memory |
	pid := self launchObservableTarget.
	[
	memory := Polyphemus readProcess: pid.
	self assert: memory allReifiedProcesses notEmpty ] ensure: [
		LibC system: 'kill ' , pid printString ]
