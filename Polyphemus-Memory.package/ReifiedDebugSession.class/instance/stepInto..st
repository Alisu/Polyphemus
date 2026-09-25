stepping
stepInto: aContext

	"The image steps where its own debugger is, and the debugger is shown what memory holds
	afterwards."

	held ifNil: [ ^ super stepInto: aContext ].
	held stepInto.
	self
		updateContextTo: held context;
		triggerEvent: #stepInto
