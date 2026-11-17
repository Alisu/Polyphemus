stepping
stepInto: aContext

	"The image steps the frame selected in the debugger, which is the one it is at or one
	below, and the debugger is shown what memory holds afterwards."

	held ifNil: [ ^ super stepInto: aContext ].
	held step: 'stepInto:' below: (self depthOf: aContext).
	self
		updateContextTo: held context;
		triggerEvent: #stepInto
