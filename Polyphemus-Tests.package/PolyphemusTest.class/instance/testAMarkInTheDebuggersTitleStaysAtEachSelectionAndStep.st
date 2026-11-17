tests
testAMarkInTheDebuggersTitleStaysAtEachSelectionAndStep

	"#151: Pharo writes the debugger's title anew at each frame selected and each step; what a
	session on a reading has to say stays in front of it until the debugger closes."

	| memory session debugger |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	session := Polyphemus sessionOnDeepestProcessIn: memory.
	session mark: 'Said by the test'.
	[
	debugger := PolyphemusTestCase inUIProcess: [ StDebugger openOn: session withFullView: true ].
	PolyphemusTestCase inUIProcess: [ PolyphemusTestCase drawWindowOf: debugger ].
	self assert: (debugger window title beginsWith: '[Said by the test] ').
	PolyphemusTestCase inUIProcess: [ debugger stackTable selectIndex: 2 ].
	self assert: (debugger window title beginsWith: '[Said by the test] ').
	PolyphemusTestCase inUIProcess: [ debugger updateWindowTitle ].
	self assert: (debugger window title beginsWith: '[Said by the test] ').
	self deny: ((debugger window title allButFirst: 19) includesSubstring: '[Said by the test]') ] ensure: [
		debugger ifNotNil: [ PolyphemusTestCase closeWindowOf: debugger ] ]
