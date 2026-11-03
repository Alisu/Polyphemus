tests
testAKeptDebuggerSaysItsImageIsGone

	"#142: kept open on its last reading, the debugger says in its title that the image is gone,
	for as long as it stays open: a mark of the debugger's, which Pharo's next title keeps (#151)."

	| debugger |
	debugger := DebuggerDouble titled: 'Counter>>tick:'.
	self gone tellAbout: debugger with: (UIManagerDouble answering: false).
	self deny: debugger isClosed.
	self assert: debugger marks asArray equals: #( 'Image gone' ).
	self assert: debugger title equals: '[Image gone] Counter>>tick:'
