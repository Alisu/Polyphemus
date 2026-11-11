stepping
stopTheHeldProcess

	"End the process held, its ensure blocks run, as Pharo's debugger ends one of its own when
	closed; then let the image go, whatever ending it did, which runs on without it (#125, #170)."

	| letGo |
	held ifNil: [ ^ OnlyRead signal: 'this stack is only read: there is no process to stop' ].
	[ held stop ] ensure: [ letGo := self letTheImageGo ].
	^ letGo
