querying
stackp

	"How many slots of this frame's stack are in use, as a context counts them; nil when
	its stack pointer is not known. Refused for a JIT frame."

	self isMachineCodeFrame ifTrue: [ self signalMachineCode ].
	^ [ self layout stackpOf: self ] on: Error do: [ :e | nil ]
