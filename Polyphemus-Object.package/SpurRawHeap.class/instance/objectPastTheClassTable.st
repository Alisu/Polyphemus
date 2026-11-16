checking
objectPastTheClassTable

	"Where the walk met an object whose class index is past the class table, when it was told to
	expect none (#expectingClassIndexesInTheClassTable); nil otherwise, or when there is none."

	self heapWalk.
	^ objectPastTheClassTable
