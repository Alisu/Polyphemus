querying
pc

	"Where in its method this frame is, as a context's pc, using the VM's own conversion. nil
	when it keeps none, or for a JIT frame whose layout cannot map it; refused by name where its
	method or its pointer does not read as one."

	| ip |
	(self isMachineCodeFrame and: [ self readsMachineCodePC not ]) ifTrue: [ ^ nil ].
	ip := self instructionPointer.
	ip ifNil: [ ^ nil ].
	^ self layout contextPCOf: ip frame: framePointer
