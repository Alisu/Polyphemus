tests
testActiveProcessIsReachableFromTheScheduler

	"The special objects array holds the association whose value is the one
	ProcessorScheduler; its second slot is the running process, and that process
	keeps the context it was suspended at."

	| active |
	active := reifiedMemory reifiedActiveProcess.

	self assert: active oopClassName equals: 'PCProcess'.
	self assert: (active reifiedSlotAt: 2) oopClassName equals: 'PCMethodContext'
