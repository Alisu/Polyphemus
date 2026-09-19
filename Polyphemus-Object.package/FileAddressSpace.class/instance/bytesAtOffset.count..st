private
bytesAtOffset: anOffset count: aCount

	"Bytes out of the file through one stream and one cached 64 KB block: a heap walk reads a few
	words per object, always forwards. Reads larger than a block go straight through."

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
