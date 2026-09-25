stepping
stepThrough: aContext

	"The image steps its own top context through, and the debugger is shown what memory holds
	afterwards."

	held ifNil: [ ^ super stepThrough: aContext ].
	held stepThrough.
	self
		updateContextTo: held topContext;
		triggerEvent: #stepThrough
