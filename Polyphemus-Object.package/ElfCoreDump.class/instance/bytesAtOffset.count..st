private
bytesAtOffset: anOffset count: aCount

	"Bytes out of the file, through one open stream and a single cached block.

	Walking a heap reads a few words per object, millions of objects, and always forwards.
	Serving those from a block already in hand turns a syscall per header into one read per
	sixty four kilobytes. A read larger than a block is passed straight through: it is a bulk
	copy, not a walk."

	| start |
	aCount > self blockSize ifTrue: [
		^ self readAt: anOffset count: aCount ].

	(self cacheHolds: anOffset count: aCount) ifTrue: [
		^ cacheBytes
			  copyFrom: anOffset - cacheStart + 1
			  to: anOffset - cacheStart + aCount ].

	start := anOffset // self blockSize * self blockSize.
	cacheBytes := self readAt: start count: self blockSize.
	cacheStart := start.

	^ (self cacheHolds: anOffset count: aCount)
		  ifTrue: [
			  cacheBytes
				  copyFrom: anOffset - cacheStart + 1
				  to: anOffset - cacheStart + aCount ]
		  ifFalse: [ self readAt: anOffset count: aCount ]
