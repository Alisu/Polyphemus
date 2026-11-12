tests
testAnAssignmentInAHeldFrameTakesAndTheDebuggerShowsIt

	"An assignment evaluated in a frame of a held image changes that frame there; the debugger then
	shows it, and let go, the image counts by it. Stepped over, step is not yet pushed for + (#126)."

	| pid session debugger |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	| step |
	step := 1.
	n printString.
	^ n + step' from: 0 after: (self writing: 'n' as: 'n')).
	[
	session := self heldAtTickOf: pid.
	debugger := PolyphemusTestCase inUIProcess: [ StDebugger openOn: session withFullView: true ].
	[
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: debugger ].
	PolyphemusTestCase inUIProcess: [ (PolyphemusTestCase actionModelOf: debugger) stepOver: session interruptedContext ].
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: debugger ].
	PolyphemusTestCase inUIProcess: [ debugger code evaluate: 'step := 5000' onCompileError: [ nil ] onError: [ :error | error signal ] ].
	self assert: (session interruptedContext tempNamed: #step) printString equals: '5000'.
	PolyphemusTestCase inUIProcess: [ (PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ] ] ensure: [
		PolyphemusTestCase closeWindowOf: debugger ].
	self
		assert: (self waitFor: [ ((self valueIn: 'n') ifNil: [ 0 ]) >= 5000 ])
		description: 'let go, it did not count from the assigned step' ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
