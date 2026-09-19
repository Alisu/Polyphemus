reading
methodHeaderOf: aMethodOop

	"The header of a CompiledMethod or CompiledBlock: its first slot."

	^ memory fetchPointer: 0 ofObject: aMethodOop
