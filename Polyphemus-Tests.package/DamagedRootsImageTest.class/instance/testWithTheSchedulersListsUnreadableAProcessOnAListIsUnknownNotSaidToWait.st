tests
testWithTheSchedulersListsUnreadableAProcessOnAListIsUnknownNotSaidToWait

	"#118: runnable is told from waiting by the scheduler's lists. With those unreadable, the three
	runnable processes of this image were said to wait, as the four that do."

	| states |
	states := reifiedMemory processStates.

	self should: [ reifiedMemory processes reifiedProcessLists ] raise: NotInTheReading.
	self assert: reifiedMemory allReifiedProcesses size equals: 8.
	self assert: (states values count: [ :each | each = #active ]) equals: 1.
	self assert: (states values count: [ :each | each = #unknown ]) equals: 7.
	self assert: reifiedMemory processInconsistencies notEmpty
