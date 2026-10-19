tests
testPharosDebuggerWindowOpensAndDrawsOnTheDeepestStack

	"Its window, not only its parts, at each frame: the code pane colours the method, asking our
	context for its method's class and that class for a highlighter (#89). Drawn here, so a
	failure fails the test rather than the UI process; closed whatever happens."

	| memory debugger |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	[
	debugger := StDebugger openOn: (Polyphemus sessionOnDeepestProcessIn: memory) withFullView: true.
	PolyphemusTestCase drawEachFrameOf: debugger ] ensure: [ debugger ifNotNil: [ debugger window ifNotNil: [ :window | window close ] ] ]
