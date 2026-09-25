stepping
stepOver: aContext

	"The image steps where its own debugger is -- not a frame selected below it -- and the
	debugger is shown what memory holds afterwards."

	held ifNil: [ ^ super stepOver: aContext ].
	held stepOver.
	self
		updateContextTo: held context;
		triggerEvent: #stepOver
