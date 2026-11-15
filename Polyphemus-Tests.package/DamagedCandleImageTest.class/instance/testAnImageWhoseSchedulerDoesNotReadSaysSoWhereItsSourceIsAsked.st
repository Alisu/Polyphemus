tests
testAnImageWhoseSchedulerDoesNotReadSaysSoWhereItsSourceIsAsked

	"#118: source is checked on the methods the processes were running. With the scheduler
	unreadable in the file there are none to ask, which was taken for nothing to check: said by
	name, on a host with the sources file or without."

	| memory |
	memory := DamagedCandleImage readingWith: [ :clean |
		          { ((self slot: clean processes schedulerAssociationSlot of: clean reifiedSpecialObjectArray) -> 16r29) } ].

	self should: [ memory allReifiedProcesses ] raise: NotInTheReading.
	self assert: (SourceReadability of: memory) checkSource equals: #itsRunningMethodsDoNotRead.
	self deny: (memory sourceReadability canRead: #source)
