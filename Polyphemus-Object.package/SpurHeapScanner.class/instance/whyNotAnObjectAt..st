walking
whyNotAnObjectAt: anAddress

	"Why nothing can begin here, or nil when something can.

	A class index of zero is not a reason: that is how Spur marks a free chunk, which has a
	header and a size like anything else and which the walk steps over. A live heap is full of
	them -- it is a snapshot, collected before it was written, that holds an uninterrupted run
	of live objects."

	| header size |
	header := self headerAt: anAddress.
	header ifNil: [ ^ #outsideTheRegion ].
	(self classIndexIn: header) > largestClassIndex ifTrue: [ ^ #classIndexTooLarge ].
	(#( 6 7 8 ) includes: (self formatIn: header)) ifTrue: [ ^ #unusedFormat ].
	size := self bytesOfObjectAt: anAddress.
	size ifNil: [ ^ #saturatedCountWithNoOverflowWord ].
	(space hasAddress: anAddress + size - 1) ifFalse: [ ^ #objectRunsPastTheRegion ].
	^ nil
