instance creation
cachedFor: aMemory

	"The reified memory already made for that simulated memory, or nil. The cache holds them
	weakly: one may be collected during the search itself, and is passed over."

	^ MemoryCache
		  detect: [ :aReifiedMemory | aReifiedMemory notNil and: [ aReifiedMemory simulator = aMemory ] ]
		  ifNone: [ nil ]
