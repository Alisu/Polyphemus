stepping
stepThrough: aContext

	"The image steps where its own debugger is, through, and the debugger is shown what memory
	holds afterwards."

	held ifNil: [ ^ super stepThrough: aContext ].
	held stepThrough.
	self
		updateContextTo: held context;
		triggerEvent: #stepThrough
