querying
pc

	"Where in its method this frame is, as a context's pc, using the VM's own conversion. nil
	when unavailable or for a JIT frame."

	| ip |
	self isMachineCodeFrame ifTrue: [ ^ nil ].
	ip := self instructionPointer.
	ip ifNil: [ ^ nil ].
	^ [ self layout contextPCOf: ip frame: framePointer ] on: Error do: [ :e | nil ]
