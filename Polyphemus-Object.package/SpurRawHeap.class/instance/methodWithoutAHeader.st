checking
methodWithoutAHeader

	"Where the walk met a method whose header is no integer, when it was told to expect integers
	(#expectingIntegerMethodHeaders); nil otherwise, or when there is none."

	self heapWalk.
	^ methodWithoutAHeader
