tests
testAProcessAtTheWatchersPriorityIsNotTaken

	"At 70 the agent does not outrank it: it runs whenever the agent yields."

	| image |
	image := self imageCatching: #( 70 30 ).
	image whileStoppedOnAProcessItCanHold: [ nil ].
	self assert: image stops equals: 2
