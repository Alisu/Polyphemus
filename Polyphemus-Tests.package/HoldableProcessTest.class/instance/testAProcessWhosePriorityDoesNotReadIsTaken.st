tests
testAProcessWhosePriorityDoesNotReadIsTaken

	"No priority read, nothing against it: one stop."

	| image |
	image := self imageCatching: #( nil ).
	self assert: (image whileStoppedOnAProcessItCanHold: [ #held ]) equals: #held.
	self assert: image stops equals: 1
