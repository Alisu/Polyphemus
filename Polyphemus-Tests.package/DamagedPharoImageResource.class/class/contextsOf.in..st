building
contextsOf: aDescription in: aReading

	"The stack, as contexts, of the process whose newest context is described so."

	^ aReading contextsOfProcess: (self process: aDescription in: aReading)
