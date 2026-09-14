querying
pc

	"Where in its method this frame is, in the form a context carries.

	The VM's own arithmetic, not ours: #contextInstructionPointer:frame: is what it uses to
	write a pc into a context when it divorces a frame, and it answers a tagged integer.
	Deriving it here instead -- the instruction pointer less the method's address -- gives
	206 where the VM says 200, and 206 lands on a different instruction of the same method.

	nil when this frame's instruction pointer is not available."

	| ip |
	ip := self instructionPointer.
	ip ifNil: [ ^ nil ].
	^ [
	  memory integerValueOf:
		  (memory interpreter contextInstructionPointer: ip frame: framePointer) ]
		  on: Error
		  do: [ :e | nil ]
