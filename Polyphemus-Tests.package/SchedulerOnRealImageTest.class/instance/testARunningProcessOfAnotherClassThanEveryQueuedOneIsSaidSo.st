tests
testARunningProcessOfAnotherClassThanEveryQueuedOneIsSaidSo

	"#118: the scheduler's running process overwritten with the scheduler's own address, and put
	back. The processes are found by the class of the running one, so that class's instances were
	listed as the processes, unremarked. The queues know better: the report says the two disagree."

	| scheduler slot before problems |
	scheduler := reifiedMemory processes reifiedScheduler.
	slot := reifiedMemory processes activeProcessSlot - 1.
	self deny: (reifiedMemory processInconsistencies anySatisfy: [ :each |
			 each value = #theRunningProcessIsOfAnotherClassThanEveryQueuedOne ]).
	before := memory fetchPointer: slot ofObject: scheduler address.
	memory storePointerUnchecked: slot ofObject: scheduler address withValue: scheduler address.
	reifiedMemory forgetWhatWasRead.
	problems := [ reifiedMemory processInconsistencies ] ensure: [
		            memory storePointerUnchecked: slot ofObject: scheduler address withValue: before.
		            reifiedMemory forgetWhatWasRead ].
	self assert: (problems anySatisfy: [ :each |
			 each value = #theRunningProcessIsOfAnotherClassThanEveryQueuedOne and: [ each key address = scheduler address ] ])
