tests
testDebugOpensPharosDebuggerOnTheProcessSelected

	"#138: Pharo's debugger, post mortem, on the stack of the process selected."

	| process debugger |
	process := Polyphemus deepestProcessIn: memory.
	browser selectProcess: process.
	debugger := browser debugSelectedProcess.
	[
	self assert: debugger session interruptedContext equals: (memory contextsOfProcess: process) first.
	self assert: debugger session heldProcess isNil ] ensure: [ debugger window ifNotNil: [ :window | window close ] ]
