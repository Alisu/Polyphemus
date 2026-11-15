tests
testAQueueOfTheSchedulerThatIsATaggedWordIsReportedAndTheOthersStillTellWhoIsRunnable

	"#118: one of the scheduler's eighty lists is a tagged word. It is reported as a queue that
	does not read, and the three runnable processes, queued on the others, are still said so."

	| problems |
	problems := reifiedMemory processInconsistencies.

	self assert: (problems count: [ :each | each value = #queueIsUnreadable ]) equals: 1.
	self assert: (problems detect: [ :each | each value = #queueIsUnreadable ]) key isImmediateOop.
	self assert: (reifiedMemory processStates values count: [ :each | each = #runnable ]) equals: 3
