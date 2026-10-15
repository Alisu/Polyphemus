instance creation
on: aMemory
	"we always clean up on creation"
	self cleanupCache.
	^ (self cachedFor: aMemory) ifNil: [ | newMemory |
			newMemory := self new
				memory: aMemory;
				snapshotMemory;
				yourself.
			MemoryCache add: newMemory.
			newMemory ]