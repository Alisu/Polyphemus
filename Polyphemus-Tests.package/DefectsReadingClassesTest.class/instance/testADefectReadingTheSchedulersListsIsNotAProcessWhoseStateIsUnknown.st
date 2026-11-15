tests
testADefectReadingTheSchedulersListsIsNotAProcessWhoseStateIsUnknown

	"#118: a process on a list is #unknown where the scheduler's lists do not read. A bug of our
	own reading them is not that: the scheduler answers its other slots as it does."

	| memory scheduler lists |
	memory := self memory.
	scheduler := memory processes reifiedScheduler.
	lists := memory processes processListsSlot.
	memory objectAt: scheduler address put: ((DefectiveReadDouble of: scheduler) when: #reifiedSlotAt: answer: [ :index |
			 index = lists
				 ifTrue: [ 1 / 0 ]
				 ifFalse: [ scheduler reifiedSlotAt: index ] ]).
	[ self should: [ memory processStates ] raise: ZeroDivide ] ensure: [ memory objectAt: scheduler address put: scheduler ]
