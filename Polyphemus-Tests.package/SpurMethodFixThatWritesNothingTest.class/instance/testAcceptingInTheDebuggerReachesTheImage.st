tests
testAcceptingInTheDebuggerReachesTheImage

	"The call Pharo's debugger makes when its code pane is accepted, with a context from the
	stack the debugger would be showing. Accepting a method's own source writes it back where
	it already was, which is the path proving itself."

	| context session |
	context := (reading contextsOfProcess: (Polyphemus deepestProcessIn: reading)) first.
	session := ReifiedDebugSession
		           named: 'Polyphemus'
		           on: nil
		           startedAt: context
		           fixing: self fix.

	self assert: (session
			 fixMethodOf: context
			 to: context homeMethod getSourceFromFile
			 notifying: nil)
