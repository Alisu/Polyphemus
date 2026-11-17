tests
testDebugOpensPharosDebuggerOnTheProcessSelected

	"#138: Pharo's debugger, post mortem, on the stack of the process selected. Opened and closed
	by the UI process, which draws the window while it is built otherwise (#31)."

	| process debugger |
	process := Polyphemus deepestProcessIn: memory.
	browser selectProcess: process.
	debugger := PolyphemusTestCase inUIProcess: [ browser debugSelectedProcess ].
	[
	self assert: debugger session interruptedContext equals: (memory contextsOfProcess: process) first.
	self assert: debugger session heldProcess isNil ] ensure: [ PolyphemusTestCase closeWindowOf: debugger ]
