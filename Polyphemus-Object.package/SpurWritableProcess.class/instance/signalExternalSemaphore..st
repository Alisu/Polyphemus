signalling
signalExternalSemaphore: anIndex

	"What the VM's signalSemaphoreWithIndex does (sqExternalSemaphores.c, the same in VM 9 and
	10): a request, its place in the tide in use, and the flag the heartbeat's next check of
	events delivers from. The process must be stopped."

	| slot request |
	(anIndex between: 1 and: (self int32At: (self variables addressOf: 'numSignalRequests')))
		ifFalse: [ ^ self error: 'the VM has no external semaphore ' , anIndex printString ].
	slot := anIndex - 1.
	request := (self variables at: 'signalRequests') + (slot * 8).
	self int32At: request put: (self int32At: request) + 1.
	(self bytesAt: (self variables addressOf: 'useTideA') count: 1) first = 0
		ifTrue: [ self widenTide: 'B' toCover: slot ]
		ifFalse: [ self widenTide: 'A' toCover: slot ].
	self wordAt: (self variables addressOf: 'checkSignalRequests') put: 1
