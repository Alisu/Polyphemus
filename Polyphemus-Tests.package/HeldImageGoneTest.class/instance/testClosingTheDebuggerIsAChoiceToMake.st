tests
testClosingTheDebuggerIsAChoiceToMake

	"#142: a question that waits for its answer, not a message that fades; answered Close, the
	debugger reading the gone image closes."

	| debugger ui |
	debugger := DebuggerDouble titled: 'Counter>>tick:'.
	ui := UIManagerDouble answering: true.
	self gone tellAbout: debugger with: ui.
	self assert: (ui questions first includesSubstring: 'gone').
	self assert: debugger isClosed
