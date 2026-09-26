stepping
stepThrough: aContext

	"The image steps, through the frame selected in the debugger, which is the one it is at or one
	below, and the debugger is shown what memory holds afterwards."

	held ifNil: [ ^ super stepThrough: aContext ].
	held step: 'stepThrough:' below: (self depthOf: aContext).
	self
		updateContextTo: held context;
		triggerEvent: #stepThrough
