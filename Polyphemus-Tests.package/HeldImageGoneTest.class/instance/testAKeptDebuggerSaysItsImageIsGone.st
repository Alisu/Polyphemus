tests
testAKeptDebuggerSaysItsImageIsGone

	"#142: kept open on its last reading, the debugger says in its title that the image is gone,
	for as long as it stays open."

	| debugger |
	debugger := DebuggerDouble titled: 'Counter>>tick:'.
	self gone tellAbout: debugger with: (UIManagerDouble answering: false).
	self deny: debugger isClosed.
	self assert: debugger title equals: '[Image gone] Counter>>tick:'
