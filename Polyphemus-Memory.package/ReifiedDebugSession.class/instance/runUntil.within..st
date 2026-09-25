stepping
runUntil: aMethodSource within: aDuration

	"Let the held image run until some process reaches that method, and show it there. Answers
	whether it was reached; if not, the image is held where it got to."

	| reached |
	image ifNil: [ ^ self error: 'this stack is only read: nothing here runs' ].
	reached := image runUntil: aMethodSource within: aDuration.
	held := image process.
	self
		updateContextTo: held context;
		triggerEvent: #stepOver.
	^ reached
