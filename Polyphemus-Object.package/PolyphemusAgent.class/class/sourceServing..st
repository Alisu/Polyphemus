source
sourceServing: aDirectory

	"The agent as a held image runs it: its bell is the interrupt semaphore, whose third slot
	we write after each request, as we do to release the hold."

	^ self sourceServing: aDirectory bell: 'Smalltalk specialObjectsArray at: 31'
