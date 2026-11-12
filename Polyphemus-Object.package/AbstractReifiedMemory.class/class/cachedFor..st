instance creation
cachedFor: aMemory

	"The reading of this kind already made for that simulated memory, or nil: full and lazy ones
	share the cache (#118). Held weakly, one may be collected during the search, and is passed over."

	^ MemoryCache
		  detect: [ :aReifiedMemory |
			  aReifiedMemory notNil and: [ (aReifiedMemory isKindOf: self) and: [ aReifiedMemory simulator = aMemory ] ] ]
		  ifNone: [ nil ]