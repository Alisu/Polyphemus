tests
testNoObjectLiesPastWhereTheHeapIsSaidToEnd

	"liveEnd was the heap's start plus the size of its live objects: short of the last one by
	every free chunk before it -- a third of a heap, which VMMaker's walks then missed (#46).
	Only the bridge that closes old space may lie past it."

	self
		assert: (self endOfTheLastLiveObjectIn: dumped raw) - dumped raw liveEnd
		<= dumped memory bridgeSize
