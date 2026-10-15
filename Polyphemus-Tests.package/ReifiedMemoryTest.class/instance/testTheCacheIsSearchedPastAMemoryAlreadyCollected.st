tests
testTheCacheIsSearchedPastAMemoryAlreadyCollected

	"The cache holds memories weakly: a collection between its clean-up and the search leaves a
	nil, which answered nil simulator in random tests and editions (#84)."

	AbstractReifiedMemory cache add: nil.
	[ self assert: (AbstractReifiedMemory cachedFor: Object new) isNil ] ensure: [
		AbstractReifiedMemory cleanupCache ]
