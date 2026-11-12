tests
testPrintItInTheDebuggerOfAHeldImageSaysWhatTheImageAnswers

	"Code evaluated in the debugger of a held image, as Do it, Print it and Inspect it do, runs in
	the image's frame: it answers what the image printed (#126)."

	| pid session debugger result |
	pid := self launchCounter.
	[
	session := self heldAtTickOf: pid.
	debugger := PolyphemusTestCase inUIProcess: [ StDebugger openOn: session withFullView: true ].
	[
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: debugger ].
	result := PolyphemusTestCase inUIProcess: [ debugger code evaluate: '{ self class name. n class name }' onCompileError: [ nil ] onError: [ :error | error ] ].
	self assert: (result isKindOf: HeldEvaluation).
	self assert: result printString equals: '#(#Counter #SmallInteger)' ] ensure: [
		PolyphemusTestCase closeWindowOf: debugger ].
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
