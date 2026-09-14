contexts
sourceOfContext: aContextOop

	"The source of the method a context is running, read from the target image's own
	.sources file. A block borrows the source of its home method; a method whose
	source is not available answers nil rather than raising."

	^ [ (self homeMethodOf: (aContextOop reifiedSlotAt: self contextMethodSlot))
		    sourceCode ]
		  on: Error
		  do: [ :e | nil ]
