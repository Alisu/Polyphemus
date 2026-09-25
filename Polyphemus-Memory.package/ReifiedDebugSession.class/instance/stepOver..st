stepping
stepOver: aContext

	"The image steps its own top context -- not a frame selected below it -- and the debugger
	is shown what memory holds afterwards."

	held ifNil: [ ^ super stepOver: aContext ].
	held stepOver.
	self
		updateContextTo: held topContext;
		triggerEvent: #stepOver
