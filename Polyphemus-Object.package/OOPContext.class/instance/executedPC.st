context protocol
executedPC

	"The bytecode it is executing, as Pharo's Context answers: one before its pc, where a method
	records each instruction at its last byte; its start at the start; before its end when dead."

	self pc ifNil: [ ^ self endPC - 1 ].
	self pc = self startpc ifTrue: [ ^ self startpc ].
	^ self pc - 1