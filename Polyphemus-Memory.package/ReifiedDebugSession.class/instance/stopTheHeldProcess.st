stepping
stopTheHeldProcess

	"End the process held, its ensure blocks run, as Pharo's debugger ends one of its own when
	closed; then let the image go, which runs on without it (#125)."

	held ifNil: [ ^ self error: 'this stack is only read: there is no process to stop' ].
	held stop.
	^ self letTheImageGo
