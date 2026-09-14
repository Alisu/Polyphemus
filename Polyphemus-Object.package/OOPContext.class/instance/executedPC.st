context protocol
executedPC

	self pc ifNil: [ ^ self endPC ].
	self pc = self startpc ifTrue: [ ^ self startpc ].
	^ self pc - 1
