tests
testQueuedProcessesPointBackAtTheirQueue

	"Every process found in a scheduler queue must say so itself: myList is the queue
	it sits in. A process where the two disagree is a corrupt one, which is exactly
	what stage one has to be able to report."

	reifiedMemory processes reifiedProcessLists do: [ :list |
		(reifiedMemory processes processesInList: list) do: [ :process |
			self
				assert: (process reifiedSlotAt: reifiedMemory processes processMyListSlot)
				equals: list ] ]
