tools
stop: someArguments

	"End the held process, its ensure blocks run, and let the image go, which runs on without
	it; the handle is forgotten (#125)."

	^ self
		  endTheHoldOf: someArguments
		  by: [ :session | session stopTheHeldProcess ]
		  saying: 'Stopped: the process held is ended, and the image runs on without it.'
