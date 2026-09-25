stepping
stepInto: aContext

	"The image steps its own top context, and the debugger is shown what memory holds
	afterwards."

	held ifNil: [ ^ super stepInto: aContext ].
	held stepInto.
	self
		updateContextTo: held topContext;
		triggerEvent: #stepInto
