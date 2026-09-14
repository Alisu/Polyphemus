contexts
sourceOfContext: anActivation

	"The source of the method an activation is running, read from the target image's own
	.sources file. A block borrows the source of its home method; a method whose source is
	not available answers nil rather than raising.

	Asked of the activation rather than read out of its slots, so that a frame answers it
	as well as a context: they are the same activation in two forms, and only one of them
	has slots to read."

	^ [ (self homeMethodOf: anActivation compiledCode) sourceCode ]
		  on: Error
		  do: [ :e | nil ]
