tests
testEveryStackOfACleanImageEndsAtItsOldestActivation

	"No stack of a snapshot a working VM wrote is cut: none has a reason to give."

	reifiedMemory allReifiedProcesses do: [ :each |
		self assert: (reifiedMemory stacks whyTheStackEndsOfProcess: each) isNil ]
