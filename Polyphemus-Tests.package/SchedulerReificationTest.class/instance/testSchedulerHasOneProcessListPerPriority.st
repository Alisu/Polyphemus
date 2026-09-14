tests
testSchedulerHasOneProcessListPerPriority

	"The scheduler keeps an array with one linked list per priority. In the candle
	image nothing is queued: the only process is the one that was running."

	| lists |
	lists := reifiedMemory reifiedProcessLists.

	self assert: lists size equals: 5.
	lists do: [ :each |
		self assert: (reifiedMemory processesInList: each) isEmpty ]
