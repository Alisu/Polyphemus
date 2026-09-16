reading the class table
hiddenRootsFrom: anAddress

	"The fifth object of old space: nil, false, true, the free lists, then these. It holds
	the class table's pages and, after them, the collector's obj stacks."

	^ self objectAfter: (self freeListsObjectFrom: anAddress)
