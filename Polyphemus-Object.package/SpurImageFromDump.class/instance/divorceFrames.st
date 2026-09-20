writing
divorceFrames

	"An image holds no stack pages, so every frame becomes a context, as
	StackInterpreter>>divorceAllFrames does at snapshot. A dump's frames are not on the
	simulator's pages, so they are built here. Answers how many."

	| divorced |
	self aContextOfThisMemory.
	divorced := 0.
	self reified allReifiedProcesses do: [ :process |
		divorced := divorced + (self divorceStackOf: process) ].
	self bereaveWidowedContexts.
	^ divorced
