tests
testPrintItInTheDebuggerOfAHeldImageSaysWhatTheImageAnswers

	"Code evaluated in the debugger of a held image, as Do it, Print it and Inspect it do, runs in
	the image's frame: it answers what the image printed (#126)."

	| pid session debugger result |
	pid := self launchCounter.
	[
	session := self heldAtTickOf: pid.
	debugger := StDebugger openOn: session withFullView: true.
	[
	PolyphemusTestCase drawWindowOf: debugger.
	result := debugger code evaluate: '{ self class name. n class name }' onCompileError: [ nil ] onError: [ :error | error ].
	self assert: (result isKindOf: HeldEvaluation).
	self assert: result printString equals: '#(#Counter #SmallInteger)' ] ensure: [
		debugger window ifNotNil: [ :window | window close ] ].
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
