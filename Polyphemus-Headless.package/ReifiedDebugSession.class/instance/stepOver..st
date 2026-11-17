stepping
stepOver: aContext

	"The image steps the frame selected in the debugger, which is the one it is at or one
	below, and the debugger is shown what memory holds afterwards."

	held ifNil: [ ^ super stepOver: aContext ].
	held step: 'stepOver:' below: (self depthOf: aContext).
	self
		updateContextTo: held context;
		triggerEvent: #stepOver
