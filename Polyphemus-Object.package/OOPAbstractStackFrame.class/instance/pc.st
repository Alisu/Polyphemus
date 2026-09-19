querying
pc

	"Where in its method this frame is, as a context's pc, using the VM's own conversion. nil
	when unavailable or for a JIT frame."

	| ip |
	self isReadable ifFalse: [ ^ nil ].
	ip := self instructionPointer.
	ip ifNil: [ ^ nil ].
	^ [
	  memory integerValueOf:
		  (memory interpreter contextInstructionPointer: ip frame: framePointer) ]
		  on: Error
		  do: [ :e | nil ]
