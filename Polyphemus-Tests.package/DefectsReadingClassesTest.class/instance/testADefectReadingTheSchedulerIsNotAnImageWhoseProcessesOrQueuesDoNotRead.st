tests
testADefectReadingTheSchedulerIsNotAnImageWhoseProcessesOrQueuesDoNotRead

	"#118: where the running process, the scheduler's lists or one of its queues does not read,
	the reports of processes say so. A bug of our own reading each is not that: the scheduler,
	then a queue, answers its other slots as it does."

	| memory processes scheduler queue failingAt |
	memory := self memory.
	processes := memory processes.
	scheduler := processes reifiedScheduler.
	queue := (processes reifiedProcessLists detect: [ :each | (processes processesInList: each) notEmpty ]).
	failingAt := [ :object :slot |
	             (DefectiveReadDouble of: object) when: #reifiedSlotAt: answer: [ :index |
		             index = slot
			             ifTrue: [ 1 / 0 ]
			             ifFalse: [ object reifiedSlotAt: index ] ] ].
	{ (scheduler -> processes activeProcessSlot). (scheduler -> processes processListsSlot). (queue -> processes listFirstLinkSlot) } do: [ :each |
		memory objectAt: each key address put: (failingAt value: each key value: each value).
		[
		self should: [ memory processInconsistencies ] raise: ZeroDivide.
		each key == scheduler ifTrue: [ self should: [ memory processStates ] raise: ZeroDivide ] ] ensure: [
			memory objectAt: each key address put: each key ] ]
