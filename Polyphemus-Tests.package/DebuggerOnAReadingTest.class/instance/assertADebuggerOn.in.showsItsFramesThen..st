helpers
assertADebuggerOn: aName in: aReading showsItsFramesThen: aBlock

	"Open on that process, draw each frame (selected, its code coloured, its variables shown), and
	check the stack shown is the stack read."

	| frames debugger |
	frames := aReading activationsOfProcess: (Polyphemus processNamed: aName in: aReading).
	self assert: frames size > 1.
	debugger := Polyphemus debugProcessNamed: aName in: aReading.
	[
	PolyphemusTestCase drawEachFrameOf: debugger.
	self assert: debugger stackTable items size equals: frames size.
	aBlock value: debugger ] ensure: [ debugger window ifNotNil: [ :window | window close ] ]
