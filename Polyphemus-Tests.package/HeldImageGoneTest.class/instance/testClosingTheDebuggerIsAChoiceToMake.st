tests
testClosingTheDebuggerIsAChoiceToMake

	"#142: a question that waits for its answer, not a message that fades; answered Close, the
	debugger reading the gone image closes."

	| debugger asked |
	debugger := DebuggerDouble titled: 'Counter>>tick:'.
	[ self gone tellAbout: debugger ]
		on: ProvideAnswerNotification
		do: [ :question | asked := question messageText. question resume: true ].
	self assert: (asked includesSubstring: 'gone').
	self assert: debugger isClosed
