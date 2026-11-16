scheduler
isProcess: aProcess ofAnotherClassThanEvery: someQueuedProcesses

	"Whether the queues hold processes and none is of that one's class: a running-process slot
	pointing at some other object, whose class's instances are then listed as the processes."

	^ someQueuedProcesses notEmpty and: [
		  someQueuedProcesses noneSatisfy: [ :each |
			  (each isKindOf: OOPAbstractObject) and: [ each oopClassTag = aProcess oopClassTag ] ] ]
