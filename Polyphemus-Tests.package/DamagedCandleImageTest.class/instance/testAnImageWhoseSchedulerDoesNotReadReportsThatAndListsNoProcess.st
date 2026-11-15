tests
testAnImageWhoseSchedulerDoesNotReadReportsThatAndListsNoProcess

	"#118: the processes are found through the scheduler. With it unreadable in the file, the
	reports of processes raised, one of them saying it never does. They answer: no state, one
	problem saying the running process does not read, and nothing of contexts."

	| memory problems |
	memory := DamagedCandleImage readingWith: [ :clean |
		          { ((self slot: clean processes schedulerAssociationSlot of: clean reifiedSpecialObjectArray) -> 16r29) } ].
	problems := memory processInconsistencies.

	self should: [ memory allReifiedProcesses ] raise: NotInTheReading.
	self assert: memory processStates isEmpty.
	self assert: problems size equals: 1.
	self assert: problems first value equals: #theRunningProcessDoesNotRead.
	self assert: memory stacks contextInconsistencies isEmpty
