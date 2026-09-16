accessing
liveEnd

	"Where the live objects stop and the allocator's spare room begins."

	^ liveEnd ifNil: [ self findHeap. liveEnd ]
