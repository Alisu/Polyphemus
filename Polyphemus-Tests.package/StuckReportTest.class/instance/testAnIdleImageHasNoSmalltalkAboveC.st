tests
testAnIdleImageHasNoSmalltalkAboveC

	"#18: waiting for events is not a C call; the report names nothing above it, nor a debugger."

	| pid report |
	pid := self launchObservableTarget.
	[
	self idleReportOf: pid.
	report := Polyphemus whereIsStuck: pid reading: (Polyphemus readProcess: pid).

	self deny: report mainThread isInACCall.
	self assert: report smalltalkAboveC isNil.
	self deny: (report printString includesSubstring: 'gdb') ] ensure: [
		LibC system: 'kill ' , pid printString ]
