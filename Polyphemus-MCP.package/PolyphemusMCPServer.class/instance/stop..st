tools
stop: someArguments

	"End the held process, its ensure blocks run, and let the image go, which runs on without
	it; the handle is forgotten (#125)."

	| session |
	session := self sessionAt: someArguments.
	self images removeKey: (someArguments at: 'handle').
	session stopTheHeldProcess.
	^ self
		  text: 'Stopped: the process held is ended, and the image runs on without it.'
		  structured: (Dictionary new at: 'handle' put: (someArguments at: 'handle'); yourself)
